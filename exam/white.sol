// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC721URIStorage, ERC2981, Ownable {
    uint private totalSupply;
    bool public whiteListToggle = true;
    mapping(address => bool) whiteList;
    constructor() ERC721URIStorage("Token", "TTT") Ownable(msg.sender) {
        _setDefaultRoyalty(msg.sender, 100);
    }

    function mint(uint _amount) external payable {
        if (whiteListToggle) {
            require(whiteList[msg.sender]);
        }
        for (uint i = 0; i < _amount; i++){
            uint tokenId = totalSupply++;
            _safeMint(msg.sender, tokenId);
            totalSupply++;
        }
    }

    function toggleWhiteList() external onlyOwner {
        whiteListToggle = !whiteListToggle;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override (ERC721URIStorage, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}