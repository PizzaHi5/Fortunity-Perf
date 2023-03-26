// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/TruflationTester.sol";
import "../src/interface/IERC20.sol";
import "../src/interface/ITruflationTester.sol";

/**
    @dev Note: To test locally, this would require a mock chainlink node contract and/or TfiOperator
 */

contract TruflationTesterTest is Test {
    uint256 goerli;

    TruflationTesterV1 public eg;
    // 0x6888BdA6a975eCbACc3ba69CA2c80d7d7da5A344 //proxy
    // 0x25A9606f95e0c37B51cBF922dD33f659c2ED3718 //imple
    address constant oracleId = 0x6888BdA6a975eCbACc3ba69CA2c80d7d7da5A344;
    string constant jobId = "d220e5e687884462909a03021385b7ae"; 
    uint256 constant fee = 500000000000000000;
    address constant token = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;

    address constant austin = 0x096f6A2b185d63D942750A2D961f7762401cbA17;

    address constant testnetTester = 0x2534D71D353A97Cdd11a3C2BcCe90f84f58eCC5e;

    function setUp() public {
        string memory GOERLI_RPC_URL = vm.envString("GOERLI_RPC_URL");
        goerli = vm.createSelectFork(GOERLI_RPC_URL);

        eg = new TruflationTesterV1(oracleId, jobId, fee, token);

        vm.prank(austin);
        IERC20(token).transfer(address(eg), 5000000000000000000);
    }

    function testRequestInflationWei() public {
        assertEq(IERC20(token).balanceOf(address(eg)), 5000000000000000000);

        // Never finishes executing
        //eg.requestInflationWei();

        //Interface test
        //int amount = ITruflationTester(testnetTester).getinflationWei();

        //console.log(vm.toString(amount));
    }

    function testGetValueThruInterface() public {
        int amount = ITruflationTester(testnetTester).getinflationWei();
        console.log(vm.toString(amount));
    }

}
