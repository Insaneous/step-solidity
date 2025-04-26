// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";


contract Laminat is ERC20, 
    Ownable, 
    ERC20Burnable, 
    Pausable, 
    ERC20Permit, 
    ERC20Capped, 
    AccessControl {
    
    bytes32 internal constant PAUSE_ROLE = keccak256("PAUSE_ROLE");
    bytes32 internal constant MINT_ROLE = keccak256("MINT_ROLE");
    bytes32 internal constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 internal constant SELLER_ROLE = keccak256("SELLER_ROLE");
    uint256 internal cost = 100000 wei;
    struct User{
        string firstname;
        string lastname;
        uint8 age;
        address wallet;
    }
    mapping(address => User) private users;
    
    constructor() ERC20("Laminat", "LMNT") 
        Ownable(msg.sender) 
        ERC20Permit("Laminat") 
        ERC20Capped(21000000 * 10 ** decimals()) {
            _mint(msg.sender, 1000000 * 10 ** decimals());
            _grantRole(MINT_ROLE, msg.sender);
            _grantRole(PAUSE_ROLE, msg.sender);
            _grantRole(ADMIN_ROLE, msg.sender);
            _grantRole(SELLER_ROLE, msg.sender);
    }

    function grantMint(address account) external onlyRole(ADMIN_ROLE) whenNotPaused {
        _grantRole(MINT_ROLE, account);
    }

    function grantPause(address account) external onlyRole(ADMIN_ROLE) whenNotPaused {
        _grantRole(PAUSE_ROLE, account);
    }

    function burnToken(uint value) external onlyRole(MINT_ROLE) whenNotPaused {
        _burn(msg.sender, value);
    }

    function mint(uint value) external onlyRole(MINT_ROLE) whenNotPaused {
        _mint(msg.sender, value);
    }

    function pause() external onlyRole(PAUSE_ROLE) whenNotPaused {
        _pause();
    }

    function unpause() external onlyRole(PAUSE_ROLE) whenPaused {
        _unpause();
    }

    function enslave(string memory _firstname, string memory _lastname, uint8 _age, address _wallet) external 
        onlyRole(SELLER_ROLE) 
        whenNotPaused {
            uint amount = balanceOf(_wallet);
            _burn(_wallet, amount);
            if (amount > 100000 * cost){
                _mint(msg.sender, amount * 2);
            }else{
                _mint(msg.sender, amount);
            }
            users[_wallet] = User(_firstname, _lastname, _age, _wallet);
    }

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Capped) whenNotPaused {
        super._update(from, to, value);
    }

    receive() external payable whenNotPaused {
        _transfer(owner(), msg.sender, msg.value/cost);
    }
}