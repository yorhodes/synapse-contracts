pragma solidity ^0.4.23;


contract Proposal {
    uint expiration;
    uint8 majorityThreshold;
    uint votesFor;
    uint votesAgainst; 
    bytes32 fileHash;

    constructor(bytes32 _fileHash, uint _lifeSpan, uint8 _majorityThreshold) public {
        fileHash = _fileHash;
        expiration = now + _lifeSpan;
        majorityThreshold = _majorityThreshold;
    }
}
