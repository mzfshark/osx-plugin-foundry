// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.17;

import {DAO, IDAO} from "@aragon/osx/core/dao/DAO.sol";
import {IPluginSetup, PluginSetup, PermissionLib} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessor.sol";
import {ProxyLib} from "@aragon/osx-commons-contracts/src/utils/deployment/ProxyLib.sol";

import {HarmonyHIPVotingPlugin} from "../harmony/HarmonyHIPVotingPlugin.sol";

contract HarmonyHIPVotingSetup is PluginSetup {
    constructor() PluginSetup(address(new HarmonyHIPVotingPlugin())) {}

    function prepareInstallation(
        address _dao,
        bytes memory _installationParams
    ) external returns (address plugin, PreparedSetupData memory preparedSetupData) {
        (address proposer, address oracle) = abi.decode(_installationParams, (address, address));

        plugin = ProxyLib.deployUUPSProxy(
            implementation(),
            abi.encodeCall(HarmonyHIPVotingPlugin.initialize, (IDAO(_dao)))
        );

        PermissionLib.MultiTargetPermission[] memory permissions = new PermissionLib.MultiTargetPermission[](2);

        permissions[0] = PermissionLib.MultiTargetPermission({
            operation: PermissionLib.Operation.Grant,
            where: plugin,
            who: proposer,
            condition: PermissionLib.NO_CONDITION,
            permissionId: HarmonyHIPVotingPlugin(implementation()).PROPOSER_PERMISSION_ID()
        });

        permissions[1] = PermissionLib.MultiTargetPermission({
            operation: PermissionLib.Operation.Grant,
            where: plugin,
            who: oracle,
            condition: PermissionLib.NO_CONDITION,
            permissionId: HarmonyHIPVotingPlugin(implementation()).ORACLE_PERMISSION_ID()
        });

        preparedSetupData.permissions = permissions;
    }

    function prepareUninstallation(
        address _dao,
        SetupPayload calldata _payload
    ) external view returns (PermissionLib.MultiTargetPermission[] memory permissions) {
        (address proposer, address oracle) = abi.decode(_payload.data, (address, address));

        permissions = new PermissionLib.MultiTargetPermission[](2);

        permissions[0] = PermissionLib.MultiTargetPermission({
            operation: PermissionLib.Operation.Revoke,
            where: _payload.plugin,
            who: proposer,
            condition: PermissionLib.NO_CONDITION,
            permissionId: HarmonyHIPVotingPlugin(implementation()).PROPOSER_PERMISSION_ID()
        });

        permissions[1] = PermissionLib.MultiTargetPermission({
            operation: PermissionLib.Operation.Revoke,
            where: _payload.plugin,
            who: oracle,
            condition: PermissionLib.NO_CONDITION,
            permissionId: HarmonyHIPVotingPlugin(implementation()).ORACLE_PERMISSION_ID()
        });
    }
}
