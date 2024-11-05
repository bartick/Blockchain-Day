const { ethers } = require("ethers");
const { readFileSync } = require("fs");

const contractAddress = '0x92Bf837AD8a0071f2Ac51EB9c105b477Bc682749';
const providerUrl = 'https://avalanche-fuji-c-chain-rpc.publicnode.com';

const provider = new ethers.JsonRpcProvider(providerUrl);

const abi = JSON.parse(readFileSync('./artifacts/contracts/TokenDepositer.sol/TokenDepositor.json', 'utf8'));

const privateKey = '0xa8643b5c348564542c138d6818b4d49d5ff07da1de9409e5a516607467169bff';
const wallet = new ethers.Wallet(privateKey, provider);

const contract = new ethers.Contract(contractAddress, abi.abi, wallet);

const main = async () => {
    // Deposit tokens
    let tx = await contract.deposit();
    console.log('Transaction hash:', tx.hash);
    await tx.wait();
};

main();
