pragma solidity ^0.5.1;

//Getting this error
//You have not set a script to run. Set it with @custom:dev-run-script NatSpec tag.


library SafeMath { 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a); //error handling condition
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}
 
contract IntelliContract {

    string public constant name = "IntelliCoin"; // solidity automatically creates a getter function for public variables
    string public constant symbol = "ITC"; // getter function is a function used to retrive a specific value from ledger
    uint8 public constant decimals = 18;  
       
// Setter functions : Function Which Creates or Updates A Value on Legder.
// Getter Functions : Function Which Get or Fetches A Value From Legder.

    event Approval(address indexed tokenOwner, address  spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);


    modifier onlyOwner  {
        require (msg.sender == ownerCon);
        _;
    }
    
    mapping(address => uint256) balances;  
    mapping(address => mapping (address => uint256)) allowed;  // nested mapping
    // Nested Mapping Has 2 Keys & 1 Value

    uint256 totalSupply_;
    address ownerCon;
    using SafeMath for uint256;


   constructor(uint256 total) public {  // special function , only called at time of deployemnet
	totalSupply_ = total ;
	balances[msg.sender] = totalSupply_ ;  // To Deposit all the newly generated tokens in owner's account
	ownerCon = msg.sender;
    }  

    function totalSupply() public view returns (uint256) {
	return totalSupply_;
    }
    // getter function

    function balanceOf(address inputAddress) public view returns (uint) {
        return balances[inputAddress] ;
    }
    // getter function 
    
    


    function approve(address approved_addr, uint numTokens) public returns (bool) {
        allowed[msg.sender][approved_addr] = numTokens;
        emit Approval(msg.sender, approved_addr, numTokens);
        return true;
    }


    function allowance(address owner, address token_manger) public view returns (uint) {
        return allowed[owner][token_manger];
    }// what allowance has been provided by token_owner to Token_manager



    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);    
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }




// create a feature to selfdestruct but it should only be called by owner .
// we want to increase the total supply of tokens (only be called by owner : Modifiers)
// we want to burn some of tokens out of  total supply of tokens (only be called by owner)
//--------------------------------------------------------------------------//
// we want to transfer tokens only to whitelisted addresses ,firstly you will have to create a function to whitelist addresses , and then at time of transfer we will have to ensure that its one of whitelisted address

//Task - 1  : Self Destruct 
//Ques - What is diff b/w address and address payable ?
function _selfDestruct(address payable _receiverAddress) public onlyOwner {
    selfdestruct(_receiverAddress);
}


//Task - 2  : Increase the total supply
  function increaseSupply (uint increasedAmount) public onlyOwner returns(bool){
    balances[ownerCon] = balances[ownerCon].add(increasedAmount);
    totalSupply_ = totalSupply_.add(increasedAmount);
    emit Transfer(address(0), ownerCon, increasedAmount);
}

//Task - 3  : Burn some coins
 function decreaseSupply (uint burnAmount) public onlyOwner returns(bool){
    balances[ownerCon] = balances[ownerCon].sub(burnAmount);
    totalSupply_ = totalSupply_.sub(burnAmount);
     emit Transfer(ownerCon,address(0), burnAmount);
}

//Task - 4  : Transfer only to whitelisted addresses
mapping(address => bool) allwhitelistedAddresses;

//Function to whitelist the address.
modifier isAddressWhitelisted(address _address) {
    require(allwhitelistedAddresses[_address], "This Address is Not Whitelisted");
    _;
    }

    function addaddress(address _addressToWhitelist) public onlyOwner {
         allwhitelistedAddresses[_addressToWhitelist] = true;
    }

//Function to transer the token only to whitelisted addesses.
function transfer(address receiver, uint numTokens) public isAddressWhitelisted(msg.sender) returns (bool) {
        require(numTokens <= balances[msg.sender], "Not Sufficient Balance");
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens); // logging these values using events
        return true;
    }

}