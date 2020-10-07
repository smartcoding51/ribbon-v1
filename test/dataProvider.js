const { accounts, contract, web3 } = require("@openzeppelin/test-environment");
const { assert } = require("chai");
const {
  ether,
  expectEvent, // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require("@openzeppelin/test-helpers");

const DataProvider = contract.fromArtifact("DataProvider");

describe("DataProvider", function () {
  const [owner] = accounts;
  const asset = "0x0000000000000000000000000000000000000000";
  const feed = "0x0000000000000000000000000000000000000001";
  before(async function () {
    this.contract = await DataProvider.new({ from: owner });
  });

  describe("#addChainlinkFeed", () => {
    it("adds to the feed correctly", async function () {
      await this.contract.addChainlinkFeed(asset, feed, {
        from: owner,
      });

      const res = await this.contract.getChainlinkFeed(asset);
      assert.equal(res, feed);
    });
  });

  describe("#getChainlinkFeed", () => {
    it("fails if feed does not exist", async function () {
      const badAsset = "0x1000000000000000000000000000000000000000";
      const res = this.contract.getChainlinkFeed(badAsset);
      expectRevert(res, "Feed does not exist in chainlinkRegistry");
    });
  });
});
