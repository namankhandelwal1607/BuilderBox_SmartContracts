const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  const DealFinal = await ethers.getContractFactory("DealFinal");
  const dealFinal = await DealFinal.deploy("0x2fBBbdE8A3166E83906B91384415fE504Ba6eB4c", "0xCc1Bf82DBaa9d7CDf8705aAF86d4f686CD3ba436", "0xA8EE69F7aF41a441C9CfA7CCf75185F9A1891019","0x79e0329baE1D592a000b9bE49b38F816dD14f337");
  await dealFinal.deployed();

  console.log("DealFinal deployed to:", dealFinal.address);

  return dealFinal.address;
}

main()
  .then(address => {
    console.log(`DealFinal address: ${address}`);
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // 0x731C380E8a64567Eea8d4Ae736B2444f6Ba759E4