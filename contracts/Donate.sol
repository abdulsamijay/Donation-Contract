pragma solidity ^0.5.7;

import "./SafeMath.sol";
import "./Pausable.sol";
import "./CharityToken.sol";

contract Donate is Pausable{

    using SafeMath for uint256;

    CharityToken public ct;

    event DonatedEthers(
        address indexed from,
        uint256 value
    );

    event DonatedTokens(
        address indexed from,
        uint256 value
    );    

    event WithdrawTokens(
        string msg
    );     

    event WithdrawEthers(
        string msg
    );

    function initialize(address _address) public {
        ct = CharityToken(_address);
        owner = msg.sender; 
    }

    function withdrawEthers() public onlyOwner returns(bool){
        require(address(this).balance > 0);
        owner.transfer(address(this).balance);
        emit WithdrawEthers("Amount Withdrawed ");
        return true;
    }

    function withdrawTokens() public onlyOwner returns(bool) {
        require(ct.balanceOf(address(this)) > 0);
        uint theBalance = ct.balanceOf(address(this)); 
        ct.transfer(owner,theBalance); 
        emit WithdrawTokens("Token Withdrawed ");
        return true;

    }

    function getowner() public view returns(address){
        return owner;
    }

    function setowner(address payable _address) public returns(bool){
        owner =  _address;
        return true;
    }

    function getEthers() public view returns(uint){
        return address(this).balance;
    }

    function getTokens() public view returns(uint){
        return ct.balanceOf(address(this));
    }

    function donateEthers(uint amount) payable public returns(bool){
        require(msg.value > 0);
        emit DonatedEthers(msg.sender, amount);
        return true;
    }

    function donateTokens(uint amount) payable public returns(bool){
        require(amount > 0);
        require(ct.balanceOf(msg.sender) >= amount);
        ct.transfer(address(this),amount); 
        emit DonatedTokens(msg.sender, amount);
        return true;
    }

}