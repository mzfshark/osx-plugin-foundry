// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {TestBase} from "./lib/TestBase.sol";

import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {DaoUnauthorized} from "@aragon/osx-commons-contracts/src/permission/auth/auth.sol";
import {HarmonyHIPVotingPlugin} from "../src/harmony/HarmonyHIPVotingPlugin.sol";
import {HarmonyVotingBase} from "../src/harmony/HarmonyVotingBase.sol";
import {HarmonyVotingBuilder} from "./builders/HarmonyVotingBuilder.sol";

contract HarmonyVotingTest is TestBase {
    DAO dao;
    HarmonyHIPVotingPlugin plugin;

    address proposer;
    address oracle;

    function setUp() public {
        proposer = alice;
        oracle = bob;

        (dao, plugin) = new HarmonyVotingBuilder().withDaoOwner(alice).build(proposer, oracle);
    }

    function _hashPair(bytes32 a, bytes32 b) internal pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a, b)) : keccak256(abi.encodePacked(b, a));
    }

    function test_RevertWhen_CreateProposalWithoutPermission() external {
        vm.expectRevert(
            abi.encodeWithSelector(
                DaoUnauthorized.selector,
                dao,
                plugin,
                carol,
                plugin.PROPOSER_PERMISSION_ID()
            )
        );

        vm.prank(carol);

        plugin.createProposal(bytes32("m"), uint64(block.timestamp), uint64(block.timestamp + 100), uint64(10));
    }

    function test_Flow_CastThenSnapshotThenSubmitPowerThenClose() external {
        uint64 startDate = uint64(block.timestamp);
        uint64 endDate = uint64(block.timestamp + 10_000);
        uint64 snapshotBlock = uint64(block.number + 10);

        vm.prank(proposer);
        uint256 proposalId = plugin.createProposal(bytes32("hip"), startDate, endDate, snapshotBlock);

        vm.prank(carol);
        plugin.castVote(proposalId, HarmonyVotingBase.VoteOption.Yes);

        vm.prank(david);
        plugin.castVote(proposalId, HarmonyVotingBase.VoteOption.No);

        // Cannot set root before snapshot block.
        vm.prank(oracle);
        vm.expectRevert("SNAPSHOT_NOT_REACHED");
        plugin.setMerkleRoot(proposalId, bytes32(uint256(1)));

        // Move to snapshot block.
        vm.roll(uint256(snapshotBlock));

        uint256 carolPower = 100;
        uint256 davidPower = 50;

        bytes32 carolLeaf = keccak256(abi.encodePacked(carol, carolPower));
        bytes32 davidLeaf = keccak256(abi.encodePacked(david, davidPower));
        bytes32 root = _hashPair(carolLeaf, davidLeaf);

        vm.prank(oracle);
        vm.expectRevert("FINALIZATION_NOT_STARTED");
        plugin.setMerkleRoot(proposalId, root);

        // Move to finalization window.
        vm.warp(uint256(endDate));

        vm.prank(oracle);
        plugin.setMerkleRoot(proposalId, root);

        bytes32[] memory proofCarol = new bytes32[](1);
        proofCarol[0] = davidLeaf;

        vm.prank(alice);
        plugin.submitVotingPower(proposalId, carol, carolPower, proofCarol);

        // Vote becomes immutable once power is submitted.
        vm.prank(carol);
        vm.expectRevert("VOTING_POWER_ALREADY_SUBMITTED");
        plugin.castVote(proposalId, HarmonyVotingBase.VoteOption.No);

        HarmonyVotingBase.ProposalData memory p = plugin.getProposal(proposalId);
        assertEq(p.yes, carolPower);
        assertEq(p.no, 0);
        assertEq(p.abstain, 0);

        // Cannot close until finalization window ends.
        vm.expectRevert("FINALIZATION_NOT_ENDED");
        plugin.closeProposal(proposalId);

        // Closing after finalization window.
        vm.warp(uint256(endDate) + uint256(plugin.FINALIZATION_PERIOD()));
        plugin.closeProposal(proposalId);

        vm.prank(david);
        vm.expectRevert("PROPOSAL_CLOSED");
        plugin.castVote(proposalId, HarmonyVotingBase.VoteOption.Yes);
    }
}
