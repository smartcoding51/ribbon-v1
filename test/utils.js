const { contract } = require("@openzeppelin/test-environment");
const { ether } = require("@openzeppelin/test-helpers");

const Factory = contract.fromArtifact("Factory");
const Instrument = contract.fromArtifact("Instrument");
const MockERC20 = contract.fromArtifact("MockERC20");
const DToken = contract.fromArtifact("DToken");
const MockDataProvider = contract.fromArtifact("MockDataProvider");

module.exports = {
  getDefaultArgs,
};

async function getDefaultArgs(owner, user) {
  const supply = ether("1000000000000");
  const name = "ETH Future Expiry 12/25/20";
  const symbol = "dETH-1225";
  const expiry = "1608883200";
  const colRatio = ether("1.15");

  const dataProvider = await MockDataProvider.new({ from: owner });
  const factory = await Factory.new(dataProvider.address, { from: owner });
  const colAsset = await MockERC20.new("Dai Stablecoin", "Dai", supply, {
    from: user,
  });
  const targetAsset = await MockERC20.new("Ether", "ETH", supply, {
    from: user,
  });
  const res = await factory.newInstrument(
    name,
    symbol,
    expiry,
    colRatio,
    colAsset.address,
    targetAsset.address,
    { from: owner }
  );

  const instrument = await Instrument.at(res.logs[0].args.instrumentAddress);
  const dToken = await DToken.at(await instrument.dToken());

  const args = {
    supply: supply,
    name: name,
    symbol: symbol,
    expiry: expiry,
    colRatio: colRatio,
  };

  return {
    factory,
    colAsset,
    targetAsset,
    instrument,
    dToken,
    args,
  };
}
