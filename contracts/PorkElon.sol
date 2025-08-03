// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PorkElon is ERC20, Ownable {
    uint256 public maxTxAmount;
    uint256 public maxWalletSize;
    uint256 public cooldownTime;
    uint256 public marketingFee; // in %

    address public marketingWallet;

    mapping(address => bool) public isExcludedFromFees;
    mapping(address => uint256) private _lastTransferTimestamp;

    event LimitsUpdated(uint256 maxTx, uint256 maxWallet, uint256 cooldown);
    event ExcludedFromFees(address indexed account, bool isExcluded);
    event MarketingWalletUpdated(address indexed newWallet);
    event MarketingFeeUpdated(uint256 newFee);

    constructor(address _marketingWallet) ERC20("PorkElon", "PORKELON") {
        uint256 totalSupply = 69_000_000_000 * 10 ** decimals();
        _mint(msg.sender, totalSupply);

        maxTxAmount = totalSupply / 100;       // 1%
        maxWalletSize = totalSupply * 2 / 100; // 2%
        cooldownTime = 30;                     // 30 seconds

        marketingFee = 2;                      // 2%
        marketingWallet = _marketingWallet;

        isExcludedFromFees[msg.sender] = true;
        isExcludedFromFees[address(this)] = true;
        isExcludedFromFees[marketingWallet] = true;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        if (!isExcludedFromFees[from] && !isExcludedFromFees[to]) {
            require(amount <= maxTxAmount, "Exceeds max tx limit");
            require(balanceOf(to) + amount <= maxWalletSize, "Exceeds max wallet size");
            require(block.timestamp >= _lastTransferTimestamp[from] + cooldownTime, "Cooldown: wait");

            _lastTransferTimestamp[from] = block.timestamp;

            uint256 feeAmount = (amount * marketingFee) / 100;
            super._transfer(from, marketingWallet, feeAmount);
            amount -= feeAmount;
        }

        super._transfer(from, to, amount);
    }

    function updateLimits(uint256 _maxTxPercent, uint256 _maxWalletPercent, uint256 _cooldownSeconds) external onlyOwner {
        uint256 total = totalSupply();
        maxTxAmount = total * _maxTxPercent / 100;
        maxWalletSize = total * _maxWalletPercent / 100;
        cooldownTime = _cooldownSeconds;
        emit LimitsUpdated(maxTxAmount, maxWalletSize, cooldownTime);
    }

    function excludeFromFees(address account, bool excluded) external onlyOwner {
        isExcludedFromFees[account] = excluded;
        emit ExcludedFromFees(account, excluded);
    }

    function updateMarketingWallet(address newWallet) external onlyOwner {
        marketingWallet = newWallet;
        emit MarketingWalletUpdated(newWallet);
    }

    function setMarketingFee(uint256 fee) external onlyOwner {
        require(fee <= 10, "Fee too high");
        marketingFee = fee;
        emit MarketingFeeUpdated(fee);
    }
}