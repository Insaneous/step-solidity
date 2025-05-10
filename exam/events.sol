// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Events{
    address owner;
    event ownerChanged(string);
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    function changeOwner(address _owner) public onlyOwner {
        owner = _owner;
        emit ownerChanged("Owner changed");
    }
}