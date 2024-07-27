const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  const Sequence = await ethers.getContractFactory("Sequence");
  const sequence = await Sequence.deploy("0x2fBBbdE8A3166E83906B91384415fE504Ba6eB4c", "0xA8EE69F7aF41a441C9CfA7CCf75185F9A1891019", "0x03C199744eC39A05717b56fe245B57Efc20E2092");
  await sequence.deployed();

  console.log("Sequence deployed to:", sequence.address);

  return sequence.address;
}

main()
  .then(address => {
    console.log(`Sequence address: ${address}`);
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // 0xCc1Bf82DBaa9d7CDf8705aAF86d4f686CD3ba436