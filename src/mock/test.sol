// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "../interface/ITruflationPricefeed.sol";

contract SimpleContract {
    ITruflationPricefeed private _aggr;

    constructor(address aggr) {
        _aggr = ITruflationPricefeed(aggr);
    }
    
    function makeCall(bytes32 datatype, address sender) external view returns (uint256) {
        (,int256 price,,,) = _aggr.latestRoundData(datatype, sender);
        return uint256(price);
    }

    function makeRoundCall(bytes32 dataType, address sender, uint80 roundId_) external view returns (uint256) {
        (,int256 price,,,) = _aggr.getRoundData(dataType, roundId_, sender);
        return uint256(price);
    }
}