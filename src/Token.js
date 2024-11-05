const { ethers } = require("ethers");
const { readFileSync } = require("fs");

const contractAddress = '0x7a92FF43FcecD3c998E85F0186b089517D83973C'; // TOKEN A
// const contractAddress = '0x7c91cBc654F3B4A02ABCcB33Eb538352438187B8'; // TOKEN B
const providerUrl = 'https://avalanche-fuji-c-chain-rpc.publicnode.com';

const provider = new ethers.JsonRpcProvider(providerUrl);

const abi = JSON.parse(readFileSync('./artifacts/contracts/Token.sol/SimpleERC20Token.json', 'utf8'));

const privateKey = '0xa8643b5c348564542c138d6818b4d49d5ff07da1de9409e5a516607467169bff';
const wallet = new ethers.Wallet(privateKey, provider);

const contract = new ethers.Contract(contractAddress, abi.abi, wallet);

const main = async () => {
    // Get the balance
    const balance = await contract.balanceOf(wallet.address);
    console.log('Balance:', Number(balance.toString())/1e18);

    const approve = await contract.approve("0x92Bf837AD8a0071f2Ac51EB9c105b477Bc682749", BigInt(10));
    console.log('Approve:', approve.hash);
    await approve.wait();
};

main();
