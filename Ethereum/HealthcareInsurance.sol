pragma solidity ^0.6.0;

contract Insurance {
    address owner;
    
    struct Patient {
        bool ispatientidgenerated;
        string name;
        uint insuredamount;
    }
    
    mapping (address =>Patient) public patientmapping;
    mapping(address =>bool) public authoriseddoctor;
    
    constructor() public {
        owner=msg.sender;
    }
    
    modifier onlyOwner() {
        require(owner==msg.sender);
        _;
    }
    
    function setDoctor(address _doctoraddress) onlyOwner public {
        require(!authoriseddoctor[_doctoraddress]);
        authoriseddoctor[_doctoraddress]=true;
    }
    
    function setPatientData(string memory _name, uint _insuredamount) onlyOwner public returns(address) {
        address patientid= address(bytes20(sha256(abi.encodePacked(msg.sender,now))));
        
        require(!patientmapping[patientid].ispatientidgenerated);
        patientmapping[patientid].ispatientidgenerated=true;
        patientmapping[patientid].name=_name;
        patientmapping[patientid].insuredamount=_insuredamount;
        
        return patientid;
    }
    
    function insuranceApprove(address _patientId, uint _claimamount) public returns(string memory) {
        
        require(authoriseddoctor[msg.sender]);
        if(patientmapping[_patientId].insuredamount<_claimamount) {
            revert();
            }
            
        patientmapping[_patientId].insuredamount-=_claimamount;
        
        return "Insurance claim amount is approved";
    }
}