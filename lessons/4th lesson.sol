// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lesson{
    enum Role{
        User,
        Owner,
        Admin
    }

    struct User{
        string name;
        address wallet;
        Role role;
    }

    address private owner;
    mapping(address => User) private users;
    uint public count;

    modifier isRole(Role _role) {
        require(users[msg.sender].role == _role);
        _;
    }

    constructor(string memory _name){
        owner = msg.sender;
        users[owner].name = _name;
        users[owner].wallet = owner;
        users[owner].role = Role.Owner;
    }

    function register(string memory _name) public {
        users[msg.sender].name = _name;
        users[msg.sender].wallet = msg.sender;
    }
    function promote(address _wallet) public isRole(Role.Owner) {
        users[_wallet].role = Role.Admin;
    }
    function getRole() public view returns(Role) {
        return users[msg.sender].role;
    }
    function increment() public isRole(Role.Admin) {
        count++;
    }
    function decrement() public isRole(Role.Admin) {
        count--;
    }
}