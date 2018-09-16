var Ecosystem = artifacts.require("./Ecosystem.sol");

module.exports = function(deployer) {
  deployer.deploy(Ecosystem);
};
