// we are building: A dApp which allows any user to issue a bounty in ETH

// Any user with an Ethereum account can issue a bounty in ETH along with some requirements
// Any user can submit a fulfilment of the bounty along with some evidence
// The bounty issuer can accept a fulfilment which would result in the fulfiller being paid out


pragma solidity ^0.5.0;

// To create the contract class, we add the following:
contract Bounties {
    /**
    * @dev Contructor
    */
    constructor() public {}

    /*
    * Enums
    */
//First, let's declare an enum which we use to keep track of a bounties state:
enum BountyStatus { CREATED, ACCEPTED, CANCELLED }

// Next, we define a struct which defines the data held about an issued bounty:
    /*
    * Structs
    */
struct Bounty {
 address issuer;
 uint deadline;
 string data;
 BountyStatus status;
 uint amount;
}

    /*
    * Storage
    */
//Now, let's define an array where we store data about each issued bounty:
Bounty[] public bounties;


//Issue Bounty Function
    /**
    * @dev issueBounty(): instantiates a new bounty
    * @param _deadline the unix timestamp after which fulfillments will no longer be accepted
    * @param _data the requirements of the bounty
    */
function issueBounty(
    string memory _data,
    uint64 _deadline
)

public payable hasValue() validateDeadline(_deadline) returns (uint)
{

    // First, we insert a new Bounty struct to out bounties array, setting the BountyStatus to CREATED.

    // In Solidity, msg.sender is automatically set as the address of the sender, and msg.value is set to 
    // the amount of Weis ( 1 ETH = 1000000000000000000 Weis).

    // We set the msg.sender as the issuer and the msg.value as the bounty amount.

    bounties.push(Bounty(msg.sender, _deadline, _data, BountyStatus.CREATED, msg.value));
    emit BountyIssued(bounties.length - 1,msg.sender, msg.value, _data);
    return (bounties.length - 1);
}


    /**
    * Modifiers
    */
//hasValue() is added to ensure msg.value is a non zero value. 
modifier hasValue() {
 require(msg.value > 0);
 _;
}

//Validate Deadline
modifier validateDeadline(uint _newDeadline) {
 require(_newDeadline > now);
 _;
}

    /**
    * Events
    */
    event BountyIssued(uint bounty_id, address issuer, uint amount, string data);

}