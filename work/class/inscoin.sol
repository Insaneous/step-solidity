// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyCoin{
    string public name;
    uint8 private age;
    address private owner;
    string internal codeword;
    string public time;
    string public pronoun;
    uint8 private fee = 1;
    uint private balance;
    uint private price = 100000 gwei;
    mapping(address => uint) private users;

    function buy() external payable returns (uint){
        balance += msg.value * fee / 100;
        uint tokens = msg.value / price;
        users[msg.sender] = tokens;
        return tokens;
    }

    function getBalance() external view returns (uint){
        if (msg.sender == owner){
            return balance;
        }
        return 0;
    }

    function transfer(address payable _receiver, uint _amount) external returns (bool){
        uint _wei = _amount * 1 ether;
        if (msg.sender == owner && _amount <= balance){
            (bool success, ) = _receiver.call{value:_wei}("");
            return success;
        }
        return false;
    }

    constructor(string memory _name, 
                uint8 _age, 
                string memory _codeword, 
                string memory _time, 
                string memory _pronoun){

        name = _name;
        age = _age;
        owner = msg.sender;
        codeword = _codeword;
        time = _time;
        pronoun = _pronoun;
    }
}