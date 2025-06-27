const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const ChatApp = await hre.ethers.getContractFactory("ChatApp");
  const chatApp = await ChatApp.deploy();

  await chatApp.deployed();

  console.log("ChatApp deployed to:", chatApp.address);

  const Staking = await hre.ethers.getContractFactory("Staking");
  const staking = await Staking.deploy(chatApp.address);

  console.log("Staking deployed to:", staking.address);
}
main.catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
