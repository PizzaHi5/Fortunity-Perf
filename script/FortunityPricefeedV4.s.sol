// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

import "forge-std/Script.sol";
import "../src/FortunityPricefeedV4.sol";
import "../src/interface/ITruflationPricefeed.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FortunityPricefeedV4Script is Script {
    /// @dev This is for arbitrum goerli deployment
    address truflationAggregator = 0x4a4588Eaa43c3C0694F7b8Ade7521ac5b42120Fe;
    bytes32 dataType = 0x747275666c6174696f6e2e6370692e7573000000000000000000000000000000;
    address sender = 0x378C56781c090e245203389927766e078f57e500;

    uint80 cacheTwap = 900;

    FortunityPricefeedV4 public eg;

    // testnet:
    // forge script script/FortunityPricefeedV4.s.sol:FortunityPricefeedV4Script --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_RPC_URL -vvvv
    // example: 0x314fd64Cf2Eb30d0a8d8229471dAf3bB89944827

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        eg = new FortunityPricefeedV4(
            ITruflationPricefeed(truflationAggregator),
            cacheTwap,
            dataType,
            sender);

        vm.stopBroadcast();    
    }
}
