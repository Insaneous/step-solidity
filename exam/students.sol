// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Students{
    struct User {
        string name;
        uint8 age;
    }
    mapping(string => User) students;
    function addStudent(string memory _name, uint8 _age) external {
        students[_name].name = _name;
        students[_name].age = _age;
    }
    function getStudentAge(string memory _name) external view returns(uint8) {
        return students[_name].age;
    }
    function updateStudentAge(string memory _name, uint8 _age) external {
        students[_name].age = _age;
    }
}