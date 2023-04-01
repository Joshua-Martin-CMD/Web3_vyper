// SPDX-License-Identifier: MIT

/*
    This contract receives funding from different accounts. Only the contract owner can withdraw these funds.
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FundProjectCheckWithLibrary is Ownable {
    mapping(address => uint256) public addressToAmountFunded;

    address[] public funders;

    function fund() public payable {
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function withdraw() public onlyOwner payable {
        
        // Resets map
        for (uint256 funderIndex = 0;funderIndex < funders.length;funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // Resets funders array
        funders = new address[](0);

        payable(msg.sender).transfer(address(this).balance);
    }
}
