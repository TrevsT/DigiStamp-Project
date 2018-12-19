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
    mapping(address => Subject) subject;
    mapping(address => Authenticator) authenticator;
 
    
   struct Authenticator {
        bytes32  authenticatorName;
        bytes32[]   documentIDList;
        uint status; //Status defintions used to manage entities 1 = activte, 2 = inactive
    }
    
      struct Subject {
        bytes32  firstName;
        bytes32  lastName;
        bytes32 idNumber;
        bytes32 password; //Subject will be required to provide their password in
        //order to authorise the veriication by the requestor 
        uint status; //Status defintions used to manage entities 1 = activte, 2 = inactive
    }
    

    constructor() payable public {
        
        //TEST DATA 
        requestor[msg.sender] = "Some Employer";
        
        authenticator[0xc2d7cf95645d33006175b78989035c7c9061d3f9].authenticatorName = "DHA"; //0x4448410000000000000000000000000000000000000000000000000000000000
        authenticator[0xc2d7cf95645d33006175b78989035c7c9061d3f9].status = 1; 
        authenticator[0xc2d7cf95645d33006175b78989035c7c9061d3f9].documentIDList.push("test1"); //0x7465737431000000000000000000000000000000000000000000000000000000
        authenticator[0xc2d7cf95645d33006175b78989035c7c9061d3f9].documentIDList.push("test2"); //0x7465737432000000000000000000000000000000000000000000000000000000
        authenticator[0xc2d7cf95645d33006175b78989035c7c9061d3f9].documentIDList.push("test3"); //0x7465737433000000000000000000000000000000000000000000000000000000
        
        subject[0x0be885dd7317e4ce779435244acf2f68286ca8e2].firstName = "Test";
        subject[0x0be885dd7317e4ce779435244acf2f68286ca8e2].lastName = "Subject";
        subject[0x0be885dd7317e4ce779435244acf2f68286ca8e2].idNumber = "12345";
        subject[0x0be885dd7317e4ce779435244acf2f68286ca8e2].password = "SubjectPassword"; //0x5375626a65637450617373776f72640000000000000000000000000000000000
        subject[0x0be885dd7317e4ce779435244acf2f68286ca8e2].status = 1;
    }
    
event AddSubject(address _subjectAddress, bytes32 _firstName,  bytes32 _lastName, bytes32 indexed _idNumber) ;
event AddAuthenticator(address _authenticatorAddress, bytes32 _authenticatorName);
event AddDocument(address _authenticatorAddress, bytes32 _documentID,  bytes32 _authenticatorName);
event AuthenticationRequest(address _authenticatorAddress, address _subjectAddress, bytes32 _documentID, bytes32 _authenticatorName);

function addSubject (address _subjectAddress, bytes32 _firstName,  bytes32 _lastName, bytes32 _idNumber, bytes32 _password) public { 
        subject[_subjectAddress].status = 1; 
        subject[_subjectAddress].firstName = _firstName; 
        subject[_subjectAddress].lastName = _lastName; 
        subject[_subjectAddress].idNumber = _idNumber; 
        subject[_subjectAddress].password= _password;
        emit AddSubject(_subjectAddress, _firstName,_lastName, _idNumber);
} 


function addAuthenticator(address _authenticatorAddress, bytes32 _authenticatorName) public { 
        authenticator[_authenticatorAddress].status = 1; 
        authenticator[_authenticatorAddress].authenticatorName = _authenticatorName ;
        emit AddAuthenticator(_authenticatorAddress, _authenticatorName);
} 

        
function addDocument(address _authenticatorAddress, bytes32 _documentID,  bytes32 _authenticatorName) public returns (uint _docListLength) { 
        require(authenticator[_authenticatorAddress].authenticatorName == _authenticatorName);
        uint docListLength;
        emit AddDocument(_authenticatorAddress,_documentID, _authenticatorName);
        return  docListLength = authenticator[_authenticatorAddress].documentIDList.push(_documentID);
} 

    function authenticationRequest (address _authenticatorAddress, bytes32 _authenticatorSignature,uint8 _v, bytes32 _r, bytes32 _s, address _subjectAddress, bytes32 _subjectPassword, bytes32 _documentID, bytes32 _authenticatorName) public returns (bool) {
        
        require(checkSignature(_authenticatorAddress, _authenticatorSignature) == true);
        require(authenticator[_authenticatorAddress].authenticatorName == _authenticatorName);
        require(subject[_subjectAddress].password ==_subjectPassword); 
      
        for(uint i = 0; i < authenticator[_authenticatorAddress].documentIDList.length; ++i){
        if(authenticator[_authenticatorAddress].documentIDList[i] == _documentID){
        emit AuthenticationRequest( _authenticatorAddress,  _subjectAddress,  _documentID,  _authenticatorName);
            return true; 
        
        }
        }
        return false;
    }
    
    function checkSignature(address _addres, bytes32 signature) internal pure returns (bool){
          
        require(signature.length == 65);
          
        bytes32 r;
        bytes32 s;
        uint8 v;
         
          assembly {
        // first 32 bytes, after the length prefix
        r := mload(add(signature, 32))
        // second 32 bytes
        s := mload(add(signature, 64))
        // final byte (first byte of the next 32 bytes)
        v := byte(0, mload(add(signature, 96)))
    }

        
        return ecrecover(signature, v, r, s) == _addres;
    } 
    

}



