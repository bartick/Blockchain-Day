// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


module.exports = buildModule("TokenDepositorModule", (m) => {

  const tutorial = m.contract("TokenDepositor", ["0x7a92FF43FcecD3c998E85F0186b089517D83973C", "0x7c91cBc654F3B4A02ABCcB33Eb538352438187B8"]);

  return { tutorial };

});