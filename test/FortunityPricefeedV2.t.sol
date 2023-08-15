// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/interface/IERC20.sol";
import "../src/interface/ITruflationTester.sol";
import "../src/interface/IFortunityPricefeed.sol";
import "@perp/contracts/interface/IPriceFeedV2.sol";
import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV2V3Interface.sol";
import "../src/FortunityPricefeedV2.sol";

contract FortunityPricefeedTest is Test {
    // Truflation Arbitrum Goerli Aggregator
    address constant aggregator = 0xf992a7c878219238bC3249B6D663e67d6b713A59;

    ChainlinkPriceFeedV2 public pricefeed;

    uint256 arbitrum;

    function setUp() public {
        string memory ARBITRUM_RPC_URL = vm.envString("ARBITRUM_RPC_URL");
        arbitrum = vm.createSelectFork(ARBITRUM_RPC_URL);
    }

    //goerli test
    function testUpdate() public {
        pricefeed = new ChainlinkPriceFeedV2(aggregator);
        value = pricefeed.getPrice(900);
        logStringAndUint("Is this a value? ", value);
        pricefeed.update();
    }

    function logStringAndUint(string memory _string, uint _num) internal {
        emit log(string(abi.encodePacked(_string, vm.toString(_num))));
    }
}
