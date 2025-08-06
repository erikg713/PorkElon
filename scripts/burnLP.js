const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const [signer] = await ethers.getSigners();
  const tokenAddress = process.env.CONTRACT_ADDRESS;
  const router = await ethers.getContractAt("IUniswapV2Router02", "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D", signer);
  const factoryAddress = await router.factory();
  const factory = await ethers.getContractAt("IUniswapV2Factory", factoryAddress, signer);

  const WETH = "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6"; // Goerli WETH
  const lpAddress = await factory.getPair(tokenAddress, WETH);
  const lpToken = await ethers.getContractAt("IERC20", lpAddress, signer);

  const lpBalance = await lpToken.balanceOf(signer.address);
  if (lpBalance.isZero()) throw new Error("❌ No LP tokens to burn");

  console.log(`🔥 Burning ${ethers.utils.formatUnits(lpBalance, 18)} LP tokens...`);
  const tx = await lpToken.transfer("0x000000000000000000000000000000000000dEaD", lpBalance);
  await tx.wait();
  console.log("✅ LP tokens burned.");
}

main().catch((err) => {
  console.error("❌ Burn failed:", err);
  process.exit(1);
});