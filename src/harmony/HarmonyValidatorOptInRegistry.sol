// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.17;

import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

/// @notice Global opt-in registry for Harmony validators.
/// @dev Minimal registry to support an opted-in set and optional alias (voting) address.
contract HarmonyValidatorOptInRegistry {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct OptInStatus {
        bool optedIn;
        address votingAddress;
    }

    EnumerableSet.AddressSet private _operators;
    mapping(address => address) private _operatorByAlias;
    mapping(address => OptInStatus) private _statusByOperator;

    event OptedIn(address indexed operator, address indexed votingAddress);
    event OptedOut(address indexed operator);

    function optIn(address votingAddress) external {
        require(votingAddress != address(0), "INVALID_VOTING_ADDRESS");
        require(_isAllowedVotingAddress(votingAddress), "VOTING_ADDRESS_NOT_ALLOWED");
        address existingOperator = _operatorByAlias[votingAddress];
        require(existingOperator == address(0) || existingOperator == msg.sender, "ALIAS_IN_USE");

        OptInStatus memory current = _statusByOperator[msg.sender];
        if (current.optedIn && current.votingAddress != address(0)) {
            delete _operatorByAlias[current.votingAddress];
        }

        _operatorByAlias[votingAddress] = msg.sender;
        _statusByOperator[msg.sender] = OptInStatus({optedIn: true, votingAddress: votingAddress});
        _operators.add(msg.sender);
        emit OptedIn(msg.sender, votingAddress);
    }

    function optOut() external {
        OptInStatus memory current = _statusByOperator[msg.sender];
        if (current.votingAddress != address(0)) {
            delete _operatorByAlias[current.votingAddress];
        }
        _operators.remove(msg.sender);
        delete _statusByOperator[msg.sender];
        emit OptedOut(msg.sender);
    }

    function isOptedIn(address operator) external view returns (bool) {
        return _statusByOperator[operator].optedIn;
    }

    function votingAddressOf(address operator) external view returns (address votingAddress, bool optedIn) {
        OptInStatus memory s = _statusByOperator[operator];
        return (s.votingAddress, s.optedIn);
    }

    function operatorByAlias(address _alias) external view returns (address operator) {
        return _operatorByAlias[_alias];
    }

    function isAlias(address _alias) external view returns (bool) {
        return _operatorByAlias[_alias] != address(0);
    }

    function operatorCount() external view returns (uint256) {
        return _operators.length();
    }

    function operatorAt(uint256 index) external view returns (address) {
        return _operators.at(index);
    }

    function getOperators() external view returns (address[] memory) {
        return _operators.values();
    }

    function _isAllowedVotingAddress(address votingAddress) internal view returns (bool) {
        if (votingAddress.code.length == 0) {
            return true;
        }

        // Allow Gnosis Safe-style multisig by probing common view methods.
        (bool ownersOk, bytes memory ownersData) = votingAddress.staticcall(
            abi.encodeWithSignature("getOwners()")
        );
        if (!ownersOk) {
            return false;
        }

        (bool thresholdOk, bytes memory thresholdData) = votingAddress.staticcall(
            abi.encodeWithSignature("getThreshold()")
        );
        if (!thresholdOk) {
            return false;
        }

        address[] memory owners = abi.decode(ownersData, (address[]));
        uint256 threshold = abi.decode(thresholdData, (uint256));
        return owners.length > 0 && threshold > 0 && threshold <= owners.length;
    }
}
