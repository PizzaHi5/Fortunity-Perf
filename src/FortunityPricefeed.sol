// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@newzep/contracts/utils/Strings.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract FortunityPricefeed is ChainlinkClient, ConfirmedOwner {
  using Chainlink for Chainlink.Request;
  
  uint256 inflationWei;

  address public oracleId;
  string public jobId;
  uint256 public fee;

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

  function requestInflationWei() public returns (bytes32 requestId) {
    Chainlink.Request memory req = buildChainlinkRequest(
      bytes32(bytes(jobId)),
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
    inflationWei = uint256(toInt256(_inflation) + 100e18);
  }

  function toInt256(bytes memory _bytes) internal pure
    returns (int256 value) {
        assembly {
            value := mload(add(_bytes, 0x20))
        }
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

  // @perp-oracle-contract
  function getPrice(uint256 interval) external view returns (uint256) {
    return inflationWei;
  }
  
  // @perp-oracle-contract
  function cacheTwap(uint256 interval) external returns (uint256) {
    return 0;
  }
    
  // @perp-oracle-contract
  function decimals() external view returns (uint8) {
    return 18;
  }


  function getChainlinkToken() public view returns (address) {
    return chainlinkTokenAddress();
  }

  function withdrawLink() public onlyOwner {
    LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
    require(link.transfer(msg.sender, link.balanceOf(address(this))),
    "Unable to transfer");
  }
}