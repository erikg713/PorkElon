// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

contract PorkElon is ERC20, ERC20Burnable, Ownable, ReentrancyGuard {
    using Address for address payable;

    uint256 public maxTxAmount;
    uint256 public maxWalletSize;
    uint256 public cooldownTime;

    uint256 public marketingFee = 0; // Optional
    uint256 public autoBurnFee = 2;  // 🔥 2% default
    bool public autoBurnEnabled = true;
    bool public swapEnabled = true;
    bool public inSwap;

    address public marketingWallet;
    address public teamWallet;

    mapping(address => bool) public isExcludedFromFees;
    mapping(address => bool) public isBlacklisted;
    mapping(address => uint256) private _lastTransferTimestamp;

    uint256 public vestingUnlockTime;

    IUniswapV2Router02 public uniswapRouter;
    address public uniswapPair;

    modifier lockSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor(address _marketingWallet, address _router, address _teamWallet)
        ERC20("PorkElon", "PORKELON")
    {
        uint256 total = 69_000_000_000 * 10 ** decimals();
        _mint(msg.sender, total);

        maxTxAmount = total / 100;       // 1%
        maxWalletSize = total * 2 / 100; // 2%
        cooldownTime = 30;

        marketingWallet = _marketingWallet;
        teamWallet = _teamWallet;
        vestingUnlockTime = block.timestamp + 365 days;

        isExcludedFromFees[msg.sender] = true;
        isExcludedFromFees[address(this)] = true;
        isExcludedFromFees[_marketingWallet] = true;

        IUniswapV2Router02 _uni = IUniswapV2Router02(_router);
        uniswapRouter = _uni;

        address pair = IUniswapV2Factory(_uni.factory()).createPair(address(this), _uni.WETH());
        uniswapPair = pair;
        isExcludedFromFees[uniswapPair] = true;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        require(!isBlacklisted[from] && !isBlacklisted[to], "Blacklisted");

        if (!isExcludedFromFees[from] && !isExcludedFromFees[to]) {
            require(amount <= maxTxAmount, "Max TX exceeded");
            if (to != uniswapPair && to != address(this)) {
                require(balanceOf(to) + amount <= maxWalletSize, "Max wallet exceeded");
                require(block.timestamp >= _lastTransferTimestamp[from] + cooldownTime, "Cooldown active");
                _lastTransferTimestamp[from] = block.timestamp;
            }

            uint256 feeTotal;
            uint256 marketingAmt = 0;
            uint256 burnAmt = 0;

            if (marketingFee > 0) {
                marketingAmt = (amount * marketingFee) / 100;
                feeTotal += marketingAmt;
                super._transfer(from, address(this), marketingAmt);
            }

            if (autoBurnEnabled && autoBurnFee > 0) {
                burnAmt = (amount * autoBurnFee) / 100;
                feeTotal += burnAmt;
                _burn(from, burnAmt);
            }

            uint256 sendAmount = amount - feeTotal;
            super._transfer(from, to, sendAmount);

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
            tokenBalance, 0, path, address(this), block.timestamp
        ) {
            uint256 eth = address(this).balance;
            if (eth > 0) {
                payable(marketingWallet).sendValue(eth);
            }
        } catch {
            // no revert
        }
    }

    // 🔧 Admin Functions

    function setFees(uint256 _marketing, uint256 _burn) external onlyOwner {
        require(_marketing + _burn <= 10, "Total fee too high");
        marketingFee = _marketing;
        autoBurnFee = _burn;
    }

    function toggleAutoBurn(bool enabled) external onlyOwner {
        autoBurnEnabled = enabled;
    }

    function updateLimits(uint256 txPct, uint256 walletPct, uint256 cooldownSecs) external onlyOwner {
        uint256 supply = totalSupply();
        maxTxAmount = supply * txPct / 100;
        maxWalletSize = supply * walletPct / 100;
        cooldownTime = cooldownSecs;
    }

    function setSwapEnabled(bool enabled) external onlyOwner {
        swapEnabled = enabled;
    }

    function excludeFromFees(address addr, bool excluded) external onlyOwner {
        isExcludedFromFees[addr] = excluded;
    }

    function blacklist(address addr, bool value) external onlyOwner {
        isBlacklisted[addr] = value;
    }

    function withdrawLockedTokens() external nonReentrant onlyOwner {
        require(block.timestamp >= vestingUnlockTime, "Vesting active");
        uint256 bal = balanceOf(address(this));
        require(bal > 0, "Nothing to withdraw");
        _transfer(address(this), teamWallet, bal);
    }

    function setMarketingWallet(address addr) external onlyOwner {
        marketingWallet = addr;
    }

    function setTeamWallet(address addr) external onlyOwner {
        teamWallet = addr;
    }

    // ✅ Mintable Function (Owner Only)
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    receive() external payable {}
}