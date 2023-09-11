// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import "forge-std/Test.sol";
import "@perp/contracts/interface/IPriceFeedV2.sol";
//import "@chainlink/contracts/src/v0.7/interfaces/AggregatorV3Interface.sol";
import "../src/FortunityPricefeedV2.sol";
import "../src/interface/ITruflationPricefeed.sol";
import "../src/mock/test.sol";

contract FortunityPricefeedTest is Test {
    // Truflation Arbitrum Goerli Aggregator
    address constant aggregator = 0x4a4588Eaa43c3C0694F7b8Ade7521ac5b42120Fe;
    address constant ethAggregator = 0x62CAe0FA2da220f43a51F86Db2EDb36DcA9A5A08;

    // FortunityPricefeed onchain
    address constant pricefeeder = 0x378C56781c090e245203389927766e078f57e500;

    FortunityPricefeedV2 public pricefeed;
    bytes32 usCPI = 0x747275666c6174696f6e2e6370692e7573000000000000000000000000000000;
    address target = 0x378C56781c090e245203389927766e078f57e500;

    uint256 arbitrum;

    function setUp() public {
        string memory ARBITRUM_RPC_URL = vm.envString("ARBITRUM_RPC_URL");
        arbitrum = vm.createSelectFork(ARBITRUM_RPC_URL);
    }

    function testGetTruflationData() public {
        //reference events in onchain Truflation pricefeed
        (,int256 answer,,,) = ITruflationPricefeed(aggregator).latestRoundData(usCPI, target);
        logStringAndUint("This is the Truflation US_CPI today: ", uint256(answer));
    }

    //test simple call
    function testSimpleContract() public {
        SimpleContract simple = new SimpleContract(aggregator);
        uint price = simple.makeCall(usCPI, target);
        logStringAndUint("Using simple, US CPI = ", price);

        //uint80 roundId = ITruflationPricefeed()
        //simple.makeRoundCall(dataType, sender, roundId_);
    }

    //test fully implemented call
    function testGetDataUsingIPriceFeedV2() public {
        pricefeed = new FortunityPricefeedV2(
            ITruflationPricefeed(aggregator),
            900,
            usCPI,
            target
        );
        uint price = IPriceFeedV2(pricefeed).getPrice(900);
        logStringAndUint("US CPI = ", price);
    }

    //goerli test
    //function testUpdate() public {
    //    pricefeed = new ChainlinkPriceFeedV2(AggregatorV3Interface(aggregator), 900);
    //    emit log_address(address(pricefeed));
    //   uint value = pricefeed.getPrice(900);
    //    logStringAndUint("Is this a value? ", value);
    //    pricefeed.update();
    //}

    //function testRegularCall() public {
    //    pricefeed = new ChainlinkPriceFeedV2(AggregatorV3Interface(ethAggregator), 900);
    //    uint value = pricefeed.getPrice(900);
    //    logStringAndUint("Is this a value? ", value);
    //}

    function logStringAndUint(string memory _string, uint _num) internal {
        emit log(string(abi.encodePacked(_string, vm.toString(_num))));
    }
}