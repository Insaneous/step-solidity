// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract ThungThungThungRobot is ERC721URIStorage, Ownable, ERC2981 {
    using Strings for uint8;

    IERC20 private connectTokens = IERC20(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);

    uint256 public mintPrice = 0.02 ether;
    uint8 public totalSupply;
    uint8 public maxSupply = 200;
    uint8 public maxMintPerAddress = 5;
    string public ipfsURL;
    bool private release;

    mapping(address => uint256) public mintedPerAccount;
    mapping(address => uint256[]) public ownerToTokens;

    constructor() ERC721("ThungThungThungRobot", "TTTR") Ownable(msg.sender){
        ipfsURL = "ipfs://bafkreidrejsposlaxht7ocuac5fw3fi5uohl5zngxj4yiplpuk56tabrqe";
        _setDefaultRoyalty(msg.sender, 500);
    }

    function mint(uint _amount) external payable {
        require(totalSupply + _amount <= maxSupply, "Mnogo");
        require(mintedPerAccount[msg.sender] + _amount <= maxMintPerAddress, "Mnogo");
        require(msg.value >= _amount * mintPrice, "Malo");

        for (uint8 i = 0; i < _amount; i++){
            uint8 tokenId = totalSupply++;
            _safeMint(msg.sender, tokenId);
            ownerToTokens[msg.sender].push(tokenId);

            if (release) {
                _setTokenURI(tokenId, string(abi.encodePacked(ipfsURL, tokenId.toString(), ".json")));
            }else{
                _setTokenURI(tokenId, ipfsURL);
            }

            totalSupply++;
            mintedPerAccount[msg.sender]++;
        }
    }

    function setRelease() external onlyOwner {
        require(!release, "already released");

        ipfsURL = "ipfs://bafybeig5watk2dlle7ztwtna6in4csdcpjgrruha6se7727mmvjlt24fjq/";
        release = true;
        for(uint8 i = 1; i <= totalSupply; i++) {
            _setTokenURI(i, string(abi.encodePacked(ipfsURL, i.toString(), ".json")));
        }
    }

    function getMintPrice() external view returns(uint256) {
        return mintPrice;
    }

    function getTotalSupply() external view returns(uint8) {
        return totalSupply;
    }

    function getMaxSupply() external view returns(uint8) {
        return maxSupply;
    }

    function getipfsURL() external view returns(string memory) {
        return ipfsURL;
    }

    function getMaxMintPerAddress() external view returns(uint8) {
        return maxMintPerAddress;
    }

    function setMintPrice(uint256 _mintPrice) external {
        mintPrice = _mintPrice;
    }

    function setMaxSupply(uint8 _maxSupply) external {
        maxSupply = _maxSupply;
    }

    function setipfsURL(string memory _ipfsURL) external {
        ipfsURL = _ipfsURL;
    }

    function setMaxMintPerAddress(uint8 _maxMintPerAddress) external {
        maxMintPerAddress = _maxMintPerAddress;
    }

    function sendMoney(uint256 _value) external onlyOwner returns (bool) {
        require(_value <= address(this).balance, "Ne xvataet deneg");
        (bool success, ) = owner().call{value: _value}("");
        return success;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override (ERC721URIStorage, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}

// bafybeig5watk2dlle7ztwtna6in4csdcpjgrruha6se7727mmvjlt24fjq