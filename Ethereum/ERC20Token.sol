pragma solidity ^0.6.0;


interface tokenRecipient {
    function recieveApproval (address _sender, uint _tokenAmount, address _token, bytes calldata  _data) external;}

//Defining owner & can assign new ownership
contract owned {
    
     address owner;
     
     constructor() public {
           owner=msg.sender;
     }
     
      modifier onlyOwner() {
        require(owner==msg.sender);
        _;
    }
    
    //Transferring ownership
    function transferOwenrship(address _newOwner) public onlyOwner {
        owner=_newOwner;
    }
    
}

contract OmkarERC20Token is owned {
    
    string public name;
    string public symbol;
    uint8 public decimals=18;
    uint public totalSupply;
   
    
    mapping(address =>uint) public balanceOf;
    mapping(address =>mapping(address=> uint)) public allowance;
    mapping (address =>bool) frozenAccount;
    
    event Approve(address indexed _sender, address indexed _receiever, uint _token);
    event Transfer(address indexed ownerApproving, address indexed _spender, uint _token);
    event Burn(address indexed _sender, uint _token);
    event FrozenFund(address indexed _freezeAccountAddress, bool isFreeze);
    
    constructor(string memory tokenName, string memory tokenSymbol, uint tokenSupply) public {
        
        name=tokenName;
        symbol=tokenSymbol;
        totalSupply=tokenSupply*10**uint256(decimals);
        balanceOf[msg.sender]=totalSupply;
        
    }
    
    //Transfer token to receiver
     function transfer(address _receiever, uint _token) payable external returns(bool success) {
        
        _transfer(msg.sender,_receiever,_token);
        
          return true; 
          
        }
    
    //Created new function so that originator cannot give same as reciever address
    function _transfer(address _sender, address _receiever, uint _token) internal {
    
        require(balanceOf[_sender] >= _token);
        require(_receiever !=address(0x0));
        require(balanceOf[_receiever] + _token >= balanceOf[_receiever]);
        require(!frozenAccount[msg.sender]);
        
        
        uint oldBalance= balanceOf[_sender] +balanceOf[_receiever];
        
        balanceOf[_sender] -=_token;
        balanceOf[_receiever]+=_token;
    
        
       emit Transfer(_sender, _receiever, _token);
        assert(balanceOf[_sender]+balanceOf[_receiever]==oldBalance); 
    }   
    
    //Approving spender to transfer token on owner behalf
    function approve(address _spender, uint _token) onlyOwner public returns (bool success) {
        
        allowance[msg.sender][_spender] = _token;
        
         emit Approve(msg.sender, _spender, _token);    
        return true;
        
    }
    
    
    //Spender is transferring allowed token from sender to reciever
    function transferFrom(address _sender, address _receiever, uint _token) payable external returns (bool success) {
        
        require(_token<=allowance[_sender][msg.sender]);
        allowance[_sender][msg.sender]-=_token;
       
       _transfer(_sender,_receiever,_token);
        
       return true;
          
        
    }
    
    
    function approveAndCall(address _spender, uint _token, bytes calldata  _extradata) external returns (bool success) {
        
        tokenRecipient spender = tokenRecipient(_spender);
        
        if(approve(_spender,_token)) {
            spender.recieveApproval(msg.sender,_token, address(this),_extradata);
            return true;
        }
        
    }
    
    //Destroying token
    function burn(uint _token) external returns (bool success) {
        require(balanceOf[msg.sender]>_token);
        
        balanceOf[msg.sender]-= _token;
        totalSupply=_token;
        
        emit Burn(msg.sender, _token);
        return true;
    }    
    
    //Destroying token for other address
    function burnFrom(address _sender, uint _token) external returns(bool success) {
        
        require(balanceOf[_sender] >=_token);
        require(allowance[_sender][msg.sender]>=_token);
        
        balanceOf[_sender]-=_token;
        totalSupply-=_token;
        
        return true;
    }
    
    //adding token for address
    function mint(address _targetAddress,  uint _newtoken) onlyOwner public {
        
        balanceOf[_targetAddress] +=_newtoken;
        totalSupply+=_newtoken;
    }
    
    //Freezing any fake account
    function freezeAccount(address _freezeAccountAddress, bool _isFreeze) onlyOwner public {
        
        frozenAccount[_freezeAccountAddress]=_isFreeze;
        emit FrozenFund(_freezeAccountAddress,_isFreeze);
        
    }
    
}
