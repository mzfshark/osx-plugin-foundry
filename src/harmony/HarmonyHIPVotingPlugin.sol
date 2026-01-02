// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.17;

import {HarmonyVotingBase} from "./HarmonyVotingBase.sol";

/// @notice HIP (protocol) voting: validators vote; weights come from a snapshot published via Merkle root.
contract HarmonyHIPVotingPlugin is HarmonyVotingBase {
    uint256[50] private __gap;
}
