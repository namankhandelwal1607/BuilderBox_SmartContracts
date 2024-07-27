const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  const Dealer = await ethers.getContractFactory("Dealer");
  const dealer = await Dealer.deploy();
  await dealer.deployed();

  console.log("Dealer deployed to:", dealer.address);

  return dealer.address;
}

main()
  .then(address => {
    console.log(`Dealer address: ${address}`);
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // 0x010D1f4Ba2C7128F471957e5B39eF28b0bb8Fd24