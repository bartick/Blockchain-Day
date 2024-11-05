const { ethers } = require("ethers");
const { readFileSync } = require("fs");

const contractAddress = '0xE2FAeCf0e696aC743Aa5D2C9CbAFC922484A5F0C';
const providerUrl = 'https://avalanche-fuji-c-chain-rpc.publicnode.com';

const provider = new ethers.JsonRpcProvider(providerUrl);

const abi = JSON.parse(readFileSync('./artifacts/contracts/Counter.sol/Counter.json', 'utf8'));

const privateKey = '0xa8643b5c348564542c138d6818b4d49d5ff07da1de9409e5a516607467169bff';
const wallet = new ethers.Wallet(privateKey, provider);

const contract = new ethers.Contract(contractAddress, abi.abi, wallet);

const main = async () => {
    // Get the current count
    const count = await contract.get();
    console.log('Current count:', Number(count));

    // Increment the count
    const tx = await contract.inc();
    console.log('Transaction hash:', tx.hash);

    // Wait for the transaction to be mined
    await tx.wait();

    // Get the new count
    const newCount = await contract.get();
    console.log('New count:', Number(newCount));

    // Decrement the count
    const tx2 = await contract.dec();
    console.log('Transaction hash:', tx2.hash);

    // Wait for the transaction to be mined
    await tx2.wait();

    // Get the new count
    const newCount2 = await contract.get();
    console.log('New count:', Number(newCount2));
};

main();
