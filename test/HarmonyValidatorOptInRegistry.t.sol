// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {HarmonyValidatorOptInRegistry} from "../src/harmony/HarmonyValidatorOptInRegistry.sol";

contract MockSafe {
    address[] public owners;
    uint256 public threshold;

    constructor(address[] memory _owners, uint256 _threshold) {
        owners = _owners;
        threshold = _threshold;
    }

    function getOwners() external view returns (address[] memory) {
        return owners;
    }

    function getThreshold() external view returns (uint256) {
        return threshold;
    }
}

contract SimpleContract {}

contract HarmonyValidatorOptInRegistryTest is Test {
    HarmonyValidatorOptInRegistry public registry;
    address public operator1 = address(0x1);
    address public operator2 = address(0x2);
    address public alias1 = address(0x11);
    address public alias2 = address(0x22);

    function setUp() public {
        registry = new HarmonyValidatorOptInRegistry();
    }

    function test_OptIn_EOA() public {
        vm.prank(operator1);
        registry.optIn(alias1);

        assertTrue(registry.isOptedIn(operator1));
        (address votingAddr, bool optedIn) = registry.votingAddressOf(operator1);
        assertEq(votingAddr, alias1);
        assertTrue(optedIn);
        assertEq(registry.operatorByAlias(alias1), operator1);
    }

    function test_OptIn_Multisig() public {
        address[] memory owners = new address[](2);
        owners[0] = address(0xA);
        owners[1] = address(0xB);
        MockSafe safe = new MockSafe(owners, 1);
        address aliasSafe = address(safe);

        vm.prank(operator1);
        registry.optIn(aliasSafe);

        assertEq(registry.operatorByAlias(aliasSafe), operator1);
    }

    function test_OptIn_Contract_Reverts() public {
        SimpleContract sc = new SimpleContract();
        address aliasContract = address(sc);

        vm.prank(operator1);
        vm.expectRevert("VOTING_ADDRESS_NOT_ALLOWED");
        registry.optIn(aliasContract);
    }

    function test_OptIn_AliasInUse_Reverts() public {
        vm.prank(operator1);
        registry.optIn(alias1);

        vm.prank(operator2);
        vm.expectRevert("ALIAS_IN_USE");
        registry.optIn(alias1);
    }

    function test_OptIn_ReOptIn_CleansOldAlias() public {
        vm.prank(operator1);
        registry.optIn(alias1);
        assertEq(registry.operatorByAlias(alias1), operator1);

        vm.prank(operator1);
        registry.optIn(alias2);
        
        assertEq(registry.operatorByAlias(alias2), operator1);
        assertEq(registry.operatorByAlias(alias1), address(0));
        assertFalse(registry.isAlias(alias1));
    }

    function test_OptOut_CleansAll() public {
        vm.prank(operator1);
        registry.optIn(alias1);
        assertTrue(registry.isAlias(alias1));

        vm.prank(operator1);
        registry.optOut();

        assertFalse(registry.isOptedIn(operator1));
        assertEq(registry.operatorByAlias(alias1), address(0));
        assertEq(registry.operatorCount(), 0);
    }

    function test_Enumeration() public {
        vm.prank(operator1);
        registry.optIn(alias1);
        vm.prank(operator2);
        registry.optIn(alias2);

        assertEq(registry.operatorCount(), 2);
        assertEq(registry.operatorAt(0), operator1);
        assertEq(registry.operatorAt(1), operator2);

        address[] memory ops = registry.getOperators();
        assertEq(ops.length, 2);
        assertEq(ops[0], operator1);
        assertEq(ops[1], operator2);
    }

    function test_ReverseLookup() public {
        vm.prank(operator1);
        registry.optIn(alias1);

        assertTrue(registry.isAlias(alias1));
        assertFalse(registry.isAlias(operator1));
        assertEq(registry.operatorByAlias(alias1), operator1);
        assertEq(registry.operatorByAlias(alias2), address(0));
    }
}
