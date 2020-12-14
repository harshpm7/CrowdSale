const CodeZ = artifacts.require("CodeZ");
const CrowdSale = artifacts.require("CrowdSale");

module.exports = async function (deployer) {
  const totalSupply = 10000000; //10M

  //Token(CodeZ)
  await deployer.deploy(
    CodeZ,
    'CodeZ',         //name
    '$CZS',          //symbol
    totalSupply
  );
  const token = await CodeZ.deployed();

  //ICO(CrowdSale)
  await deployer.deploy(
    CrowdSale,
    token.address                 
  );
  const ico = await CrowdSale.deployed();
  await token.updateAdmin(ico.address);
};