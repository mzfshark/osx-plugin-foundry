// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.17;

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {PluginUUPSUpgradeable} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessor.sol";

abstract contract HarmonyVotingBase is PluginUUPSUpgradeable {
    enum VoteOption {
        None,
        Yes,
        No,
        Abstain
    }

    struct ProposalData {
        bytes32 metadata;
        uint64 startDate;
        uint64 endDate;
        uint64 snapshotBlock;
        bytes32 merkleRoot;
        bool closed;
        uint256 yes;
        uint256 no;
        uint256 abstain;
    }

    bytes32 public constant PROPOSER_PERMISSION_ID = keccak256("PROPOSER_PERMISSION");
    bytes32 public constant ORACLE_PERMISSION_ID = keccak256("ORACLE_PERMISSION");

    uint256 public proposalCount;

    mapping(uint256 => ProposalData) internal proposals;
    mapping(uint256 => mapping(address => VoteOption)) internal votes;
    mapping(uint256 => mapping(address => bool)) internal votingPowerSubmitted;

    event ProposalCreated(
        uint256 indexed proposalId,
        bytes32 indexed metadata,
        uint64 startDate,
        uint64 endDate,
        uint64 snapshotBlock
    );
    event MerkleRootSet(uint256 indexed proposalId, bytes32 indexed merkleRoot);
    event VoteCast(uint256 indexed proposalId, address indexed voter, VoteOption option);
    event VotingPowerSubmitted(uint256 indexed proposalId, address indexed voter, uint256 votingPower);
    event ProposalClosed(uint256 indexed proposalId);

    function initialize(address _dao) external initializer {
        __PluginUUPSUpgradeable_init(_dao);
    }

    function createProposal(
        bytes32 _metadata,
        uint64 _startDate,
        uint64 _endDate,
        uint64 _snapshotBlock
    ) external auth(PROPOSER_PERMISSION_ID) returns (uint256 proposalId) {
        if (_startDate >= _endDate) revert("INVALID_DATES");
        if (_snapshotBlock == 0) revert("INVALID_SNAPSHOT_BLOCK");

        proposalId = ++proposalCount;
        ProposalData storage p = proposals[proposalId];
        p.metadata = _metadata;
        p.startDate = _startDate;
        p.endDate = _endDate;
        p.snapshotBlock = _snapshotBlock;

        emit ProposalCreated(proposalId, _metadata, _startDate, _endDate, _snapshotBlock);
    }

    function setMerkleRoot(uint256 _proposalId, bytes32 _merkleRoot) external auth(ORACLE_PERMISSION_ID) {
        ProposalData storage p = proposals[_proposalId];
        if (p.endDate == 0) revert("PROPOSAL_NOT_FOUND");
        if (p.closed) revert("PROPOSAL_CLOSED");
        if (p.merkleRoot != bytes32(0)) revert("ROOT_ALREADY_SET");

        if (block.number < p.snapshotBlock) revert("SNAPSHOT_NOT_REACHED");
        if (block.timestamp >= p.endDate) revert("VOTING_ENDED");
        if (_merkleRoot == bytes32(0)) revert("INVALID_ROOT");

        p.merkleRoot = _merkleRoot;
        emit MerkleRootSet(_proposalId, _merkleRoot);
    }

    function castVote(uint256 _proposalId, VoteOption _option) external {
        ProposalData storage p = proposals[_proposalId];
        if (p.endDate == 0) revert("PROPOSAL_NOT_FOUND");
        if (p.closed) revert("PROPOSAL_CLOSED");
        if (block.timestamp < p.startDate) revert("VOTING_NOT_STARTED");
        if (block.timestamp >= p.endDate) revert("VOTING_ENDED");
        if (_option == VoteOption.None) revert("INVALID_OPTION");

        if (votingPowerSubmitted[_proposalId][msg.sender]) revert("VOTING_POWER_ALREADY_SUBMITTED");

        votes[_proposalId][msg.sender] = _option;
        emit VoteCast(_proposalId, msg.sender, _option);
    }

    function submitVotingPower(
        uint256 _proposalId,
        address _voter,
        uint256 _votingPower,
        bytes32[] calldata _proof
    ) external {
        ProposalData storage p = proposals[_proposalId];
        if (p.endDate == 0) revert("PROPOSAL_NOT_FOUND");
        if (p.closed) revert("PROPOSAL_CLOSED");
        if (block.timestamp >= p.endDate) revert("VOTING_ENDED");
        if (block.number < p.snapshotBlock) revert("SNAPSHOT_NOT_REACHED");
        if (p.merkleRoot == bytes32(0)) revert("ROOT_NOT_SET");
        if (votingPowerSubmitted[_proposalId][_voter]) revert("VOTING_POWER_ALREADY_SUBMITTED");

        VoteOption option = votes[_proposalId][_voter];
        if (option == VoteOption.None) revert("NO_VOTE_CAST");
        if (_votingPower == 0) revert("INVALID_VOTING_POWER");

        bytes32 leaf = keccak256(abi.encode(_voter, _votingPower));
        if (!MerkleProof.verify(_proof, p.merkleRoot, leaf)) revert("INVALID_PROOF");

        votingPowerSubmitted[_proposalId][_voter] = true;

        if (option == VoteOption.Yes) {
            p.yes += _votingPower;
        } else if (option == VoteOption.No) {
            p.no += _votingPower;
        } else {
            p.abstain += _votingPower;
        }

        emit VotingPowerSubmitted(_proposalId, _voter, _votingPower);
    }

    function closeProposal(uint256 _proposalId) external {
        ProposalData storage p = proposals[_proposalId];
        if (p.endDate == 0) revert("PROPOSAL_NOT_FOUND");
        if (p.closed) revert("PROPOSAL_CLOSED");
        if (block.timestamp < p.endDate) revert("VOTING_NOT_ENDED");
        p.closed = true;
        emit ProposalClosed(_proposalId);
    }

    function getProposal(uint256 _proposalId) external view returns (ProposalData memory) {
        return proposals[_proposalId];
    }

    function getVote(
        uint256 _proposalId,
        address _voter
    ) external view returns (VoteOption option, bool powerSubmitted) {
        option = votes[_proposalId][_voter];
        powerSubmitted = votingPowerSubmitted[_proposalId][_voter];
    }
}
