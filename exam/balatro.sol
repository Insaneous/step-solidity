// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Balatro is ERC1155, Ownable {
    struct User{
        address wallet;
    }

    constructor() ERC1155("") Ownable(msg.sender) {}
}