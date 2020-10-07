// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

import "./DataProviderInterface.sol";
import "./lib/DSMath.sol";

contract DataProvider is Ownable, DataProviderInterface, DSMath {
    uint constant ETHPrice = 1 * WAD;
    address constant ETHAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    /**
     * @notice Mapping of token address to address of its' Chainlink feed.
     * These Chainlink feeds are Token/ETH feeds.
     */
    mapping(address => address) public chainlinkRegistry;

    /**
     * @notice Adds Chainlink feed to chainlinkRegistry
     * @param _asset is the address of the asset contract
     */
    function addChainlinkFeed(address _asset, address _feed) public onlyOwner {
        chainlinkRegistry[_asset] = _feed;
    }

    /**
     * @notice Gets Chainlink feed from chainlinkRegistry
     * @param _asset is the address of the asset contract
     */
    function getChainlinkFeed(address _asset) public view returns (address _feed) {
        require(chainlinkRegistry[_asset] != address(0), "Feed does not exist in chainlinkRegistry");
        _feed = chainlinkRegistry[_asset];
    }

    /**
     * @notice Gets the latest price of an asset. 
     */
    function getPrice(address _asset) external view override returns(uint){
        // If the asset is ETH, return the ETHPrice constant
        if (_asset == ETHAddress) {
            return ETHPrice;
        }
        // Get price from Chainlink
        address feed = getChainlinkFeed(_asset);
        return getLatestChainlinkPrice(feed);
    }

    /**
     * @notice Internal function that calls Chainlink to get the latest price
     * @return _price is returned in WAD
     */
    function getLatestChainlinkPrice(address _feed) internal view returns (uint) { 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(_feed);
        (,int price,,uint timeStamp,) = priceFeed.latestRoundData();  
        require(price >= 0, "Price is negative");
        // If the round is not complete yet, timestamp is 0
        require(timeStamp > 0, "Round not complete");

        return convertToWAD(uint(price), priceFeed.decimals());
    }

    /**
     * @notice Internal function that converts a price feed to WAD
     */
    function convertToWAD(uint _price, uint8 _decimals) pure internal returns (uint) {
        return mul(_price, 10 ** sub(18, _decimals));
    }
}