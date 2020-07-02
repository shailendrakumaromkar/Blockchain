
```javascript
pragma solidity ^0.6.0;

contract FanFest {
    
    address owner;
    
    //List of valid PromoCode
    string[] PromoCodes = ["PROMO1","PROMO2","PROMO3"];
    
    //Different PromoCode valid State
    enum PromoCodeState  {ACTIVE, INACTIVE}
    
    
    //Structure to strore Fan data
    struct FanData {
        string name;
        uint age;
        string promoCodeUsed;
    }
    
    // Mapping of Promocode with their state
    mapping(string =>PromoCodeState) promoCodeStateMapping;
    
    //Mapping of user address with struct user data
    mapping (address =>FanData) fandataMapping;
    
    
    //Validation for only admin user
    modifier onlyAdmin() {
        require (owner==msg.sender);
        _;
    }
    
 
    constructor () public {
        owner=msg.sender;
    
       //Changing all PromoCode state to ACTIVE       
        for (uint i=0; i< PromoCodes.length; i++) {
            promoCodeStateMapping[PromoCodes[i]]== PromoCodeState.ACTIVE;
        }
        
    }   
    
    
    //Comparing the promo code which user has entered against list of already stored PromoCode 
    function promoCodeComparison (string memory  _promo1, string memory  _promo2) private pure returns (bool) {
        
        return keccak256(abi.encodePacked(_promo1)) == keccak256(abi.encodePacked(_promo2));
        
    }
    
    
    //If validation Pass, Sending token to Fan 
    function getToken(address _useraddress, string calldata _username, uint _userage, string calldata _userPromoCode) external payable returns (string memory) {
        
        //Check the PromoCode entered is matching with already stored list of valid PromoCodes
        for (uint i=0; i< PromoCodes.length;i++) {
            bool validPromoCode = promoCodeComparison (_userPromoCode, PromoCodes[i]);
            if(validPromoCode) {
                
                //check if PromoCode is already applied or not
                require (promoCodeStateMapping[PromoCodes[i]]== PromoCodeState.ACTIVE);
                
                //Resetting to PromoCode given by user to INACTIVE
                promoCodeStateMapping[PromoCodes[i]]=PromoCodeState.INACTIVE;
            }
            
            
            //Storing all Fan data
            fandataMapping[_useraddress].name=_username;
            fandataMapping[_useraddress].age=_userage;
            fandataMapping[_useraddress].promoCodeUsed=_userPromoCode;
        }    
        
        return "Congratulations !!!!, your PromoCode is applied successfully";
        
    }
    
  
   //Based on Fan address, fetching all user data, only admin can execute this
    function getFanData(address _useraddress) external view onlyAdmin returns (string memory, uint, string memory){
        
        return (fandataMapping[_useraddress].name, fandataMapping[_useraddress].age, fandataMapping[_useraddress].promoCodeUsed);
        
    }
   
}
```
