// 1 задание Создать приложение для голосов две переменные, голосующие за и против две функции для голосования за и против 
// 2 задание создать калькулятор 4 функции pure + - * /

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VoteCalc{
    address[] public approvers; 
    address[] public rejecters; 
    
    function approve() public {
        approvers.push(msg.sender);
    }

    function reject() public {
        rejecters.push(msg.sender);
    }

    function plus(int a, int b) public pure returns (int) {
        return a+b;
    }

    function minus(int a, int b) public pure returns (int) {
        return a-b;
    }

    function mult(int a, int b) public pure returns (int) {
        return a*b;
    }

    function divide(int a, int b) public pure returns (int) {
        return a/b;
    }
}