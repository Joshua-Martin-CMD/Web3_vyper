// SPDX-License-Identifier: MIT

/** 
    This contract receives funding from different accounts and allows an account 
    to withdraw its balance. It protects the contract from a reentrancy attack.
**/

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SafeContract is ReentrancyGuard {

    mapping(address => uint ) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawMyBalance() nonReentrant public payable {  

        // Gets the address that is withdrawing money and the balance for that account
        address to = msg.sender;
        uint myBalance = balances[msg.sender];
        
        // Validates the balance, sends the money to the account, and resets the balance for that account
        if (myBalance > 0) {

                (bool success, ) = to.call{value:myBalance}("");
                require(success, "Transfer failed.");
                balances[msg.sender] = 0;
        }    
    }
}