// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/// @title Voting with delegation.
/// @author The Buidlers
/// @notice You can use this contract for understanding how voting contracts work
/// @dev You're gonna make it
contract Ballot {    
    /**
     * @dev This declares a new complex type which will be used for variables later. It represents a single voter.
     * Below are the properties of this data type    
     * - voted: if true, that person already voted
     * - delegate: user delegated to
     * - weight: accumulated by delegation
     * - vote: index of the voted proposal
     */
    struct Voter {
        bool voted;
        address delegate;
        uint256 weight;
        uint256 vote;
    }

    /// @dev This is a type for a single proposal.    
    struct Proposal {
        /// @dev short name (up to 32 bytes)
        bytes32 name;
        /// @dev number of accumulated votes
        uint256 voteCount;
    }

    address public chairperson;

    /// @dev This declares a state variable that stores a `Voter` struct for each possible address.    
    mapping(address => Voter) public voters;

    /// @dev A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;

    /// @dev Create a new ballot to choose one of `proposalNames`.
    /// @param proposalNames Proposals are names for different proposals which will be voted upon in the contract
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        /// @dev For each of the provided proposal names, create a new proposal object and append to temp proposals array
        for (uint256 i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    /// @dev Give `voter` the right to vote on this ballot. This may only be called by `chairperson`.
    /// @param voter Voter is the address of the voter
    function giveRightToVote(address voter) external {
        /**
        * @dev If the first argument of `require` evaluates
        * to `false`, execution terminates and all
        * changes to the state and to Ether balances are reverted.
        * This used to consume all gas in old EVM versions, but not anymore.
        * It is often a good practise to use `require` to check if functions are called correctly.
        * As a second argument, you can also provide an
        * explanation about what went wrong.
        */
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }
    
    /// @param to To is the address of the voter you delegate your vote to
    function delegate(address to) external {
        /// @dev assigns reference
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");

        /**
        * @dev Forward the delegation as long as
        * `to` also delegated.
        * In general, such loops are very dangerous,
        * because if they run too long, they might
        * need more gas than is available in a block.
        * In this case, the delegation will not be executed,
        * but in other situations, such loops might
        * cause a contract to get "stuck" completely.
        **/        
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            /// @dev We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }

        /// @dev Since `sender` is a reference, this modifies `voters[msg.sender].voted`
        Voter storage delegate_ = voters[to];

        /// @dev Voters cannot delegate to wallets that cannot vote.
        require(delegate_.weight >= 1);
        sender.voted = true;
        sender.delegate = to;
        if (delegate_.voted) {
            /// @dev If the delegate already voted, directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            /// @dev If the delegate did not vote yet, add to her weight.
            delegate_.weight += sender.weight;
        }
    }

    /// @dev Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    /// @param proposal Proposal is the id of the proposal
    function vote(uint256 proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        /// @dev If `proposal` is out of the range of the array,
        /// this will throw automatically and revert all changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    /// @return winningProposal_ returns the winning proposal
    function winningProposal() public view returns (uint256 winningProposal_) {
        uint256 winningVoteCount = 0;
        /// @dev Gas optimization
        Proposal[] memory localProposals = proposals;
        for (uint256 p = 0; p < localProposals.length; p++) {
            if (localProposals[p].voteCount > winningVoteCount) {
                winningVoteCount = localProposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    /// @dev Calls winningProposal() function to get the index
    /// of the winner contained in the proposals array
    /// @return winnerName_ returns the name of the winner
    function winnerName() external view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
