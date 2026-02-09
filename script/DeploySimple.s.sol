// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script, console2} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {PluginRepoFactory} from "@aragon/osx/framework/plugin/repo/PluginRepoFactory.sol";
import {PluginRepo} from "@aragon/osx/framework/plugin/repo/PluginRepo.sol";
import {hashHelpers, PluginSetupRef} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessorHelpers.sol";
import {PermissionLib} from "@aragon/osx-commons-contracts/src/permission/PermissionLib.sol";
import {ProxyLib} from "@aragon/osx-commons-contracts/src/utils/deployment/ProxyLib.sol";
import {MyPluginSetup} from "../src/setup/MyPluginSetup.sol";

/**
 * This script performs the following tasks:
 * - Deploys a new PluginRepo for each available plugin
 * - Publishes a new version of each plugin (release 1, build 1)
 */
contract DeploySimpleScript is Script {
    using stdJson for string;

    address deployer;
    PluginRepoFactory pluginRepoFactory;
    string pluginEnsSubdomain;
    address pluginRepoMaintainerAddress;
    bool skipEnsRegistry;

    // Artifacts
    PluginRepo myPluginRepo;
    MyPluginSetup myPluginSetup;

    modifier broadcast() {
        uint256 privKey = vm.envUint("DEPLOYMENT_PRIVATE_KEY");
        vm.startBroadcast(privKey);

        deployer = vm.addr(privKey);
        console2.log("General");
        console2.log("- Deploying from:   ", deployer);
        console2.log("- Chain ID:         ", block.chainid);
        console2.log("");

        _;

        vm.stopBroadcast();
    }

    function setUp() public {
        // Pick the contract addresses from
        // https://github.com/aragon/osx/blob/main/packages/artifacts/src/addresses.json

        // Prepare the OSx factories for the current network
        pluginRepoFactory = PluginRepoFactory(vm.envAddress("PLUGIN_REPO_FACTORY_ADDRESS"));
        vm.label(address(pluginRepoFactory), "PluginRepoFactory");

        // Read the rest of environment variables
        pluginEnsSubdomain = vm.envOr("PLUGIN_ENS_SUBDOMAIN", string(""));

        // Using a random subdomain if empty
        if (bytes(pluginEnsSubdomain).length == 0) {
            pluginEnsSubdomain = string.concat("my-test-plugin-", vm.toString(block.timestamp));
        }

        pluginRepoMaintainerAddress = vm.envAddress("PLUGIN_REPO_MAINTAINER_ADDRESS");
        vm.label(pluginRepoMaintainerAddress, "Maintainer");

        // Optionally skip ENS registry flow (useful for networks without ENS like Harmony)
        skipEnsRegistry = vm.envOr("SKIP_ENS_REGISTRY", false);
    }

    function run() public broadcast {
        // Publish the first version in a new plugin repo
        deployPluginRepo();

        // Done
        printDeployment();

        // Write the addresses to a JSON file
        if (!vm.envOr("SIMULATION", false)) {
            writeJsonArtifacts();
        }
    }

    function deployPluginRepo() public {
        // Plugin setup (the installer)
        myPluginSetup = new MyPluginSetup();

        // The new plugin repository
        // Try the normal factory path first; if it reverts (e.g. ENS not supported on this network),
        // fall back to a Harmony-safe direct repo deployment and publish the version manually.
        try pluginRepoFactory.createPluginRepoWithFirstVersion(
            pluginEnsSubdomain,
            address(myPluginSetup),
            pluginRepoMaintainerAddress,
            " ",
            " "
        ) returns (PluginRepo repo) {
            myPluginRepo = repo;
        } catch {
            // If configured to skip ENS registry, use the direct deploy path.
            if (skipEnsRegistry) {
                myPluginRepo = _deployRepoDirect();
                return;
            }

            // The new plugin repository
            // Try the normal factory path first; if it reverts (e.g. ENS not supported on this network),
            // fall back to a Harmony-safe direct repo deployment and publish the version manually.
            try pluginRepoFactory.createPluginRepoWithFirstVersion(
                pluginEnsSubdomain,
                address(myPluginSetup),
                pluginRepoMaintainerAddress,
                " ",
                " "
            ) returns (PluginRepo repo) {
                myPluginRepo = repo;
            } catch {
                myPluginRepo = _deployRepoDirect();
            }
        }
    }

    /// @dev Direct deploy path: deploys PluginRepo proxy and publishes version without using registry.
    function _deployRepoDirect() internal returns (PluginRepo) {
        address pluginRepoBase = pluginRepoFactory.pluginRepoBase();
        PluginRepo pluginRepoInstance = PluginRepo(
            ProxyLib.deployUUPSProxy(pluginRepoBase, abi.encodeCall(PluginRepo.initialize, (deployer)))
        );

        // Publish first version 1
        pluginRepoInstance.createVersion(1, address(myPluginSetup), " ", " ");

        // If maintainer differs from deployer, replicate factory's final permissions.
        if (pluginRepoMaintainerAddress != deployer) {
            PermissionLib.SingleTargetPermission[] memory items = new PermissionLib.SingleTargetPermission[](6);

            bytes32 rootPermissionID = pluginRepoInstance.ROOT_PERMISSION_ID();
            bytes32 maintainerPermissionID = pluginRepoInstance.MAINTAINER_PERMISSION_ID();
            bytes32 upgradePermissionID = pluginRepoInstance.UPGRADE_REPO_PERMISSION_ID();

            items[0] = PermissionLib.SingleTargetPermission(PermissionLib.Operation.Grant, pluginRepoMaintainerAddress, maintainerPermissionID);
            items[1] = PermissionLib.SingleTargetPermission(PermissionLib.Operation.Grant, pluginRepoMaintainerAddress, upgradePermissionID);
            items[2] = PermissionLib.SingleTargetPermission(PermissionLib.Operation.Grant, pluginRepoMaintainerAddress, rootPermissionID);

            items[3] = PermissionLib.SingleTargetPermission(PermissionLib.Operation.Revoke, deployer, rootPermissionID);
            items[4] = PermissionLib.SingleTargetPermission(PermissionLib.Operation.Revoke, deployer, maintainerPermissionID);
            items[5] = PermissionLib.SingleTargetPermission(PermissionLib.Operation.Revoke, deployer, upgradePermissionID);

            pluginRepoInstance.applySingleTargetPermissions(address(pluginRepoInstance), items);
        }

        return pluginRepoInstance;
    }
    function printDeployment() public view {
        console2.log("MyUpgradeablePlugin:");
        console2.log("- Plugin repo:               ", address(myPluginRepo));
        console2.log("- Plugin repo maintainer:    ", pluginRepoMaintainerAddress);
        console2.log("- ENS:                       ", string.concat(pluginEnsSubdomain, ".plugin.dao.eth"));
        console2.log("");
    }

    function writeJsonArtifacts() internal {
        string memory artifacts = "output";
        artifacts.serialize("pluginRepo", address(myPluginRepo));
        artifacts.serialize("pluginRepoMaintainer", pluginRepoMaintainerAddress);
        artifacts = artifacts.serialize("pluginEnsDomain", string.concat(pluginEnsSubdomain, ".plugin.dao.eth"));

        string memory networkName = vm.envString("NETWORK_NAME");
        string memory filePath = string.concat(
            vm.projectRoot(), "/artifacts/deployment-", networkName, "-", vm.toString(block.timestamp), ".json"
        );
        artifacts.write(filePath);

        console2.log("Deployment artifacts written to", filePath);
    }
}
