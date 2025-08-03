// SPDX-License-Identifier: MIT pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; import "@openzeppelin/contracts/access/Ownable.sol"; import "@openzeppelin/contracts/security/Pausable.sol";

contract PorkElonToken is ERC20, Ownable, Pausable { uint256 public constant TOTAL_SUPPLY = 60_000_000_000 * 10 ** 18; uint256 public constant MAX_TX_PERCENT = 1; uint256 public constant MAX_WALLET_PERCENT = 2; uint256 public constant COOLDOWN_SECONDS = 30; uint256 public constant FEE_PERCENT = 2;

address public marketingWallet;
bool public tradingOpen = false;

mapping(address => bool) public isExcluded;
mapping(address => uint256) private lastTxTimestamp;

constructor(address _marketingWallet) ERC20("PorkElon", "PORKELON") {
    _mint(msg.sender, TOTAL_SUPPLY);
    marketingWallet = _marketingWallet;
    isExcluded[msg.sender] = true;
    isExcluded[address(this)] = true;
    isExcluded[_marketingWallet] = true;
}

function _transfer(address from, address to, uint256 amount) internal override {
    require(tradingOpen || isExcluded[from] || isExcluded[to], "Trading not open");

    if (!isExcluded[from]) {
        require(block.timestamp - lastTxTimestamp[from] >= COOLDOWN_SECONDS, "Cooldown in effect");
        require(amount <= (TOTAL_SUPPLY * MAX_TX_PERCENT) / 100, "Exceeds max tx");
        lastTxTimestamp[from] = block.timestamp;
    }

    if (!isExcluded[to]) {
        require(balanceOf(to) + amount <= (TOTAL_SUPPLY * MAX_WALLET_PERCENT) / 100, "Exceeds max wallet");
    }

    uint256 fee = isExcluded[from] || isExcluded[to] ? 0 : (amount * FEE_PERCENT) / 100;
    uint256 amountAfterFee = amount - fee;

    if (fee > 0) {
        super._transfer(from, marketingWallet, fee);
    }

    super._transfer(from, to, amountAfterFee);
}

function setTradingOpen(bool _status) external onlyOwner {
    tradingOpen = _status;
}

function setExcluded(address _addr, bool _excluded) external onlyOwner {
    isExcluded[_addr] = _excluded;
}

function setMarketingWallet(address _wallet) external onlyOwner {
    marketingWallet = _wallet;
    isExcluded[_wallet] = true;
}

function pause() external onlyOwner {
    _pause();
}

function unpause() external onlyOwner {
    _unpause();
}

}

