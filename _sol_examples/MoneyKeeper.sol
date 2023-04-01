// SPDX-License-Identifier: MIT

pragma solidity ^0.7;

contract MoneyKeeper {

    mapping(address => uint) public balances;
    mapping(address => uint) public lockTimeInSeconds;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        lockTimeInSeconds[msg.sender] = block.timestamp + 2 weeks;
    }

    function increaseLockTime(uint secondsToIncrease) public {
        lockTimeInSeconds[msg.sender] += secondsToIncrease;
    }

    function withdraw() public payable {
        require(block.timestamp > lockTimeInSeconds[msg.sender]);
        uint accountBalance = balances[msg.sender];
        msg.sender.transfer(accountBalance);
        balances[msg.sender] = 0;
    }
}

contract OverFlowHelper {

    function getMaxUintValue() public pure returns(uint){
        return type(uint).max;
    }   

    function getOverFlowValue(uint timeLockForAccount) public pure returns(uint){
        return getMaxUintValue() - timeLockForAccount + 1;
    }
}
