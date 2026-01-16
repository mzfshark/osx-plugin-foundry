// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.17;

/// @notice Global opt-in registry for Harmony validators.
/// @dev Minimal registry to support an opted-in set and optional alias (voting) address.
contract HarmonyValidatorOptInRegistry {
    struct OptInStatus {
        bool optedIn;
        address votingAddress;
    }

    mapping(address => OptInStatus) private _statusByOperator;

    event OptedIn(address indexed operator, address indexed votingAddress);
    event OptedOut(address indexed operator);

    function optIn(address votingAddress) external {
        require(votingAddress != address(0), "INVALID_VOTING_ADDRESS");
        _statusByOperator[msg.sender] = OptInStatus({optedIn: true, votingAddress: votingAddress});
        emit OptedIn(msg.sender, votingAddress);
    }

    function optOut() external {
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
}
