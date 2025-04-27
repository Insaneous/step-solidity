// Работа со сложным типом данных struct
// Создайте новый контракт в Remix.
// Создайте структуру (struct) с именем Product, содержащую поля name (тип string) и price (тип uint).
// Создайте публичное поле типа Product с именем currentProduct. 
// Создайте функцию с именем setProduct, которая будет принимать строковый параметр name и числовой параметр price, 
// создавать новый экземпляр структуры Product и устанавливать его в качестве значения currentProduct.
// Создайте функцию с именем getProduct, которая будет возвращать имя и цену текущего продукта

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Struct{
    struct Product{
        string name;
        uint price;
    }

    Product public currentProduct;

    function setProduct(string memory name, uint price) external {
        currentProduct = Product(name, price);
    }

    function getProduct() external view returns (Product memory){
        return currentProduct;
    }
}