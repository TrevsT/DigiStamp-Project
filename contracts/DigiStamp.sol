pragma solidity ^0.4.25;

contract DigiStamp{
    // Contract to capture and authenticate digital signatures between a document issuer, the document subject and the requestor.
    mapping(address => string) requestor;
    //mapping(address => string) subject;
    bytes32 public documentUniqueID;

    struct authenticator{
        bytes32 authenticatorName;
        bytes32[]  documentUniqueIDList;
    }

     authenticator public newAuthenticator;

    constructor() public {
        requestor[msg.sender] = "Some Employer";
        newAuthenticator.authenticatorName = "DHA" ; 
        newAuthenticator.documentUniqueIDList  = 
        [bytes32(0x6473646b33333966000000000000000000000000000000000000000000000000), 
         bytes32(0x686a643774346a66300000000000000000000000000000000000000000000000), 
         bytes32(0x6c38383866686a34000000000000000000000000000000000000000000000000), 
         bytes32(0x6173733431337363640000000000000000000000000000000000000000000000)]; 
    }

    function authenticationRequest (bytes32 _documentUniqueID, bytes32 _authenticatorName ) public returns (bool) {
    require(newAuthenticator.authenticatorName == _authenticatorName);
    for(uint i = 0; i < newAuthenticator.documentUniqueIDList.length; i++){
        if(newAuthenticator.documentUniqueIDList[i] == _documentUniqueID){
            return true; 
        }
    }
    }
}





}
