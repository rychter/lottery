pragma solidity ^0.4.17;

contract Lottery {

    uint public number = 1;
    uint public numberFromPublic = 1;
    uint public numberFromCreator = 1;
    address public creator;
    uint public reward;


    function Lottery() public {
        creator = msg.sender;
    }

    function getBalance() public view returns (uint256){
        return this.balance;
    }

    function play() public payable {
    
        require(msg.value >= 0.01 ether);
        calculateReward();

        msg.sender.transfer(reward);
        creator.transfer(0.001 ether);
   
    }


    function addNumberFromPublic(uint numberSentByPublic) public {
        numberFromPublic += uint(msg.sender);
        numberFromPublic += uint(msg.sig);
        numberFromPublic += uint32(numberSentByPublic);
    }

    function addNumberFromCreator(uint numberSentByCreator) public {
       
       require(msg.sender == creator);

        numberFromCreator += uint(msg.sender);
        numberFromCreator += uint(msg.sig);
        numberFromCreator += uint32(numberSentByCreator);
    }

    function generateNumber(uint numberFromCaller) private {

        number += block.number + numberFromCaller;
        number += block.timestamp;
        number += block.difficulty;
        number = uint8(uint256(keccak256(abi.encodePacked(number))));
        number += uint(msg.sender);
        number += uint(msg.sig);
        number = uint8(uint256(keccak256(abi.encodePacked(number * number * block.number))));
        number = uint8(uint256(keccak256(abi.encodePacked(number * uint(msg.sig) * numberFromPublic * numberFromCreator * numberFromCaller))));

    }

    function calculateReward() private {

        uint higestNumber = 0;
        
        for (uint i = 0; i < 4; i++) {

            generateNumber(uint8(higestNumber + i + number + this.balance));
            uint currentNumber = number;

            if (currentNumber > higestNumber) {
                higestNumber = currentNumber;
            }

        }
        
        reward = div(this.balance, higestNumber);
    }

    function addBalance() public payable {}
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
    
}
