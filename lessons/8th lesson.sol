//ERC1155 - создает уникальные токены в больщом кол-ве, к него сразу есть ID

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract Game is ERC1155 {

    constructor(uint8 _x1_F, uint8 _z1_F, uint8 _x2_F, uint8 _z2_F) ERC1155("ipfs://bafybeic355cbsgnwew473a2be3gmrzmhzuiorx3q7cysl7lr34bzgty7hm/"){ //ссылка на папку с предметами
        Fonar = Item("Fonar", 10, _x1_F, _z1_F, _x2_F, _z2_F);

    } 

    
    struct Item {
        string name;
        uint power;

        uint8 x1_F;
        uint8 z1_F;
        uint8 x2_F;
        uint8 z2_F;
    }

    Item private Fonar;


    
    struct User {
        string name;
        string surname;
        uint8 age;
        uint8 posX;
        uint posZ;
        uint256 power;
    }

    mapping(address => User) private userStats;

    function contractURI() external pure returns (string memory) { //ссылка на описание игры
        return "ipfs://bafkreie35bj4gynsves35zkb7nosu7p53jevvbja3juvuhoxfiej6quj7q"; 
    }


    function vpered() external {
        userStats[msg.sender].posX++;
        userStats[msg.sender].power++;
    }

    function nazad() external {
        if(userStats[msg.sender].posX > 1) {
            userStats[msg.sender].posX--;
            userStats[msg.sender].power++;
        }
    }

    function vpravo() external {
        userStats[msg.sender].posZ++;
        userStats[msg.sender].power++;
    }

    function vlevo() external {
        if(userStats[msg.sender].posZ > 1) {
            userStats[msg.sender].posZ--;
            userStats[msg.sender].power++;
        }
    }


    function getFonaric() external payable {
        
        require(msg.value >= 1000 gwei, "Malo deneg");


        uint256 count = balanceOf(msg.sender, 1) + balanceOf(msg.sender, 2) + balanceOf(msg.sender, 3) + balanceOf(msg.sender, 4) + balanceOf(msg.sender, 5);


        require((userStats[msg.sender].posX >= Fonar.x1_F && userStats[msg.sender].posX <= Fonar.x2_F) && 
        (userStats[msg.sender].posZ >= Fonar.z1_F && userStats[msg.sender].posZ <= Fonar.z2_F) && count < 5, "OSHIBKA");

        _mint(msg.sender, 1, 1, "");
    }
}