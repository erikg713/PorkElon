const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const tokenAddress = process.env.CONTRACT_ADDRESS;
  const [signer] = await ethers.getSigners();

  const token = await ethers.getContractAt("IERC20", tokenAddress, signer);
  const router = await ethers.getContractAt("IUniswapV2Router02", "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D", signer);

  const tokenAmount = ethers.utils.parseUnits("60000000000", 18); // 60B PORK
  const ethAmount = ethers.utils.parseEther("0.1");               // 0.1 ETH

  console.log("🔑 Approving token...");
  await token.approve(router.address, tokenAmount);

  console.log("💧 Adding liquidity...");
  const deadline = Math.floor(Date.now() / 1000) + 60 * 10;
  const tx = await router.addLiquidityETH(
    tokenAddress,
    tokenAmount,
    0,
    0,
    signer.address,
    deadline,
    { value: ethAmount }
  );

  await tx.wait();
  console.log("✅ Liquidity added!");
}

main().catch((err) => {
  console.error("❌ Liquidity failed:", err);
  process.exit(1);
});