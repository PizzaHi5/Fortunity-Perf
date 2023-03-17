// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import "forge-std/Script.sol";
import "../src/TruflationTester.sol";
import "../src/interface/IERC20.sol";

contract TruflationTesterScript is Script {

    address constant oracleId = 0x6888BdA6a975eCbACc3ba69CA2c80d7d7da5A344;
    string constant jobId = "d220e5e687884462909a03021385b7ae"; 
    uint256 constant fee = 500000000000000000;
    address constant token = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;

    // forge script script/TruflationTester.s.sol:TruflationTesterScript --rpc-url $GOERLI_RPC_URL 
    // --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_RPC_URL -vvvv

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        TruflationTesterV1 eg = new TruflationTesterV1(
            oracleId, jobId, fee, token
        );
        IERC20(token).transfer(address(eg), 2e18);

        //eg.requestInflationWei();

        //eg.withdrawLink();
        vm.stopBroadcast();    
    }
}
