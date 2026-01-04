// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.17;

import {IPluginSetup, PluginSetup, PermissionLib} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessor.sol";
import {ProxyLib} from "@aragon/osx-commons-contracts/src/utils/deployment/ProxyLib.sol";
import {IDAO} from "@aragon/osx/core/dao/DAO.sol";

import {HarmonyDelegationVotingPlugin} from "../harmony/HarmonyDelegationVotingPlugin.sol";

contract HarmonyDelegationVotingSetup is PluginSetup {
    address public immutable ORACLE;

    constructor(address _oracle) PluginSetup(address(new HarmonyDelegationVotingPlugin())) {
        require(_oracle != address(0), "INVALID_ORACLE");
        ORACLE = _oracle;
    }

    function prepareInstallation(
        address _dao,
        bytes memory _installationParams
    ) external returns (address plugin, PreparedSetupData memory preparedSetupData) {
        require(_installationParams.length == 0, "INSTALL_PARAMS_NOT_SUPPORTED");

        plugin = ProxyLib.deployUUPSProxy(
            implementation(),
            abi.encodeCall(HarmonyDelegationVotingPlugin.initialize, (IDAO(_dao)))
        );

        PermissionLib.MultiTargetPermission[] memory permissions = new PermissionLib.MultiTargetPermission[](1);

        permissions[0] = PermissionLib.MultiTargetPermission({
            operation: PermissionLib.Operation.Grant,
            where: plugin,
            who: ORACLE,
            condition: PermissionLib.NO_CONDITION,
            permissionId: HarmonyDelegationVotingPlugin(implementation()).ORACLE_PERMISSION_ID()
        });

        preparedSetupData.permissions = permissions;
    }

    function prepareUninstallation(
        address /* _dao */,
        SetupPayload calldata _payload
    ) external view returns (PermissionLib.MultiTargetPermission[] memory permissions) {
        permissions = new PermissionLib.MultiTargetPermission[](1);

        permissions[0] = PermissionLib.MultiTargetPermission({
            operation: PermissionLib.Operation.Revoke,
            where: _payload.plugin,
            who: ORACLE,
            condition: PermissionLib.NO_CONDITION,
            permissionId: HarmonyDelegationVotingPlugin(implementation()).ORACLE_PERMISSION_ID()
        });
    }
}
