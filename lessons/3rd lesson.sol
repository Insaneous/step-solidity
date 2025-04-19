// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace{
    struct Item{
        uint id;
        string name;
        string url;
        uint price;
        uint count;
        bool exist;
    }

    struct User{
        string name;
        uint8 age;
        uint deposit;
        address wallet;
        bool exist;
        mapping(uint => Item) items;
    }

    mapping(address => User) users;
    mapping(uint => Item) items;

    address internal owner;
    uint internal lastId;

    constructor(string memory _name, uint8 _age) {
        owner = msg.sender;
        users[owner].name = _name;
        users[owner].age = _age;
        users[owner].wallet = owner;
        users[owner].exist = true;
    }

    function register(string memory _name, uint8 _age) external returns (bool) {
        users[msg.sender].name = _name;
        users[msg.sender].age = _age;
        users[msg.sender].wallet = msg.sender;
        users[msg.sender].exist = true;
        return users[msg.sender].exist;
    }

    function addItem(string memory _name, string memory _url, uint _price, uint _count) external returns (bool) {
        if (msg.sender == owner){
            items[lastId] = Item(lastId, _name, _url, _price, _count, true);
            lastId++;
            return true;
        }
        return false;
    }

    function deposit() external payable returns (string memory, uint) {
        users[msg.sender].deposit += msg.value;
        if (!users[msg.sender].exist){
            users[msg.sender].exist = true;
        }
        return ("Success! Your balance: ", users[msg.sender].deposit);
    }

    function refund(uint _money) external returns (string memory) {
        uint amount = (_money*90) / 100;
        uint fee = _money - amount;
        if (users[msg.sender].exist && users[msg.sender].deposit >= _money){
            (bool success, ) = msg.sender.call{value: amount}("");
            if (success){
                users[msg.sender].deposit -= _money;
                (bool successToUs, ) = owner.call{value: fee}("");
                if (successToUs)
                return ("Success!");
            }
        }
        return ("User not found or insufficient funds.");
    }

    enum DoneItem{
        Pending,
        inProgress,
        Success,
        Canceled,
        Errored
    }
    DoneItem public itemReady;
    function setInProgress() external {
        require(msg.sender == owner, "You are not a owner!");
        require(itemReady == DoneItem.Pending, "itemReady is not Pending");

        itemReady = DoneItem.inProgress;
    }


    function setSuccess() external {
        require(msg.sender == owner, "You are not a owner!");
        require(itemReady == DoneItem.inProgress, "itemReady is not inProgress");

        itemReady = DoneItem.Success;
    }

    function setCanceled() external {
        require(msg.sender == owner, "You are not a owner!");
        require(itemReady == DoneItem.inProgress, "itemReady is not inProgress");

        itemReady = DoneItem.Canceled;
    }

    function setErrored() external {
        require(msg.sender == owner, "You are not a owner!");
        require(itemReady == DoneItem.inProgress, "itemReady is not inProgress");

        itemReady = DoneItem.Errored;
    }
}