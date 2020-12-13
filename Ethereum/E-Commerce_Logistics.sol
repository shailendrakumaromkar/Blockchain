pragma solidity ^0.6.0;
//contract
contract Logistics {
    address owner;
    
    struct orderDetails{
        bool isOrderIdGenerated;
        uint itemId;
        string itemName;
        string transportStatus;
        uint orderStatus; //1=Ordered; 2= InTransit34=Deleivered;4=Cancelled
        
        address customer;
        uint ordertime;
        
        address transport1;
        uint transport1time;
        
       address transport2;
        uint transport2time;
    }
    
    modifier onlyOwner() {
        require(owner==msg.sender);
        _;
    }
    
    constructor() public {
        owner=msg.sender;
    }
    
    mapping(address =>orderDetails) public orderMapping;
    mapping(address => bool) public transportMapping;
    
    
    function placeOrder(uint _itemId, string memory _itemName) public returns(address) {
        address orderId =address(bytes20(sha256(abi.encodePacked(msg.sender,now))));
        require(!orderMapping[orderId].isOrderIdGenerated);
        
        orderMapping[orderId].isOrderIdGenerated=true;
        orderMapping[orderId].itemId=_itemId;
        orderMapping[orderId].itemName=_itemName;
        orderMapping[orderId].transportStatus="Your order has been placed successfully";
        orderMapping[orderId].orderStatus=1;
        orderMapping[orderId].customer=msg.sender;
        orderMapping[orderId].ordertime=now;
        
        return orderId; //store this orderid
        
    }
    
    function cancelOrder(address _orderId) public returns(string memory) {
        require(orderMapping[_orderId].isOrderIdGenerated);
        require(orderMapping[_orderId].customer==msg.sender);
        require(orderMapping[_orderId].orderStatus==1);
        
        orderMapping[_orderId].orderStatus=4;
        orderMapping[_orderId].transportStatus="Your order has been cancelled";
        
        return ("Your order has been cancelled");
    }
    
    function setTransporter(address _transportAddress) onlyOwner public returns(string memory) {
        if(!transportMapping[_transportAddress]){
            transportMapping[_transportAddress]=true;
        }
        
        else {
            transportMapping[_transportAddress]=false;
        }
        
        return("Transporter is approved for delievery");
    }
    
    
    function transport1Data(address _orderId, string memory _transportStatus) public {
        require(orderMapping[_orderId].isOrderIdGenerated);
       require(orderMapping[_orderId].orderStatus==1); 
       require(transportMapping[msg.sender]);    
       
       orderMapping[_orderId].transportStatus=_transportStatus;
       orderMapping[_orderId].orderStatus=2;
       orderMapping[_orderId].transport1=msg.sender;
       orderMapping[_orderId].transport1time=now;
    }
    
    
    function transport2Data(address _orderId, string memory _transportStatus) public {
        require(orderMapping[_orderId].isOrderIdGenerated);
        require(orderMapping[_orderId].orderStatus==2);
        require(transportMapping[msg.sender]);
        
        
        orderMapping[_orderId].transportStatus=_transportStatus;
        orderMapping[_orderId].transport2=msg.sender;
        orderMapping[_orderId].transport2time=now;
        orderMapping[_orderId].orderStatus=3;
    }
}
