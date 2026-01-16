// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {TestBase} from "./lib/TestBase.sol";

import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {ProxyLib} from "@aragon/osx-commons-contracts/src/utils/deployment/ProxyLib.sol";
import {HarmonyDelegationVotingPlugin} from "../src/harmony/HarmonyDelegationVotingPlugin.sol";

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
}
