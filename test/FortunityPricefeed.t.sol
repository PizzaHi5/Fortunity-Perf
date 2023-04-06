// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/interface/IERC20.sol";
import "../src/interface/ITruflationTester.sol";
import "../src/interface/IFortunityPricefeed.sol";
import "@perp/contracts/interface/IPriceFeedV2.sol";

/**
    @dev To run this, you must first deploy the 0.8.x version TruflationTester.
        Take the output address and use it as input for the test. 
 */

contract FortunityPricefeedTest is Test {
    // First Iteration, input goerli address 
    address constant tester = 0x2534D71D353A97Cdd11a3C2BcCe90f84f58eCC5e;

    // Second Iteration, input goerli address
    address constant pricefeed = 0x652d2a4AcB7630AB96CC9f291e810EcbB0707D0C;

    // Copy 2nd Iteration, input mumbai address
    address constant mumbPriceFeed = 0xB6300897c7c392022f0068F65C382d334FBC692C;

    uint256 goerli;
    uint256 mumbai;

    address constant token = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;

    address constant austin = 0x096f6A2b185d63D942750A2D961f7762401cbA17;

    function setUp() public {
        string memory GOERLI_RPC_URL = vm.envString("GOERLI_RPC_URL");
        string memory MUMBAI_RPC_URL = vm.envString("MUMBAI_RPC_URL");
        goerli = vm.createSelectFork(GOERLI_RPC_URL);
        mumbai = vm.createFork(MUMBAI_RPC_URL);

        vm.prank(austin);
        IERC20(token).transfer(tester, 5e18);
    }

    //goerli test
    function testGetValueThruFortInterface() public {
        int amount = ITruflationTester(tester).getinflationWei();
        console.log(vm.toString(amount));
        assertGt(amount, int256(1e17));
        
        int price = amount + 100e18;
        console.log(vm.toString(price));
    }

    //goerli test
    function testGoerliPerpInterface() public {
        uint amount = IPriceFeedV2(pricefeed).getPrice(0);
        console.log(vm.toString(amount));
        assertGt(amount, uint256(1e19));
    }

    //mumbai test
    function testMumbaiPerpInterface() public {
        vm.selectFork(mumbai);
        uint amount = IPriceFeedV2(mumbPriceFeed).getPrice(0);
        console.log(vm.toString(amount));
        assertGt(amount, uint256(1e19));
    }
}
