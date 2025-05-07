// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Metro is ERC1155 {

    struct Item {
        string name;
        uint8 weight;
    }

    struct User {
        string name;
        string surname;
        uint8 age;
        uint8 level;
        uint8[] inventory;
        uint8 power;
        uint wallet;
    }

    struct Reward {
        uint8 id;
        uint amount;
    }

    struct Level {
        uint8 playerLevel;
        uint8[] playerItems;
        uint8 playerPower;
        Reward[] rewards;
    }

    mapping(address => User) private users;
    mapping(address => uint) private time; 
    mapping(uint8 => Item) private items;
    mapping(uint8 => Level) private levels;
    uint8 itemCount = 1;
    uint8 resetCount;
    uint today;
    address owner;
    uint8[] internal level1items;
    Reward internal level1reward;

    constructor() ERC1155("ipfs://bafybeic355cbsgnwew473a2be3gmrzmhzuiorx3q7cysl7lr34bzgty7hm/") {
        today = block.timestamp;
        owner = msg.sender;
        items[1] = Item("knife", 1);
        level1items.push(1);
        level1reward.id = 1;
        level1reward.amount = 1;
        levels[1].playerLevel = 1;
        levels[1].playerItems = level1items;
        levels[1].rewards.push(level1reward);
    }

    function register(string memory _name, string memory _surname, uint8 _age) external {
        User memory user;
        user.name = _name;
        user.surname = _surname;
        user.age = _age;
        users[msg.sender] = user;
    }

    function find() external payable returns(string memory){
        if (resetCount > 6 && today + 1 days < block.timestamp) {
            resetCount = 0;
            today = block.timestamp;
        }else{
            return "No more items today";
        }
        require(msg.value == 100 wei, "Searching costs 100 wei");
        require(time[msg.sender] + 1 days < block.timestamp, "You have already searched today");
        users[msg.sender].power += 5;
        require(users[msg.sender].inventory.length < 6, "You have reached inventory limit");
        require(users[msg.sender].power >= items[itemCount].weight, "You're not strong enough");
        _mint(msg.sender, itemCount, 1, "");
        users[msg.sender].inventory.push(itemCount);
        itemCount++;
        if (itemCount > 9) {
            resetCount++;
            itemCount = 1;
        }
        (bool success, ) = owner.call{value: msg.value}("");
        success = true;
        return "You've found an item!";
    }

    function completeLevel(uint8 levelId) external returns (string memory){
        require(users[msg.sender].level >= levels[levelId].playerLevel, "Your level is too low");
        require(users[msg.sender].power >= levels[levelId].playerPower, "You're not strong enough");
        for (uint i = 0; i < levels[levelId].playerItems.length; i++) {
            bool found = false;
            for (uint j = 0; j < users[msg.sender].inventory.length; j++) {
                if (users[msg.sender].inventory[j] == levels[levelId].playerItems[i]){
                    found = true;
                    break;
                }
            }
            require(found, "You don't have required items");
        }
        users[msg.sender].level++;
        for(uint k = 0; k < levels[levelId].rewards.length; k++) {
            for(uint l = 0; l < levels[levelId].rewards[k].amount; l++) {
                users[msg.sender].inventory.push(levels[levelId].rewards[k].id);
            }
        }
        return "You gained a level";
    }
}