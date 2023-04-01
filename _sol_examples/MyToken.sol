// SPDX-License-Identifier: MIT

/*
    This contract creates an ERC20 token using OpenZeppelin.
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    // 1000 units
    uint256 initialSupply = 100000000000000000000000;

    constructor() ERC20("JoshCoin", "JC") {
        _mint(msg.sender, initialSupply);
    }
}
