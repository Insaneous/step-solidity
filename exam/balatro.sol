// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Balatro is ERC1155, Ownable {
    enum Suit{
        Spade,
        Heart,
        Club,
        Diamond
    }

    enum Rank{
        NA,
        N2,
        N3,
        N4,
        N5,
        N6,
        N7,
        N8,
        N9,
        N10,
        NJ,
        NQ,
        NK
    }

    enum PokerHands{
        HighCard,
        Pair,
        Three,
        Four,
        TwoPair,
        FullHouse,
        Straight,
        Flush,
        StraightFlush
    }

    struct Card{
        Suit suit;
        Rank rank;
        uint score;
    }

    struct Hand{
        Card[] cards;
        uint size;
    }

    struct Joker{
        string name;
        string effect;
        uint price;
    }

    struct User{
        address wallet;
        Joker[] jokers;
        Card[] deck;
        Card[] hand;
        uint blind;
        uint hands;
    }

    struct Blind{
        uint score;
        uint reward;
    }
    
    mapping(address => User) private users;
    constructor() ERC1155("") Ownable(msg.sender) {}

    function sender() internal view returns(User storage) {
        return users[msg.sender];
    }

    function setHand() internal {
        for (uint i = 0; i < 9; i++) {
            sender().hand.push(sender().deck[sender().deck.length-1]);
            sender().deck.pop();
        }
    }

    function startBlind(uint _blind) external {
        // Игрок начинает уровень и получает карты в руку
        users[msg.sender].blind = _blind;
        setHand();
    }

    function play(uint[] memory _poker) external {
        // Игрок выбирает карты из руки, происходит подсчёт очков и оставшихся попыток
        
    }
}