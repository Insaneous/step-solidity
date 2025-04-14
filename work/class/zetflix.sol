// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Zetflix{
    uint public movieID;
    uint public price;
    mapping(address => uint) private views;

    constructor(uint _id, uint _price){
        movieID = _id;
        price = _price;
    }

    function buy(uint _id, uint _amount) external payable returns (bool){
        if (_id == movieID && _amount == price){
            views[msg.sender] += 100;
            return true;
        }
        return false;
    }

    function getViews() external view returns (uint){
        return views[msg.sender];
    }

    function watch() external returns (uint){
        if (views[msg.sender] > 0){
            views[msg.sender] -= 1;
            return views[msg.sender];
        }
        return 0;
    }
}