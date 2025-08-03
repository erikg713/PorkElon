const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with:", deployer.address);

  const PorkElon = await hre.ethers.getContractFactory("PorkElon");
  const contract = await PorkElon.deploy("0xYourMarketingWalletHere");

  await contract.deployed();
  console.log("PorkElon deployed to:", contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
