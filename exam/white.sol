// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract NFT is ERC721URIStorage, ERC2981 {
    uint totalSupply;
    bool whiteListToggle = true;
    mapping(address => bool) whiteList;
    constructor() ERC721URIStorage("Name", "NNN") {
        _setDefaultRoyalty(msg.sender, 100);
    }

    function mint(uint _amount) external payable {
        if (whiteListToggle) {
            require();
        }
        for (uint i = 0; i < _amount; i++){
           _safeMint();
        }
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override (ERC721URIStorage, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}