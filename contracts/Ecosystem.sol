pragma solidity ^0.4.23;


contract Proposal {
    uint private expiration;
    uint8 private majorityThreshold;
    uint private votesFor;
    uint private votesAgainst;

    address private owner;

    constructor(uint _lifeSpan, uint8 _majorityThreshold) public {
        expiration = now + _lifeSpan;
        majorityThreshold = _majorityThreshold;
        votesFor = 0;
        votesAgainst = 0;
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function approve(uint amt) public onlyOwner {
        votesFor += amt;
    }

    function deny(uint amt) public onlyOwner {
        votesAgainst += amt;
    }

    function isExpired() public constant returns (bool) {
        return expiration < now;
    }

    function shouldBeApproved() public
        constant returns (bool)
    {
        return (100 * votesFor) > (majorityThreshold * (votesFor + votesAgainst));
    }
}


contract MintToken {
    mapping(address => uint256) private balance; 
    uint private mintReward;

    constructor(uint _mintReward, address creator) public {
        mintReward = _mintReward;
        mintTo(creator);
    }

    function mintTo(address user) public {
        balance[user] += mintReward;
    }

    function getBalance(address user) public constant returns (uint256) {
        return balance[user];
    }

    function getAddress() public constant returns (address) {
        return this;
    }
}


contract Ecosystem {
    uint private constant MINT_REWARD = 1;
    uint private constant PROPOSAL_DURATION = 259200;
   
    Proposal private proposal;
    MintToken private token;

    bytes32 public fileHash;
    bytes32 private proposedFileHash;

    bool private resolved;

    constructor() public {
        token = new MintToken(MINT_REWARD, msg.sender);
    }

    modifier isResolved {
        require(resolved);
        _;
    }

    modifier isNotResolved {
        require(!resolved);
        _;
    }

    function submitProposal(bytes32 newFileHash) public isResolved {
        proposedFileHash = newFileHash;
        proposal = new Proposal(PROPOSAL_DURATION, 50);
        resolved = false;
    }

    function castApproval() public isNotResolved {
        proposal.approve(getSenderBalance());
    }

    function castRejection() public isNotResolved {
        proposal.deny(getSenderBalance());
    }

    function resolve() public isNotResolved {
        require(proposal.isExpired());

        if (proposal.shouldBeApproved())
            fileHash = proposedFileHash; 
        
        resolved = true;
    }

    function getSenderBalance() private constant returns (uint) {
        return token.getBalance(msg.sender);
    }
}
