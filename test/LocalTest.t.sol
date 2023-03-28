// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/interface/IERC20.sol";
import "../src/interface/ITruflationTester.sol";

/**
    @dev To run this, you must first deploy the 0.8.x version TruflationTester in anvil.
        Take the output address and use it as input for the test. 
 */

contract TruflationTesterTest is Test {
    // Change this to output address
    address constant priceFeed = 0x2534D71D353A97Cdd11a3C2BcCe90f84f58eCC5e;

    uint256 goerli;

    address constant oracleId = 0x6888BdA6a975eCbACc3ba69CA2c80d7d7da5A344;
    string constant jobId = "d220e5e687884462909a03021385b7ae"; 
    uint256 constant fee = 500000000000000000;
    address constant token = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;

    address constant austin = 0x096f6A2b185d63D942750A2D961f7762401cbA17;

    function setUp() public {
        string memory GOERLI_RPC_URL = vm.envString("GOERLI_RPC_URL");
        goerli = vm.createSelectFork(GOERLI_RPC_URL);

        vm.prank(austin);
        IERC20(token).transfer(priceFeed, 5000000000000000000);
    }

    function testRequestInflationWei() public {
        //assertEq(IERC20(token).balanceOf(priceFeed), 5000000000000000000);

        // Never finishes executing
        //priceFeed.requestInflationWei();
    }

    function testGetValueThruInterface() public {
        int amount = ITruflationTester(priceFeed).getinflationWei();
        console.log(vm.toString(amount));
        assertGt(amount, int256(1e17));
        
        int price = amount + 100e18;
        console.log(vm.toString(price));
    }

}
