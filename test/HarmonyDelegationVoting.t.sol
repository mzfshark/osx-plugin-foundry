// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {TestBase} from "./lib/TestBase.sol";

import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {ProxyLib} from "@aragon/osx-commons-contracts/src/utils/deployment/ProxyLib.sol";
import {HarmonyDelegationVotingPlugin} from "../src/harmony/HarmonyDelegationVotingPlugin.sol";
import {HarmonyVotingBase} from "../src/harmony/HarmonyVotingBase.sol";

contract HarmonyDelegationVotingTest is TestBase {
    DAO dao;
    HarmonyDelegationVotingPlugin plugin;

    address daoOwner;
    address oracle;
    address validator;
    address newValidator;

    function setUp() public {
        daoOwner = alice;
        oracle = bob;
        validator = address(0x1234);
        newValidator = address(0x5678);

        DAO daoBase = new DAO();
        HarmonyDelegationVotingPlugin pluginBase = new HarmonyDelegationVotingPlugin();

        dao = DAO(
            payable(
                ProxyLib.deployUUPSProxy(
                    address(daoBase),
                    abi.encodeCall(DAO.initialize, ("", daoOwner, address(0x0), ""))
                )
            )
        );

        plugin = HarmonyDelegationVotingPlugin(
            ProxyLib.deployUUPSProxy(
                address(pluginBase),
                abi.encodeCall(HarmonyDelegationVotingPlugin.initialize, (dao, validator))
            )
        );

        vm.startPrank(daoOwner);
        dao.grant(address(plugin), oracle, plugin.ORACLE_PERMISSION_ID());
        dao.grant(address(plugin), daoOwner, plugin.UPDATE_VALIDATOR_PERMISSION_ID());
        vm.stopPrank();

        vm.label(address(dao), "DAO");
        vm.label(address(plugin), "HarmonyDelegationVotingPlugin");
    }

    function test_InitialValidatorAddressStored() external {
        assertEq(plugin.validatorAddress(), validator);
    }

    function test_RevertWhen_SetValidatorAddressZero() external {
        vm.prank(daoOwner);
        vm.expectRevert();
        plugin.setValidatorAddress(address(0));
    }

    function test_UpdateValidatorAddressWithPermission() external {
        vm.prank(daoOwner);
        plugin.setValidatorAddress(newValidator);
        assertEq(plugin.validatorAddress(), newValidator);
    }

    function test_RevertWhen_UpdateValidatorWithoutPermission() external {
        vm.prank(carol);
        vm.expectRevert();
        plugin.setValidatorAddress(newValidator);
    }

    function _hashPair(bytes32 a, bytes32 b) internal pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a, b)) : keccak256(abi.encodePacked(b, a));
    }

    function test_Flow_CastThenSnapshotThenSubmitPowerThenClose() external {
        uint64 startDate = uint64(block.timestamp);
        uint64 endDate = uint64(block.timestamp + 10_000);
        uint64 snapshotBlock = uint64(block.number + 10);

        vm.deal(carol, 1 ether);
        vm.deal(david, 1 ether);

        vm.prank(carol);
        uint256 proposalId = plugin.createProposal(bytes32("delegation"), startDate, endDate, snapshotBlock);

        vm.prank(carol);
        plugin.castVote(proposalId, HarmonyVotingBase.VoteOption.Yes);

        vm.prank(david);
        plugin.castVote(proposalId, HarmonyVotingBase.VoteOption.No);

        vm.prank(oracle);
        vm.expectRevert("SNAPSHOT_NOT_REACHED");
        plugin.setMerkleRoot(proposalId, bytes32(uint256(1)), 1);

        vm.roll(uint256(snapshotBlock));

        uint256 carolPower = 100;
        uint256 davidPower = 50;

        bytes32 carolLeaf = keccak256(abi.encodePacked(carol, carolPower));
        bytes32 davidLeaf = keccak256(abi.encodePacked(david, davidPower));
        bytes32 root = _hashPair(carolLeaf, davidLeaf);

        vm.prank(oracle);
        vm.expectRevert("FINALIZATION_NOT_STARTED");
        plugin.setMerkleRoot(proposalId, root, carolPower + davidPower);

        vm.warp(uint256(endDate));

        vm.prank(oracle);
        plugin.setMerkleRoot(proposalId, root, carolPower + davidPower);

        bytes32[] memory proofCarol = new bytes32[](1);
        proofCarol[0] = davidLeaf;

        vm.prank(alice);
        plugin.submitVotingPower(proposalId, carol, carolPower, proofCarol);

        bytes32[] memory proofDavid = new bytes32[](1);
        proofDavid[0] = carolLeaf;

        vm.prank(alice);
        plugin.submitVotingPower(proposalId, david, davidPower, proofDavid);

        vm.prank(carol);
        vm.expectRevert("VOTING_ENDED");
        plugin.castVote(proposalId, HarmonyVotingBase.VoteOption.No);

        HarmonyDelegationVotingPlugin.ProposalData memory p = plugin.getProposal(proposalId);
        assertEq(p.yes, carolPower);
        assertEq(p.no, davidPower);
        assertEq(p.abstain, 0);

        vm.expectRevert("FINALIZATION_NOT_ENDED");
        plugin.closeProposal(proposalId);

        vm.prank(oracle);
        plugin.oracleCloseProposal(proposalId);

        p = plugin.getProposal(proposalId);
        assertTrue(p.closed);
        assertTrue(p.passed);

        vm.prank(david);
        vm.expectRevert("PROPOSAL_CLOSED");
        plugin.castVote(proposalId, HarmonyVotingBase.VoteOption.Yes);
    }
}
