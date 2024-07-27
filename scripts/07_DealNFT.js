const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  const DealNFT = await ethers.getContractFactory("DealNFT");
  const dealNFT = await DealNFT.deploy();
  await dealNFT.deployed();

  console.log("DealNFT deployed to:", dealNFT.address);

  return dealNFT.address;
}

main()
  .then(address => {
    console.log(`DealNFT address: ${address}`);
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // 0x79e0329baE1D592a000b9bE49b38F816dD14f337