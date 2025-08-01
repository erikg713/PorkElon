// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PorkElon is ERC20, Ownable {
    uint256 public maxTxAmount;
    uint256 public maxWalletSize;
    uint256 public cooldownTime;
    uint256 public taxFee = 5; // 5% total
    uint256 public burnFee = 1;
    uint256 public liquidityFee = 2;
    uint256 public marketingFee = 2;

    address public marketingWallet;
    mapping(address => uint256) private lastBuyTime;
    mapping(address => bool) public isExcludedFromFees;

    bool public tradingEnabled = false;

    constructor(address _marketingWallet) ERC20("PorkElon", "PORKELON") {
        uint256 totalSupply = 69_000_000_000 * 10 ** decimals();
        _mint(msg.sender, totalSupply);

        maxTxAmount = totalSupply / 100;       // 1%
        maxWalletSize = totalSupply * 2 / 100; // 2%
        cooldownTime = 30;                     // seconds

        marketingWallet = _marketingWallet;
        isExcludedFromFees[msg.sender] = true;
        isExcludedFromFees[address(this)] = true;
        isExcludedFromFees[marketingWallet] = true;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        require(tradingEnabled || isExcludedFromFees[from], "Trading not enabled");

        if (!isExcludedFromFees[from] && !isExcludedFromFees[to]) {
            require(amount <= maxTxAmount, "Exceeds max tx limit");
            if (to != address(this) && to != owner()) {
                require(balanceOf(to) + amount <= maxWalletSize, "Exceeds max wallet");
            }

            if (from == uniswapPair()) {
                require(block.timestamp >= lastBuyTime[to] + cooldownTime, "Cooldown active");
                lastBuyTime[to] = block.timestamp;
            }

            uint256 feeAmount = amount * taxFee / 100;
            uint256 burnAmount = feeAmount * burnFee / taxFee;
            uint256 liquidityAmount = feeAmount * liquidityFee / taxFee;
            uint256 marketingAmount = feeAmount * marketingFee / taxFee;

            super._transfer(from, address(0), burnAmount);            // Burn
            super._transfer(from, address(this), liquidityAmount);    // Hold in contract for LP
            super._transfer(from, marketingWallet, marketingAmount);  // Send to marketing

            amount -= feeAmount;
        }

        super._transfer(from, to, amount);
    }

    function enableTrading() external onlyOwner {
        tradingEnabled = true;
    }

    function updateCooldown(uint256 timeInSeconds) external onlyOwner {
        cooldownTime = timeInSeconds;
    }

    function updateMaxTx(uint256 newMaxTx) external onlyOwner {
        maxTxAmount = newMaxTx;
    }

    function updateMaxWallet(uint256 newMaxWallet) external onlyOwner {
        maxWalletSize = newMaxWallet;
    }

    function setExcludedFromFees(address account, bool excluded) external onlyOwner {
        isExcludedFromFees[account] = excluded;
    }

    function uniswapPair() public view returns (address) {
        // Insert actual DEX pair address here if needed
        return address(0); // placeholder
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
