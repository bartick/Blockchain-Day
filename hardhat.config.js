require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.26",
  networks: {
    fuji: {
      url: "https://avalanche-fuji-c-chain-rpc.publicnode.com",
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
