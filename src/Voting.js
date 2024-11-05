const { ethers } = require("ethers");
const { readFileSync } = require("fs");

const contractAddress = '0x9b077576fD1012e513D18f4d9EddDF752690d396';
const providerUrl = 'https://avalanche-fuji-c-chain-rpc.publicnode.com';

const provider = new ethers.JsonRpcProvider(providerUrl);

const abi = JSON.parse(readFileSync('./artifacts/contracts/Voting.sol/Voting.json', 'utf8'));

const privateKey = '0xa8643b5c348564542c138d6818b4d49d5ff07da1de9409e5a516607467169bff';
const wallet = new ethers.Wallet(privateKey, provider);

const contract = new ethers.Contract(contractAddress, abi.abi, wallet);

const main = async () => {
    // Vote
    let tx = await contract.addCandidate("RCC");
    console.log('Transaction hash add candidate RCC:', tx.hash);
    await tx.wait();
    tx = await contract.addCandidate("NSEC");
    console.log('Transaction hash add candidate NSEC:', tx.hash);
    await tx.wait();

    tx = await contract.registerVoter("0x438b1571abf6F91E6a041687E7DB5f4067e95C5a");
    console.log('Transaction hash register voter:', tx.hash);
    await tx.wait();

    tx = await contract.startVoting();
    console.log('Transaction hash start voting:', tx.hash);
    await tx.wait();

    tx = await contract.vote(BigInt(1));
    console.log('Transaction hash vote 1:', tx.hash);
    await tx.wait();

    tx = await contract.endVoting();
    console.log('Transaction hash end voting:', tx.hash);
    await tx.wait();

    const candidate1 = await contract.getTotalVotes(BigInt(1));
    const candidate2 = await contract.getTotalVotes(BigInt(2));

    console.log('Candidate 1:', Number(candidate1.toString()));
    console.log('Candidate 2:', Number(candidate2.toString()));
};

main();
