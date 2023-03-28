// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.7.6;

interface IFortunityPricefeed {
    // Return current price in wei
    function getInflationWei() external view returns (int256);
    
}