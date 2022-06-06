pragma solidity ^0.4.21;
contract VotingSystem {
    struct Voter {
        bool authorized;
        bool voted;  
        uint vote;   
    }
    struct Proposal {
        string name;   
        uint voteCount; 
    }
    address public owner;
    string public electionName;
    mapping(address => Voter)public voters;
    Proposal[] public proposals;
    uint public totalVotes;
    modifier ownerOnly(){require(msg.sender==owner); _;}
    function VotingSystem(string _name)public{
        owner=msg.sender;
        electionName=_name;
    }
    function addProposal(string _name) ownerOnly public{
        proposals.push(Proposal(_name,0));
    }
    function getNumProposal() public view returns(uint){
        return proposals.length;
    }
    function authorize(address _person) ownerOnly public{
        voters[_person].authorized=true;
    }
    function vote(uint _voteIndex)public{
        require(!voters[msg.sender].voted);
        require(voters[msg.sender].authorized);
        voters[msg.sender].vote=_voteIndex;
        voters[msg.sender].voted=true;
        proposals[_voteIndex].voteCount+=1;
        totalVotes+=1;
    }
    function winningProposal() public view returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
        return p;
    }
    function winnerName() public view returns (string winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }

    function end() ownerOnly public{
        selfdestruct(owner);
    }
}