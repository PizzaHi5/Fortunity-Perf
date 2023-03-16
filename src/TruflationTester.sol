// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;

import "./interface/ITruflationTester.sol";
import { Strings } from "./lib/FortStrings.sol";
import { ChainlinkClient } from "@chainlink/contracts/src/v0.7/ChainlinkClient.sol";
import { ConfirmedOwner } from "@chainlink/contracts/src/v0.7/ConfirmedOwner.sol";
import { Chainlink } from "@chainlink/contracts/src/v0.7/Chainlink.sol";
import { LinkTokenInterface } from "@chainlink/contracts/src/v0.7/interfaces/LinkTokenInterface.sol";

contract TruflationTesterV1 is ChainlinkClient, ConfirmedOwner, ITruflationTester {
  using Chainlink for Chainlink.Request;
  
  address public oracleId;
  string public jobId;
  uint256 public fee;

  int256 inflationWei;

  // Please refer to
  // https://github.com/truflation/quickstart/blob/main/network.md
  // for oracle address. job id, and fee for a given network

  constructor(
    address oracleId_,
    string memory jobId_,
    uint256 fee_,
    address token_
  ) ConfirmedOwner(msg.sender) {
    setChainlinkToken(token_);
    oracleId = oracleId_;
    jobId = jobId_;
    fee = fee_;
  }

  function changeOracle(address _oracle) public onlyOwner {
    oracleId = _oracle;
  }

  function changeJobId(string memory _jobId) public onlyOwner {
    jobId = _jobId;
  }

  function changeFee(uint256 _fee) public onlyOwner {
    fee = _fee;
  }

  function getChainlinkToken() public view returns (address) {
    return chainlinkTokenAddress();
  }

  function getinflationWei() external view override returns (int256) {
    return inflationWei;
  }

  function withdrawLink() public onlyOwner {
    LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
    require(link.transfer(msg.sender, link.balanceOf(address(this))),
    "Unable to transfer");
  }

/*
  // The following are for retrieving inflation in terms of wei
  // This is useful in situations where you want to do numerical
  // processing of values within the smart contract

  // This will require a int256 rather than a uint256 as inflation
  // can be negative
*/
  function requestInflationWei() external override returns (bytes32 requestId) {
    Chainlink.Request memory req = buildChainlinkRequest(
      bytesToBytes32(bytes(jobId)),
      address(this),
      this.fulfillInflationWei.selector
    );
    req.add("service", "truflation/current");
    req.add("keypath", "yearOverYearInflation");
    req.add("abi", "int256");
    req.add("multiplier", "1000000000000000000");
    req.add("refundTo",
      Strings.toHexString(uint160(msg.sender), 20));

    return sendChainlinkRequestTo(oracleId, req, fee);
  }

  function fulfillInflationWei(
    bytes32 _requestId,
    bytes memory _inflation
  ) public recordChainlinkFulfillment(_requestId) {
    inflationWei = toInt256(_inflation);
  }

  function toInt256(bytes memory _bytes) internal pure
  returns (int256 value) {
    assembly {
      value := mload(add(_bytes, 0x20))
    }
  }

  // @dev Converts first 32 bytes of input bytes
    function bytesToBytes32(bytes memory source) internal pure 
    returns (bytes32 result_) {
        if (source.length == 0) {
            return 0x0;
        }
        assembly {
            result_ := mload(add(source, 32))
        }
    }
}