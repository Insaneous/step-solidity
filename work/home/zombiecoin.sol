// 10. “ZombieCoins” 🧟 — Зомби-инфекция на блокчейне
// Описание: Игроки заражают друг друга, формируют орды, захватывают территории.
// Функции:
// infect: Заражает пользователя (хранить статус enum: живой, зомби).
// formHorde: Формирует орду (структура с участниками, силой).

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Zombie is ERC20, Ownable{
    enum Status {
        Alive,
        Zombie
    }

    struct User{
        string name;
        address wallet;
        Status status;
    }

    struct Horde{
        User[] amount;
        uint power;
    }

    struct Territory{
        string name;
        uint hordePower;
        uint reward;
    }

    mapping(address => User) private users;
    mapping(string => Horde) public hordes;
    mapping(string => Territory) public territories;
    uint public price = 100000 gwei;
    uint public fee = 10;
    Territory public City;

    constructor() ERC20("Zombie", "BRNS") Ownable(msg.sender) {
        _mint(msg.sender, 10000000 * 10 ** decimals());
        City.name = "Manhattan";
        City.hordePower = 100;
        City.reward = 1000;
    }

    function register(string memory name) external {
        users[msg.sender].name = name;
        users[msg.sender].wallet = msg.sender;
    }
    
    function infect(address target) external payable {
        require(users[msg.sender].status == Status.Zombie);
        require(users[target].status != Status.Zombie);
        users[target].status = Status.Zombie;
        _transfer(owner(), msg.sender, 100);
    }

    function formHorde(string memory name) external {
        hordes[name].amount.push(users[msg.sender]);
    }

    function getPower(string memory name) external view returns(uint) {
        return hordes[name].amount.length;
    }

    function capture(string memory hordeName, string memory name) external {
        hordes[name].power = hordes[name].amount.length;
        require(territories[name].reward != 0, "No such territory");
        require(hordes[hordeName].power >= territories[name].hordePower, "Horde doesn't have enough power");
        for (uint i = 0; i < hordes[hordeName].power; i++){
            _transfer(owner(), hordes[hordeName].amount[i].wallet, territories[name].reward);
        }
        territories[name].reward = 0;
    }

    receive() external payable {
        uint _fee = msg.value / 100 * fee;
        (bool success, ) = owner().call{value: _fee}("");
        if (success){}
        uint _count = msg.value - _fee;
        uint count = _count/price;
        _transfer(owner(), msg.sender, count);
    }
}