// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {TestBase} from "../lib/TestBase.sol";

import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {HarmonyHIPVotingPlugin} from "../../src/harmony/HarmonyHIPVotingPlugin.sol";
import {ProxyLib} from "@aragon/osx-commons-contracts/src/utils/deployment/ProxyLib.sol";

contract HarmonyVotingBuilder is TestBase {
    address immutable DAO_BASE = address(new DAO());
    address immutable HIP_PLUGIN_BASE = address(new HarmonyHIPVotingPlugin());

    address daoOwner;

    constructor() {
        daoOwner = msg.sender;
    }

    function withDaoOwner(address _newOwner) external returns (HarmonyVotingBuilder) {
        daoOwner = _newOwner;
        return this;
    }

    function build(
        address proposer,
        address oracle
    ) external returns (DAO dao, HarmonyHIPVotingPlugin plugin) {
        dao = DAO(
            payable(
                ProxyLib.deployUUPSProxy(
                    address(DAO_BASE),
                    abi.encodeCall(DAO.initialize, ("", daoOwner, address(0x0), ""))
                )
            )
        );

        plugin = HarmonyHIPVotingPlugin(
            ProxyLib.deployUUPSProxy(
                address(HIP_PLUGIN_BASE),
                abi.encodeCall(HarmonyHIPVotingPlugin.initialize, (dao))
            )
        );

        vm.startPrank(daoOwner);
        dao.grant(address(plugin), oracle, plugin.ORACLE_PERMISSION_ID());
        vm.stopPrank();

        vm.label(address(dao), "DAO");
        vm.label(address(plugin), "HarmonyHIPVotingPlugin");

        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 1);
    }
}
