// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.17;

import {HarmonyVotingBase} from "./HarmonyVotingBase.sol";
import {IDAO} from "@aragon/osx/core/dao/DAO.sol";

/// @notice Delegation (community) voting: delegators vote on validator intent; weights come from snapshot via Merkle root.
contract HarmonyDelegationVotingPlugin is HarmonyVotingBase {
    function initialize(IDAO _dao) external initializer {
        __HarmonyVotingBase_init(_dao);
    }

    uint256[50] private __gap;
}
