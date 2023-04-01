// SPDX-License-Identifier: MIT

pragma solidity ^0.7;

contract ArithmeticContract {
 
   uint8 public value;

  function add(uint8 _value) public {
      value = value + _value;
  }

  function subtract(uint8 _value) public {
      value = value - _value;
  }
}
