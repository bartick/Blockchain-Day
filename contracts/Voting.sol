// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }
    
    struct Voter {
        bool registered;
        bool hasVoted;
        uint256 votedCandidateId;
    }

    address public admin;
    bool public votingOpen;
    uint256 public candidateCount;
    mapping(uint256 => Candidate) public candidates;
    mapping(address => Voter) public voters;

    event CandidateAdded(uint256 candidateId, string name);
    event VoterRegistered(address voter);
    event VoteCast(address voter, uint256 candidateId);
    event VotingStarted();
    event VotingEnded();

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    modifier onlyDuringVoting() {
        require(votingOpen, "Voting is not open.");
        _;
    }

    constructor() {
        admin = msg.sender;
        votingOpen = false;
    }

    // Admin function to add a candidate
    function addCandidate(string memory _name) external onlyAdmin {
        require(!votingOpen, "Cannot add candidates during voting.");
        candidateCount++;
        candidates[candidateCount] = Candidate(_name, 0);
        emit CandidateAdded(candidateCount, _name);
    }

    // Register a voter
    function registerVoter(address _voter) external onlyAdmin {
        require(!voters[_voter].registered, "Voter is already registered.");
        voters[_voter] = Voter(true, false, 0);
        emit VoterRegistered(_voter);
    }

    // Start voting session
    function startVoting() external onlyAdmin {
        require(candidateCount > 1, "At least two candidates required to start voting.");
        require(!votingOpen, "Voting is already open.");
        votingOpen = true;
        emit VotingStarted();
    }

    // End voting session
    function endVoting() external onlyAdmin {
        require(votingOpen, "Voting is not currently open.");
        votingOpen = false;
        emit VotingEnded();
    }

    // Voter casts their vote
    function vote(uint256 _candidateId) external onlyDuringVoting {
        Voter storage sender = voters[msg.sender];
        require(sender.registered, "You are not a registered voter.");
        require(!sender.hasVoted, "You have already voted.");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID.");

        sender.hasVoted = true;
        sender.votedCandidateId = _candidateId;
        candidates[_candidateId].voteCount++;

        emit VoteCast(msg.sender, _candidateId);
    }

    // Get candidate details
    function getCandidate(uint256 _candidateId) external view returns (string memory name, uint256 voteCount) {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID.");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.name, candidate.voteCount);
    }

    // Get total votes for a specific candidate
    function getTotalVotes(uint256 _candidateId) external view returns (uint256) {
        require(!votingOpen, "Voting is still in progress.");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID.");
        return candidates[_candidateId].voteCount;
    }
}
