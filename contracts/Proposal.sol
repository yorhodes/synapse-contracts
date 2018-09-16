pragma solidity ^0.4.23;


contract Proposal {
    uint private expiration;
    uint8 private majorityThreshold;
    uint private votesFor;
    uint private votesAgainst; 

    event proposalResolved(bool approved);

    constructor(uint _lifeSpan, uint8 _majorityThreshold) public {
        expiration = now + _lifeSpan;
        majorityThreshold = _majorityThreshold;
        votesFor = 0;
        votesAgainst = 0;
    }

    modifier isExpired {
        require(expiration > now);
        _;
    }

    function approve(uint amt) public {
        votesFor += amt;
    }

    function deny(uint amt) public {
        votesAgainst += amt;
    }

    function resolve() public 
        isExpired
    {
        bool winCondition = (100 * votesFor) > (majorityThreshold * (votesFor + votesAgainst));

        emit proposalResolved(winCondition);
    }
}
