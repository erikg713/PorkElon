const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with:", deployer.address);

  const PorkElon = await hre.ethers.getContractFactory("PorkElon");
  const contract = await PorkElon.deploy("0xcf3a14574983317e2339e8b28e9e5caf1e854ba4");

  await contract.deployed();
  console.log("PorkElon deployed to:", contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
