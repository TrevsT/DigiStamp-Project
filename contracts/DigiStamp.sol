pragma solidity ^0.4.25;


 /* The following contract serves to enable the authentication of a document
between an Authenticator (genearlly the doc issuer), the Subject (usually the Docuemt Holder),
and a Requestor. As an Authenticator I can verify a document that is held by a  holder of that document. 
In turn I can then validate that document to a Requstor based on a unique identifier of the document (e.g. Passport Number)
in conjuction with the signature of the doc holder which is provided to authorise th erequest.
the request. 
*/

contract Digistamp{

    //VARIABLES
    mapping(address => bytes32) requestor;
    mapping(address => bytes32) subject;
    mapping(address => Authenticator) authenticator;
    
    struct Authenticator {
        bytes32  authenticatorName;
        bytes32[]  documentUniqueIDList;
        uint status;
    }



    constructor() public {
        
        /*Creating a temp new Authenticaor and requestor within the constructor 
        to allow for testing and dev. Ideally this sould be with separate functions that are called
        each time a new Authenticator and Requestor is created*/
        requestor[msg.sender] = "Some Employer";
        
         
        authenticator[0].authenticatorName = "DHA" ;
        authenticator[0].documentUniqueIDList  = 

        [bytes32(0x6473646b33333966000000000000000000000000000000000000000000000000), 

         bytes32(0x686a643774346a66300000000000000000000000000000000000000000000000), 

         bytes32(0x6c38383866686a34000000000000000000000000000000000000000000000000), 

         bytes32(0x6173733431337363640000000000000000000000000000000000000000000000)]; 
         
        authenticator[0].status = 1; 
    }

        


    function authenticationRequest (bytes32 _documentUniqueID, bytes32 _authenticatorName ) public view returns (bool) {
        require(authenticator[0].authenticatorName == _authenticatorName);
        for(uint i = 0; i < authenticator[0].documentUniqueIDList.length; i++){
        if(authenticator[0].documentUniqueIDList[i] == _documentUniqueID){
            return true; 
        }
return false;
        }
    }
}

