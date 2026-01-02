// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.17;

import {HarmonyVotingBase} from "./HarmonyVotingBase.sol";

/// @notice Delegation (community) voting: delegators vote on validator intent; weights come from snapshot via Merkle root.
contract HarmonyDelegationVotingPlugin is HarmonyVotingBase {
    uint256[50] private __gap;
}
