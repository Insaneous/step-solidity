// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Var2nd{
    string public greeting = "All your base are belong to us.";
    uint8 public age;
    string public name;
    address private owner;

    function greet() public pure returns (string memory) {
        return "Hello, World!";
    }

    constructor(string memory _name, uint8 _age){
        name = _name;
        age = _age;
        owner = msg.sender;
    }
}