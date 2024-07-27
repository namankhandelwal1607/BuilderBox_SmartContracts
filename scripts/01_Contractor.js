const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const Contractor = await ethers.getContractFactory("Contractor");
  const contractor = await Contractor.deploy();
  await contractor.deployed();

  console.log("Contractor deployed to:", contractor.address);

  return contractor.address;
}

main()
  .then(address => {
    console.log(`Contractor address: ${address}`);
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // 0xC76438615bB13d43978A3E0D53772278ec474156