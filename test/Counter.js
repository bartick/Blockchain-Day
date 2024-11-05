const { ethers } = require("hardhat");

async function main() {
  const [owner, otherAccount] = await ethers.getSigners();

  const Counter = await ethers.getContractFactory("Counter");
  const counter = await Counter.deploy();

  const currentValue = await counter.get();
  console.log("Initial Number:", Number(currentValue));

  await counter.inc();
  await counter.inc();
  console.log("Increase Number:", Number(await counter.get()));

  await counter.dec();
  console.log("Decrease Number: ", Number(await counter.get()));

}

main();