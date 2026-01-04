// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.17;

import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {PluginUUPSUpgradeable} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessor.sol";
import {IDAO} from "@aragon/osx/core/dao/DAO.sol";

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
        bool passed;
        uint256 totalEligiblePower;
        uint256 yes;
        uint256 no;
        uint256 abstain;
    }

    bytes32 public constant PROPOSER_PERMISSION_ID = keccak256("PROPOSER_PERMISSION");
    bytes32 public constant ORACLE_PERMISSION_ID = keccak256("ORACLE_PERMISSION");

    /// @notice Window after `endDate` where the oracle/automation can finalize the proposal by
    /// setting the Merkle root and submitting voting power.
    /// @dev Chosen to keep the protocol non-interactive for validators after voting.
    uint64 public constant FINALIZATION_PERIOD = 2 days;

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
    event MerkleRootSet(uint256 indexed proposalId, bytes32 indexed merkleRoot, uint256 totalEligiblePower);
    event VoteCast(uint256 indexed proposalId, address indexed voter, VoteOption option);
    event VotingPowerSubmitted(uint256 indexed proposalId, address indexed voter, uint256 votingPower);
    event ProposalClosed(uint256 indexed proposalId, bool passed);

    function __HarmonyVotingBase_init(IDAO _dao) internal onlyInitializing {
        __PluginUUPSUpgradeable_init(_dao);
    }

    function createProposal(
        bytes32 _metadata,
        uint64 _startDate,
        uint64 _endDate,
        uint64 _snapshotBlock
    ) external returns (uint256 proposalId) {
        // Harmony ONE has 18 decimals, so 1 ONE == 1e18 (same as `1 ether`).
        if (msg.sender.balance < 1 ether) revert("INSUFFICIENT_PROPOSER_BALANCE");
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

    function setMerkleRoot(
        uint256 _proposalId,
        bytes32 _merkleRoot,
        uint256 _totalEligiblePower
    ) external auth(ORACLE_PERMISSION_ID) {
        ProposalData storage p = proposals[_proposalId];
        if (p.endDate == 0) revert("PROPOSAL_NOT_FOUND");
        if (p.closed) revert("PROPOSAL_CLOSED");
        if (p.merkleRoot != bytes32(0)) revert("ROOT_ALREADY_SET");

        if (block.number < p.snapshotBlock) revert("SNAPSHOT_NOT_REACHED");
        if (block.timestamp < p.endDate) revert("FINALIZATION_NOT_STARTED");
        if (block.timestamp >= p.endDate + FINALIZATION_PERIOD) revert("FINALIZATION_ENDED");
        if (_merkleRoot == bytes32(0)) revert("INVALID_ROOT");
        if (_totalEligiblePower == 0) revert("INVALID_TOTAL_ELIGIBLE_POWER");

        p.merkleRoot = _merkleRoot;
        p.totalEligiblePower = _totalEligiblePower;
        emit MerkleRootSet(_proposalId, _merkleRoot, _totalEligiblePower);
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
        if (block.timestamp < p.endDate) revert("FINALIZATION_NOT_STARTED");
        if (block.timestamp >= p.endDate + FINALIZATION_PERIOD) revert("FINALIZATION_ENDED");
        if (block.number < p.snapshotBlock) revert("SNAPSHOT_NOT_REACHED");
        if (p.merkleRoot == bytes32(0)) revert("ROOT_NOT_SET");
        if (votingPowerSubmitted[_proposalId][_voter]) revert("VOTING_POWER_ALREADY_SUBMITTED");

        VoteOption option = votes[_proposalId][_voter];
        if (option == VoteOption.None) revert("NO_VOTE_CAST");
        if (_votingPower == 0) revert("INVALID_VOTING_POWER");

        bytes32 leaf = keccak256(abi.encodePacked(_voter, _votingPower));
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
        if (block.timestamp < p.endDate + FINALIZATION_PERIOD) revert("FINALIZATION_NOT_ENDED");

        _closeProposal(p, _proposalId);
    }

    /// @notice Allows the oracle to close the proposal as soon as voting ended, without waiting
    /// for `FINALIZATION_PERIOD` to elapse.
    /// @dev This assumes the oracle/automation has already set the Merkle root and submitted
    /// voting power proofs for the voters to produce a final tally.
    function oracleCloseProposal(uint256 _proposalId) external auth(ORACLE_PERMISSION_ID) {
        ProposalData storage p = proposals[_proposalId];
        if (p.endDate == 0) revert("PROPOSAL_NOT_FOUND");
        if (p.closed) revert("PROPOSAL_CLOSED");
        if (block.timestamp < p.endDate) revert("VOTING_NOT_ENDED");
        if (block.timestamp >= p.endDate + FINALIZATION_PERIOD) revert("FINALIZATION_ENDED");
        if (block.number < p.snapshotBlock) revert("SNAPSHOT_NOT_REACHED");

        _closeProposal(p, _proposalId);
    }

    function _closeProposal(ProposalData storage p, uint256 _proposalId) internal {
        if (p.merkleRoot == bytes32(0)) revert("ROOT_NOT_SET");
        if (p.totalEligiblePower == 0) revert("TOTAL_ELIGIBLE_POWER_NOT_SET");

        // Quorum: 51% of total eligible power.
        uint256 totalCast = p.yes + p.no + p.abstain;
        bool quorumReached = totalCast * 100 >= p.totalEligiblePower * 51;

        // Approval (A): yes / (yes + no) >= 2/3.
        uint256 yesNo = p.yes + p.no;
        bool approvalReached = yesNo != 0 && p.yes * 3 >= yesNo * 2;

        p.passed = quorumReached && approvalReached;
        p.closed = true;
        emit ProposalClosed(_proposalId, p.passed);
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
