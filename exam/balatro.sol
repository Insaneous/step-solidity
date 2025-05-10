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
    mapping(uint => Rank) private ranks;

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
        uint score;
    }

    struct Blind{
        uint score;
        uint reward;
    }
    
    Blind[] public blinds;
    mapping(address => User) private users;
    Card[] private poker;

    constructor() ERC1155("") Ownable(msg.sender) {}

    function sender() internal view returns(User storage) {
        return users[msg.sender];
    }

    function setHand() internal {
        for (uint i = sender().deck.length-1; i < 9; i++) {
            sender().hand.push(sender().deck[sender().deck.length-1]);
            sender().deck.pop();
        }
    }

    function startBlind(uint _blind) external {
        // Игрок начинает уровень и получает карты в руку
        sender().blind = _blind;
        setHand();
    }

    mapping(Suit => uint) private countOfSuits; 
    mapping(Rank => uint) private countOfRanks; 

    function play(uint[5] memory _poker) external returns(string memory) {
        // Игрок выбирает карты из руки, происходит подсчёт очков и оставшихся попыток
        Card storage chosenCard;
        Card storage lastCard;
        
        for (uint i = 0; i < 5; i++) {
            poker.push(sender().hand[_poker[i]]);
            chosenCard = sender().hand[_poker[i]];
            lastCard = sender().hand[sender().hand.length-1];
            sender().hand[_poker[i]] = lastCard;
            sender().hand[sender().hand.length-1] = chosenCard;
            sender().hand.pop();
            countOfSuits[chosenCard.suit]++;
            countOfRanks[chosenCard.rank]++;
        }

        for (uint i = 0; i < 13; i++) {
            if (countOfRanks[ranks[i]] == 4) {
                sender().score += 100;
            }
            if (countOfRanks[ranks[i]] == 3) {
                sender().score += 60;
            }
            if (countOfRanks[ranks[i]] == 2) {
                sender().score += 20;
            }
        }
        if (sender().score >= blinds[sender().blind].score) {
            return "You win.";
        }
        else{
            sender().hands--;
            if (sender().hands == 0) {
                return "You loose.";
            }
            setHand();
            return "Play again.";
        }
    }
}