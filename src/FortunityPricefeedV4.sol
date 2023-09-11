// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.7.6;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import "../src/interface/ITruflationPricefeed.sol";
import { IPriceFeedV2 } from "@perp/contracts/interface/IPriceFeedV2.sol";
import { BlockContext } from "@perp/contracts/base/BlockContext.sol";
import { CachedTwap } from "@perp/contracts/twap/CachedTwap.sol";

contract FortunityPricefeedV4 is IPriceFeedV2, BlockContext, CachedTwap, Ownable {
    using Address for address;

    ITruflationPricefeed private _aggregator;
    bytes32 public _dataTarget;
    address public _target;
    bool useInternal = false;
    uint256 internalPrice = 0;

    constructor(
        ITruflationPricefeed aggregator, 
        uint80 cacheTwapInterval, 
        bytes32 dataTarget, 
        address target) 
        CachedTwap(cacheTwapInterval) {
        // CPF_ANC: Aggregator address is not contract
        require(address(aggregator).isContract(), "CPF_ANC");

        _aggregator = aggregator;
        _dataTarget = dataTarget;
        _target = target;
    }

    /// @dev anyone can help update it.
    function update() external {
        (, uint256 latestPrice, uint256 latestTimestamp) = _getLatestRoundData();
        bool isUpdated = _update(latestPrice, latestTimestamp);
        // CPF_NU: not updated
        require(isUpdated, "CPF_NU");
    }

    function setSender(address target) external onlyOwner {
        _target = target;
    }

    function setAggregator(ITruflationPricefeed aggregator) external onlyOwner {
        _aggregator = aggregator;
    }

    function setDataType(bytes32 dataType) external onlyOwner {
        _dataTarget = dataType;
    }

    function setUseInternal(bool testingOnly) external onlyOwner {
        useInternal = testingOnly;
    }

    function setInteralPrice(uint256 testingOnly) external onlyOwner {
        internalPrice = testingOnly;
    }

    function cacheTwap(uint256 interval) external override returns (uint256) {
        (uint80 round, uint256 latestPrice, uint256 latestTimestamp) = _getLatestRoundData();

        if (interval == 0 || round == 0) {
            return latestPrice;
        }
        uint256 cachedTwap = _cacheTwap(interval, latestPrice, latestTimestamp);
        return cachedTwap;
    }

    function decimals() external pure override returns (uint8) {
        return 18;
    }

    function getAggregator() external view returns (address) {
        return address(_aggregator);
    }

    function getRoundData(uint80 roundId) external view returns (uint256, uint256) {
        (, int256 price, , uint256 updatedAt, ) = _aggregator.getRoundData(_dataTarget, roundId, _target);

        // CPF_IP: Invalid Price
        require(price > 0, "CPF_IP");

        // CPF_RINC: Round Is Not Complete
        require(updatedAt > 0, "CPF_RINC");

        return (uint256(price), updatedAt);
    }

    function getPrice(uint256 interval) external view override returns (uint256 rvPrice) {
        (uint80 round, uint256 latestPrice, uint256 latestTimestamp) = _getLatestRoundData();
        //TESTING ONLY
        if(!useInternal) {
            if (interval == 0 || round == 0) {
                rvPrice = latestPrice;
            } else {
                rvPrice = _getCachedTwap(interval, latestPrice, latestTimestamp);
            }
            return 100e18 + rvPrice;
        } else {
            rvPrice = internalPrice;
        }
    }

    function _getLatestRoundData()
        private
        view
        returns (
            uint80,
            uint256 finalPrice,
            uint256
        )
    {
        (uint80 round, int256 latestPrice, , uint256 latestTimestamp, ) = 
            _aggregator.latestRoundData(_dataTarget, _target);
        finalPrice = uint256(latestPrice);
        if (latestPrice < 0) {
            _requireEnoughHistory(round);
            (round, finalPrice, latestTimestamp) = _getRoundData(round - 1);
        }
        return (round, finalPrice, latestTimestamp);
    }

    
    function _getRoundData(uint80 _round)
        private
        view
        returns (
            uint80,
            uint256,
            uint256
        )
    {
        (uint80 round, int256 latestPrice, , uint256 latestTimestamp, ) = 
            _aggregator.getRoundData(_dataTarget, _round, _target);
        while (latestPrice < 0) {
            _requireEnoughHistory(round);
            round = round - 1;
            (, latestPrice, , latestTimestamp, ) = _aggregator.getRoundData(_dataTarget, round, _target);
        }
        return (round, uint256(latestPrice), latestTimestamp);
    }

    function _requireEnoughHistory(uint80 _round) private pure {
        // CPF_NEH: no enough history
        require(_round > 0, "CPF_NEH");
    }
}
