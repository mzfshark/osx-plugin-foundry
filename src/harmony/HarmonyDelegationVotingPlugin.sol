// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.17;

import {HarmonyVotingBase} from "./HarmonyVotingBase.sol";
import {IDAO} from "@aragon/osx/core/dao/DAO.sol";

/// @notice Delegation (community) voting: delegators vote on validator intent; weights come from snapshot via Merkle root.
/// @dev This plugin allows delegators of a specific validator to participate in DAO governance.
contract HarmonyDelegationVotingPlugin is HarmonyVotingBase {
    /// @notice The permission identifier to update the validator address.
    bytes32 public constant UPDATE_VALIDATOR_PERMISSION_ID =
        keccak256("UPDATE_VALIDATOR_PERMISSION");

    /// @notice The validator address whose delegators can vote in this DAO.
    address public validatorAddress;

    /// @notice Emitted when the validator address is updated.
    /// @param oldAddress The previous validator address.
    /// @param newAddress The new validator address.
    event ValidatorAddressUpdated(address indexed oldAddress, address indexed newAddress);

    /// @notice Thrown when trying to set an invalid validator address.
    /// @param validator The invalid validator address provided.
    error InvalidValidatorAddress(address validator);

    /// @notice Initializes the plugin with the DAO and validator address.
    /// @param _dao The DAO contract.
    /// @param _validatorAddress The initial validator address whose delegators can vote.
    function initialize(IDAO _dao, address _validatorAddress) external initializer {
        __HarmonyVotingBase_init(_dao);
        _setValidatorAddress(_validatorAddress);
    }

    /// @notice Updates the validator address.
    /// @dev Only callable by addresses with UPDATE_VALIDATOR_PERMISSION.
    /// @param _newValidator The new validator address.
    function setValidatorAddress(address _newValidator) external auth(UPDATE_VALIDATOR_PERMISSION_ID) {
        _setValidatorAddress(_newValidator);
    }

    /// @notice Internal function to set the validator address.
    /// @param _newValidator The new validator address.
    function _setValidatorAddress(address _newValidator) internal {
        if (_newValidator == address(0)) {
            revert InvalidValidatorAddress(_newValidator);
        }
        address oldAddress = validatorAddress;
        validatorAddress = _newValidator;
        emit ValidatorAddressUpdated(oldAddress, _newValidator);
    }

    uint256[48] private __gap; // Reduced from 50 to account for validatorAddress storage
}
