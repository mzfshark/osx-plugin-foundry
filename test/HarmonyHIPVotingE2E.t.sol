// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {ProxyLib} from "@aragon/osx-commons-contracts/src/utils/deployment/ProxyLib.sol";
import {HarmonyHIPVotingPlugin} from "../src/harmony/HarmonyHIPVotingPlugin.sol";
import {HarmonyValidatorOptInRegistry} from "../src/harmony/HarmonyValidatorOptInRegistry.sol";
import {HIPPluginAllowlist} from "../src/harmony/HIPPluginAllowlist.sol";
import {IHarmonyValidatorOptInRegistry, IHIPPluginAllowlist} from "../src/harmony/IHarmonyInterfaces.sol";
import {HarmonyVotingBase} from "../src/harmony/HarmonyVotingBase.sol";

contract HarmonyHIPVotingE2ETest is Test {
    DAO dao;
    HarmonyHIPVotingPlugin plugin;
    HarmonyValidatorOptInRegistry registry;
    HIPPluginAllowlist allowlist;

    address managementDao = address(0xBADBEEF);
    address validator1 = address(0x111);
    address alias1 = address(0xAAA);
    address validator2 = address(0x222);
    
    function setUp() public {
        vm.label(managementDao, "ManagementDAO");
        vm.label(validator1, "Validator1");
        vm.label(alias1, "Alias1");
        vm.label(validator2, "Validator2");

        // 1. Deploy bases
        address daoBase = address(new DAO());
        address registryBase = address(new HarmonyValidatorOptInRegistry());
        address allowlistBase = address(new HIPPluginAllowlist());
        address pluginBase = address(new HarmonyHIPVotingPlugin());

        // 2. Initialize DAO
        dao = DAO(payable(ProxyLib.deployUUPSProxy(daoBase, abi.encodeCall(DAO.initialize, ("", address(this), address(0), "")))));
        
        // 3. Initialize Registry & Allowlist (Using DAO as manager for simplicity)
        registry = HarmonyValidatorOptInRegistry(ProxyLib.deployUUPSProxy(registryBase, abi.encodeCall(HarmonyValidatorOptInRegistry.initialize, (dao))));
        allowlist = HIPPluginAllowlist(ProxyLib.deployUUPSProxy(allowlistBase, abi.encodeCall(HIPPluginAllowlist.initialize, (dao))));

        // 4. Initialize Plugin
        plugin = HarmonyHIPVotingPlugin(
            ProxyLib.deployUUPSProxy(
                pluginBase,
                abi.encodeCall(
                    HarmonyHIPVotingPlugin.initialize,
                    (dao, IHarmonyValidatorOptInRegistry(address(registry)), IHIPPluginAllowlist(address(allowlist)))
                )
            )
        );

        // 5. Setup Allowlist
        dao.grant(address(allowlist), address(this), allowlist.MANAGE_ALLOWLIST_PERMISSION_ID());
        allowlist.allowDAO(address(dao));

        // 6. Setup Plugin Permissions
        dao.grant(address(plugin), address(this), plugin.ORACLE_PERMISSION_ID());
        dao.grant(address(registry), address(plugin), registry.REPORT_PARTICIPATION_PERMISSION_ID());

        vm.deal(validator1, 10 ether);
        vm.deal(alias1, 10 ether);
        vm.deal(validator2, 10 ether);
    }

    function test_E2E_AliasVotingFlow() public {
        // Step 1: Opt-in with alias
        vm.prank(validator1);
        registry.optIn(alias1);

        // Step 2: Create Proposal using ALIAS
        vm.prank(alias1);
        uint256 proposalId = plugin.createProposal("metadata", uint64(block.timestamp + 1), uint64(block.timestamp + 1000), 100);
        
        assertEq(proposalId, 1);

        // Step 3: Cast Vote using ALIAS
        vm.warp(block.timestamp + 10);
        vm.prank(alias1);
        plugin.castVote(proposalId, HarmonyVotingBase.VoteOption.Yes);

        (HarmonyVotingBase.VoteOption option, ) = plugin.getVote(proposalId, validator1);
        assertEq(uint8(option), uint8(HarmonyVotingBase.VoteOption.Yes));
        
        // Ensure alias resolving works
        (option, ) = plugin.getVote(proposalId, alias1);
        assertEq(uint8(option), uint8(HarmonyVotingBase.VoteOption.Yes));
    }

    function test_E2E_AutoOptOut() public {
        // Opt-in two validators
        vm.prank(validator1);
        registry.optIn(address(0x123)); // Alias not used here but needed
        vm.prank(validator2);
        registry.optIn(address(0x456));

        // Proposal 1: Only validator1 votes
        vm.prank(validator1);
        uint256 p1 = plugin.createProposal("p1", uint64(block.timestamp + 1), uint64(block.timestamp + 10), 100);
        vm.warp(block.timestamp + 2);
        vm.prank(validator1);
        plugin.castVote(p1, HarmonyVotingBase.VoteOption.Yes);
        
        // Finalize p1
        vm.warp(block.timestamp + 20);
        vm.roll(100);
        plugin.setMerkleRoot(p1, bytes32(uint256(1)), 1000); // 1000 total power
        plugin.oracleCloseProposal(p1);

        // Report participation for p1
        plugin.reportParticipationBatch(p1, 0, 10);
        
        assertEq(registry.missedVotes(validator1), 0);
        assertEq(registry.missedVotes(validator2), 1);

        // Proposal 2: Nobody votes
        vm.prank(validator1);
        uint256 p2 = plugin.createProposal("p2", uint64(block.timestamp + 1), uint64(block.timestamp + 10), 200);
        vm.warp(block.timestamp + 15);
        vm.roll(200);
        plugin.setMerkleRoot(p2, bytes32(uint256(2)), 1000);
        plugin.oracleCloseProposal(p2);
        
        // Report participation for p2
        plugin.reportParticipationBatch(p2, 0, 10);

        assertEq(registry.missedVotes(validator1), 1);
        // Validator 2 missed 2 consecutive -> should be opted out
        assertEq(registry.isValidator(validator2), false);
        assertEq(registry.operatorCount(), 1); // Only validator 1 left
    }

    function test_E2E_AllowlistEnforcement() public {
        // Disallow the DAO
        allowlist.disallowDAO(address(dao));
        
        vm.prank(validator1);
        registry.optIn(alias1);

        vm.expectRevert("DAO_NOT_ALLOWED");
        vm.prank(alias1);
        plugin.createProposal("metadata", uint64(block.timestamp + 1), uint64(block.timestamp + 1000), 100);
    }
}
