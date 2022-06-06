pragma solidity ^0.4.21;
contract Escrow
{
    enum State{UNINITIATED,AWAITING_PAYMENT,AWAITING_DELIVERY,COMPLETE}
    State public currentState;

    address public buyer;
    address public seller;
    uint public price;

    bool public buyer_in;
    bool public seller_in;

    modifier inState (State expectedState){require(currentState==expectedState);_;}
    modifier correctPrice(){require(msg.value==price);_;}
    modifier buyerOnly(){require(msg.sender==buyer);_;}

    function Escrow (address _buyer,address _seller,uint _price) public 
    {
        buyer=_buyer;
        seller=_seller;
        price=_price;
    }   

    function initiateContract() correctPrice inState(State.UNINITIATED) payable{
        if(msg.sender==buyer){
            buyer_in=true;
        }
        if(msg.sender==seller){
            seller_in=true;
        }
        if(buyer_in && seller_in){
            currentState=State.AWAITING_PAYMENT;
        }
    } 
    function confirmPayment() correctPrice inState(State.AWAITING_PAYMENT) payable{
        require(msg.sender==buyer);
        currentState=State.AWAITING_DELIVERY;
    }
    function confirmDelivery() inState(State.AWAITING_DELIVERY){
        seller.send(price*2);
        buyer.send(price);
        currentState=State.COMPLETE;
    }
}