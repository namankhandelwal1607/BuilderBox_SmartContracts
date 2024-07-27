const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  const Request = await ethers.getContractFactory("Request");
  const request = await Request.deploy("0x03C199744eC39A05717b56fe245B57Efc20E2092", "0x2fBBbdE8A3166E83906B91384415fE504Ba6eB4c");
  await request.deployed();

  console.log("Request deployed to:", request.address);

  return request.address;
}

main()
  .then(address => {
    console.log(`Request address: ${address}`);
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // 0xA8EE69F7aF41a441C9CfA7CCf75185F9A1891019