// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.7.6;

import "@perp/contracts/interface/IPriceFeedV2.sol";

interface IFortunityPricefeed is IPriceFeedV2 {
    // Return current price in wei
    function getInflationWei() external view returns (int256);

    // @perp-oracle-contract
    function cacheTwap(uint256 interval) external override returns (uint256);
    
    // @perp-oracle-contract
    function decimals() external view override returns (uint8);

    // @perp-oracle-contract
    function getPrice(uint256 interval) external view override returns (uint256);
}