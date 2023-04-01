// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Lib {
    uint public number;
    address public anAddress;

    function setVariables(uint _number) public {
        number = _number;
        anAddress = msg.sender;
    }
}

contract Caller {
    uint public number;
    address public myAddress;

    function setVars(address contractAddress, uint _number) public {        
        contractAddress.call(abi.encodeWithSignature("setVariables(uint256)", _number));
    }
}
