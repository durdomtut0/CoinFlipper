// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CoinFlipper{

    //modifier onlyOwner
    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    //Owner's address
    address owner; 

    //event to track result of Coin Flip
    event CoinFlipped(address player, uint256 amount, uint8 option, bool result); 

    //payable = user может заплатить в BNB (главная монета в блокчейне)
    //in Constructor we assign owner's address;
    constructor() payable {
        owner = msg.sender;
    }

    //function that asks for 0 or 1 and returns if you win or lose
    function coinFlip(uint8 _option) public payable returns (bool){ //view, pure = gassless 
        require(_option<2, "Please select head or tail");
        require(msg.value>0, "Please add your bet"); //WEI smallest unit ETH 
        //1,000,000,000,000,000,000 WEI = 1 ETH 
        require(msg.value*2 <= address(this).balance, "Contract balance is insuffieient ");

        //PseudoRandom and check with _option 
        bool result = block.timestamp*block.gaslimit%2 == _option; 
        //TODO add oracle: https://docs.chain.link/vrf/v2/introduction


        //Emiting event of Coin Flip
        emit CoinFlipped(msg.sender, msg.value, _option, result);


        //If user wins he doubles his stake
        if (result){
            payable(msg.sender).transfer(msg.value*2);
            return true;
        }
        //If user lose he lose
        return false;
        
    }

    //Owner can withdraw BNB amount
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

}

