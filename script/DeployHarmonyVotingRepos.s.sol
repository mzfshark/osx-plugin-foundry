// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script, console2} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";

import {PluginRepoFactory} from "@aragon/osx/framework/plugin/repo/PluginRepoFactory.sol";
import {PluginRepo} from "@aragon/osx/framework/plugin/repo/PluginRepo.sol";

import {HarmonyHIPVotingSetup} from "../src/setup/HarmonyHIPVotingSetup.sol";
import {HarmonyDelegationVotingSetup} from "../src/setup/HarmonyDelegationVotingSetup.sol";
import {HarmonyValidatorOptInRegistry} from "../src/harmony/HarmonyValidatorOptInRegistry.sol";

/**
 * Deploys Harmony HIP + Delegation voting plugin repos, plus the opt-in registry.
 *
 * Env vars expected:
 * - DEPLOYMENT_PRIVATE_KEY
 * - PLUGIN_REPO_FACTORY_ADDRESS
 * - PLUGIN_REPO_MAINTAINER_ADDRESS
 * - ORACLE_ADDRESS
 * - HIP_PLUGIN_ENS_SUBDOMAIN (optional)
 * - DELEGATION_PLUGIN_ENS_SUBDOMAIN (optional)
 * - NETWORK_NAME (used for artifacts filename)
 */
contract DeployHarmonyVotingReposScript is Script {
    using stdJson for string;

    address deployer;
    PluginRepoFactory pluginRepoFactory;
    address pluginRepoMaintainerAddress;
    address oracleAddress;

    string hipEnsSubdomain;
    string delegationEnsSubdomain;

    // Artifacts
    HarmonyHIPVotingSetup hipSetup;
    HarmonyDelegationVotingSetup delegationSetup;
    PluginRepo hipRepo;
    PluginRepo delegationRepo;
    HarmonyValidatorOptInRegistry optInRegistry;

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
        pluginRepoFactory = PluginRepoFactory(vm.envAddress("PLUGIN_REPO_FACTORY_ADDRESS"));
        vm.label(address(pluginRepoFactory), "PluginRepoFactory");

        // Maintainer can be left empty in .env; default it to deployer at runtime.
        pluginRepoMaintainerAddress = vm.envOr("PLUGIN_REPO_MAINTAINER_ADDRESS", address(0));

        oracleAddress = vm.envAddress("ORACLE_ADDRESS");
        vm.label(oracleAddress, "Oracle");

        hipEnsSubdomain = vm.envOr("HIP_PLUGIN_ENS_SUBDOMAIN", string(""));
        delegationEnsSubdomain = vm.envOr("DELEGATION_PLUGIN_ENS_SUBDOMAIN", string(""));

        if (bytes(hipEnsSubdomain).length == 0) {
            hipEnsSubdomain = string.concat("harmony-hip-voting-", vm.toString(block.timestamp));
        }

        if (bytes(delegationEnsSubdomain).length == 0) {
            delegationEnsSubdomain = string.concat("harmony-delegation-voting-", vm.toString(block.timestamp));
        }
    }

    function run() public broadcast {
        if (pluginRepoMaintainerAddress == address(0)) {
            pluginRepoMaintainerAddress = deployer;
        }
        vm.label(pluginRepoMaintainerAddress, "Maintainer");

        deployAll();
        printDeployment();

        if (!vm.envOr("SIMULATION", false)) {
            writeJsonArtifacts();
        }
    }

    function deployAll() internal {
        hipSetup = new HarmonyHIPVotingSetup(oracleAddress);
        delegationSetup = new HarmonyDelegationVotingSetup(oracleAddress);

        hipRepo = pluginRepoFactory.createPluginRepoWithFirstVersion(
            hipEnsSubdomain, address(hipSetup), pluginRepoMaintainerAddress, " ", " "
        );

        delegationRepo = pluginRepoFactory.createPluginRepoWithFirstVersion(
            delegationEnsSubdomain, address(delegationSetup), pluginRepoMaintainerAddress, " ", " "
        );

        optInRegistry = new HarmonyValidatorOptInRegistry();
    }

    function printDeployment() public view {
        console2.log("Harmony HIP Voting:");
        console2.log("- Setup:                    ", address(hipSetup));
        console2.log("- Repo:                     ", address(hipRepo));
        console2.log("- ENS:                      ", string.concat(hipEnsSubdomain, ".plugin.dao.eth"));
        console2.log("");

        console2.log("Harmony Delegation Voting:");
        console2.log("- Setup:                    ", address(delegationSetup));
        console2.log("- Repo:                     ", address(delegationRepo));
        console2.log("- ENS:                      ", string.concat(delegationEnsSubdomain, ".plugin.dao.eth"));
        console2.log("");

        console2.log("Harmony Opt-In Registry:");
        console2.log("- Registry:                 ", address(optInRegistry));
        console2.log("");
    }

    function writeJsonArtifacts() internal {
        string memory artifacts = "output";

        artifacts.serialize("oracle", oracleAddress);
        artifacts.serialize("pluginRepoMaintainer", pluginRepoMaintainerAddress);

        artifacts.serialize("hipSetup", address(hipSetup));
        artifacts.serialize("hipRepo", address(hipRepo));
        artifacts.serialize("hipEnsDomain", string.concat(hipEnsSubdomain, ".plugin.dao.eth"));

        artifacts.serialize("delegationSetup", address(delegationSetup));
        artifacts.serialize("delegationRepo", address(delegationRepo));
        artifacts.serialize("delegationEnsDomain", string.concat(delegationEnsSubdomain, ".plugin.dao.eth"));

        artifacts.serialize("optInRegistry", address(optInRegistry));

        string memory networkName = vm.envString("NETWORK_NAME");
        string memory filePath = string.concat(
            vm.projectRoot(), "/artifacts/deployment-harmony-voting-", networkName, "-", vm.toString(block.timestamp), ".json"
        );
        artifacts.write(filePath);

        console2.log("Deployment artifacts written to", filePath);
    }
}
