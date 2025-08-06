const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(`📡 Deploying PorkElon from: ${deployer.address}`);
  const marketingWallet = deployer.address;
  const teamWallet = deployer.address;

  const uniswapRouter = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D"; // Uniswap V2

  const PorkElon = await ethers.getContractFactory("PorkElon");

  const contract = await PorkElon.deploy(marketingWallet, uniswapRouter, teamWallet);
  await contract.deployed();

  const totalSupply = await contract.totalSupply();
  const locked = await contract.lockedAmount();
  const unlockTime = await contract.vestingUnlockTime();

  console.log("✅ PorkElon deployed to:", contract.address);
  console.log("🔐 Locked amount:", ethers.utils.formatUnits(locked, 18));
  console.log("⏳ Unlock time:", unlockTime.toString(), `(${new Date(unlockTime * 1000).toLocaleString()})`);

  console.log(`🔍 To verify:`);
  console.log(`npx hardhat verify --network goerli ${contract.address} "${marketingWallet}" "${uniswapRouter}" "${teamWallet}"`);
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exit(1);
});