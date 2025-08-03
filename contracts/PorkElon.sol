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

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract PorkElon is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    using Address for address payable;

    uint256 public maxTxAmount;
    uint256 public maxWalletSize;
    uint256 public cooldownTime;

    uint256 public marketingFee = 3; // 3%
    bool public swapEnabled = true;
    bool public inSwap;

    address public marketingWallet;

    mapping(address => bool) public isExcludedFromFees;
    mapping(address => uint256) private _lastTransferTimestamp;

    IUniswapV2Router02 public uniswapRouter;
    address public uniswapPair;

    modifier lockSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor(address _marketingWallet, address _router) ERC20("PorkElon", "PORKELON") {
        uint256 total = 69_000_000_000 * 10 ** decimals();
        _mint(msg.sender, total);

        maxTxAmount = total / 100;       // 1%
        maxWalletSize = total * 2 / 100; // 2%
        cooldownTime = 30;               // 30s

        marketingWallet = _marketingWallet;

        isExcludedFromFees[msg.sender] = true;
        isExcludedFromFees[address(this)] = true;
        isExcludedFromFees[marketingWallet] = true;

        IUniswapV2Router02 _uni = IUniswapV2Router02(_router);
        uniswapRouter = _uni;

        address pair = IUniswapV2Factory(_uni.factory()).createPair(address(this), _uni.WETH());
        uniswapPair = pair;
        isExcludedFromFees[uniswapPair] = true;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        if (!isExcludedFromFees[from] && !isExcludedFromFees[to]) {
            require(amount <= maxTxAmount, "Max TX exceeded");
            if (to != uniswapPair && to != address(this)) {
                require(balanceOf(to) + amount <= maxWalletSize, "Max wallet exceeded");
                require(block.timestamp >= _lastTransferTimestamp[from] + cooldownTime, "Cooldown active");
                _lastTransferTimestamp[from] = block.timestamp;
            }

            uint256 feeAmount = (amount * marketingFee) / 100;
            uint256 transferAmount = amount - feeAmount;

            super._transfer(from, address(this), feeAmount);
            super._transfer(from, to, transferAmount);

            if (swapEnabled && !inSwap && from != uniswapPair) {
                _swapAndSendToMarketing();
            }
        } else {
            super._transfer(from, to, amount);
        }
    }

    function _swapAndSendToMarketing() private lockSwap {
        uint256 tokenBalance = balanceOf(address(this));
        if (tokenBalance == 0) return;

        _approve(address(this), address(uniswapRouter), tokenBalance);

        address ;
        path[0] = address(this);
        path[1] = uniswapRouter.WETH();

        try uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenBalance,
            0,
            path,
            address(this),
            block.timestamp
        ) {
            uint256 ethBalance = address(this).balance;
            if (ethBalance > 0) {
                payable(marketingWallet).sendValue(ethBalance);
            }
        } catch {
            // swallow failures to avoid revert
        }
    }

    // 🔧 Admin Controls

    function setMarketingFee(uint256 fee) external onlyOwner {
        require(fee <= 10, "Fee too high");
        marketingFee = fee;
    }

    function updateLimits(uint256 txPercent, uint256 walletPercent, uint256 cooldownSecs) external onlyOwner {
        uint256 supply = totalSupply();
        maxTxAmount = supply * txPercent / 100;
        maxWalletSize = supply * walletPercent / 100;
        cooldownTime = cooldownSecs;
    }

    function setMarketingWallet(address wallet) external onlyOwner {
        marketingWallet = wallet;
    }

    function setSwapEnabled(bool enabled) external onlyOwner {
        swapEnabled = enabled;
    }

    function excludeFromFees(address addr, bool excluded) external onlyOwner {
        isExcludedFromFees[addr] = excluded;
    }

    receive() external payable {}
}