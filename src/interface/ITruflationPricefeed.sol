// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

interface ITruflationPricefeed {

    function latestRoundData(bytes32 dataType, address sender)
    external
    view
    returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );

    function getRoundData(bytes32 dataType, uint80 roundId_, address sender)
    external
    view
    returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );
}