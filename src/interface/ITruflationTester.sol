// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;

interface ITruflationTester {
    function getinflationWei() external view returns (int256);
    
    function requestInflationWei() external returns (bytes32 requestId);
}