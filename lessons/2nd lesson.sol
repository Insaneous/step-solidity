// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Var2nd{
    string public greeting = "All your base are belong to us.";
    uint8 public age;
    string public name;
    address private owner;
    uint8[5] public users = [1, 2, 3, 4, 5];
    
    struct User{
        string name;
        uint id;
    }

    User public admin;
    User public user = User("name", 1);

    function greet() public pure returns (string memory) {
        return "Hello, World!";
    }

    constructor(string memory _name, uint8 _age){
        name = _name;
        age = _age;
        owner = msg.sender;
    }
}