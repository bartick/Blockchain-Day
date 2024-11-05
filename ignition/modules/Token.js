// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


module.exports = buildModule("TokenModule", (m) => {

  const tutorial = m.contract("SimpleERC20Token", ["Token", "TKN", 18, 1000000]);

  return { tutorial };

});