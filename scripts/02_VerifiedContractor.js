const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  const VerifiedContractor = await ethers.getContractFactory("VerifiedContractor");
  const verifiedContractor = await VerifiedContractor.deploy("0xC76438615bB13d43978A3E0D53772278ec474156");
  await verifiedContractor.deployed();

  console.log("VerifiedContractor deployed to:", verifiedContractor.address);

  return verifiedContractor.address;
}

main()
  .then(address => {
    console.log(`VerifiedContractor address: ${address}`);
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  // 0x03C199744eC39A05717b56fe245B57Efc20E2092