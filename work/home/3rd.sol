// Сделать товар для перевозок 
// сделать enum с такими типами: Нету, На складе, Купили, Отменили, Перевозится, Удачно привезли, не Удачно привезли 
// перейти на тип "Отменили " можно со всех кроме "Нету " и "на складе" 
// на тип "На складе" можно перейти только с "Нету" или "Отменили" 
// на тип "Нету" можно перейти только с "Купили" и "Удачно привезли"
// на тип "Перевоздится" можно перейти только с "Купили"
// на тип "Купили" можно перейти только с "На складе"
// на тип " Удачно привезли" или " не Удачно привезли" можно перейти только с "Перевозится"

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Cargo{
    enum Status {
        None,
        Storage,
        Bought,
        Canceled,
        Shipping,
        Success,
        Failure
    }

    Status public currentStatus;

    function canceled() external returns (bool) {
        if (currentStatus == Status.None || currentStatus == Status.Storage) {
            return false;
        }
        currentStatus = Status.Canceled;
        return true;
    }

    function inStorage() external returns (bool) {
        if (currentStatus == Status.None || currentStatus == Status.Canceled) {
            currentStatus = Status.Storage;
            return true;
        }
        return false;
    }

    function none() external returns (bool) {
        if (currentStatus == Status.Bought || currentStatus == Status.Success) {
            currentStatus = Status.None;
            return true;
        }
        return false;
    }

    function shipping() external returns (bool) {
        if (currentStatus == Status.Bought) {
            currentStatus = Status.Shipping;
            return true;
        }
        return false;
    }

    function bought() external returns (bool) {
        if (currentStatus == Status.Storage) {
            currentStatus = Status.Bought;
            return true;
        }
        return false;
    }

    function success() external returns (bool) {
        if (currentStatus == Status.Shipping) {
            currentStatus = Status.Success;
            return true;
        }
        return false;
    }

    function failure() external returns (bool) {
        if (currentStatus == Status.Shipping) {
            currentStatus = Status.Failure;
            return true;
        }
        return false;
    }
}