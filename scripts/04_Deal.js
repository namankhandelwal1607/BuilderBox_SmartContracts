const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  const Deal = await ethers.getContractFactory("Deal");
  const deal = await Deal.deploy("0x010D1f4Ba2C7128F471957e5B39eF28b0bb8Fd24");
  await deal.deployed();

  console.log("Deal deployed to:", deal.address);

  return deal.address;
}

main()
  .then(address => {
    console.log(`Deal address: ${address}`);
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // 0x2fBBbdE8A3166E83906B91384415fE504Ba6eB4c