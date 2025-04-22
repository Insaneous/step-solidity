// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Aboba is ERC20, Ownable, ERC20Burnable {
    uint private price = 100000 gwei;
    uint private fee = 1;

    constructor() ERC20("Aboba Banditi", "ABBA") Ownable(msg.sender){
        _mint(msg.sender, 10000000*10**decimals());
    }

    function fight(address _to, uint _sender_int, uint _to_int, uint _betGwei) external returns (bool){
        uint betGwei = _betGwei * 1 gwei;
        bool isOwnerWin;
        if(_sender_int>_to_int && _sender_int<=_to_int+10){
            isOwnerWin = true;
        }
        else if(_sender_int == _to_int){
            return false;
        }
        _burn(msg.sender, betGwei);
        _burn(_to, betGwei);
        if(isOwnerWin){
            _mint(msg.sender, betGwei * 2);
            return true;
        }
        _mint(_to, betGwei * 2);
        return true;
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