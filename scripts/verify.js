const hre = require("hardhat");
require("dotenv").config();

async function main() {
  const contractAddress = process.env.CONTRACT_ADDRESS;
  const marketingWallet = process.env.MARKETING_WALLET || process.env.PRIVATE_WALLET;
  const teamWallet = process.env.TEAM_WALLET || process.env.PRIVATE_WALLET;
  const uniswapRouter = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";

  if (!contractAddress) {
    throw new Error("❌ CONTRACT_ADDRESS missing in .env");
  }

  await hre.run("verify:verify", {
    address: contractAddress,
    constructorArguments: [marketingWallet, uniswapRouter, teamWallet],
  });

  console.log("✅ Contract verified!");
}

main().catch((err) => {
  console.error("❌ Verify failed:", err);
  process.exit(1);
});