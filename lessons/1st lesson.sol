// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract HelloWorld{
    string public hi = "Hello, world!";
    string private secret = "There is no spoon.";
    uint private eth = 10 ether;
    
    function sum(uint8 _a, uint8 _b) external pure returns (uint8) {
        return _a + _b;
    }
    function setEth(uint _eth) external returns (uint) {
        eth = _eth * 1 ether;
        return eth;
    }
    function Pyth(uint _a, uint _b, uint _c) external pure returns (bool) {
        return (_a + _b > _c) && (_b + _c > _a) && (_a + _c > _b);
    }
}