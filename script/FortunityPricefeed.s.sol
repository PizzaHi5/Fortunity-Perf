// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/FortunityPricefeed.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FortunityPricefeedScript is Script {
    /// @dev Change deployment details below based on network
    //goerli oracle
    address constant oracleId = 0x6888BdA6a975eCbACc3ba69CA2c80d7d7da5A344;
    //mumbai oracle
    address constant mumbOracleId = 0x6D141Cf6C43f7eABF94E288f5aa3f23357278499;

    string constant jobId = "d220e5e687884462909a03021385b7ae"; 
    uint256 constant fee = 500000000000000000;
    address constant token = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;

    FortunityPricefeed public eg;

    // testnet:
    // forge script script/FortunityPricefeed.s.sol:FortunityPricefeedScript --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_RPC_URL -vvvv
    // example: 0x314fd64Cf2Eb30d0a8d8229471dAf3bB89944827

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Creates contract
        eg = new FortunityPricefeed(mumbOracleId, jobId, fee, token);

        // Funds contract
        IERC20(token).transfer(address(eg), 3e18);

        // Starts data request, will not succeed when simulated locally
        // eg.requestInflationWei();

        vm.stopBroadcast();    
    }
}
