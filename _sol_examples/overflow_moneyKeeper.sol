// SPDX-License-Identifier: MIT

pragma solidity ^0.7;

contract OverFlowHelper {

    function getMaxUintValue() public pure returns(uint){
        return type(uint).max;
    }   

    function getOverFlowValue(uint timeLockForAccount) public pure returns(uint){
        return getMaxUintValue() - timeLockForAccount + 1;
    }
}
