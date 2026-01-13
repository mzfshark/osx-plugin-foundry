// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.4 ^0.8.0 ^0.8.1 ^0.8.17 ^0.8.2 ^0.8.4 ^0.8.8;

// lib/openzeppelin-contracts-upgradeable/contracts/utils/AddressUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     *
     * Furthermore, `isContract` will also return true if the target contract within
     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
     * which only has an effect at the end of a transaction.
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// lib/osx-commons/contracts/src/utils/math/BitMap.sol

/// @param bitmap The `uint256` representation of bits.
/// @param index The index number to check whether 1 or 0 is set.
/// @return Returns `true` if the bit is set at `index` on `bitmap`.
/// @custom:security-contact sirt@aragon.org
function hasBit(uint256 bitmap, uint8 index) pure returns (bool) {
    uint256 bitValue = bitmap & (1 << index);
    return bitValue > 0;
}

/// @param bitmap The `uint256` representation of bits.
/// @param index The index number to set the bit.
/// @return Returns a new number in which the bit is set at `index`.
/// @custom:security-contact sirt@aragon.org
function flipBit(uint256 bitmap, uint8 index) pure returns (uint256) {
    return bitmap ^ (1 << index);
}

// lib/osx/packages/contracts/src/core/utils/CallbackHandler.sol

/// @title CallbackHandler
/// @author Aragon X - 2022-2023
/// @notice This contract handles callbacks by registering a magic number together with the callback function's selector. It provides the `_handleCallback` function that inheriting contracts have to call inside their `fallback()` function  (`_handleCallback(msg.callbackSelector, msg.data)`).  This allows to adaptively register ERC standards (e.g., [ERC-721](https://eips.ethereum.org/EIPS/eip-721), [ERC-1115](https://eips.ethereum.org/EIPS/eip-1155), or future versions of [ERC-165](https://eips.ethereum.org/EIPS/eip-165)) and returning the required magic numbers for the associated callback functions for the inheriting contract so that it doesn't need to be upgraded.
/// @dev This callback handling functionality is intended to be used by executor contracts (i.e., `DAO.sol`).
/// @custom:security-contact sirt@aragon.org
abstract contract CallbackHandler {
    /// @notice A mapping between callback function selectors and magic return numbers.
    mapping(bytes4 => bytes4) internal callbackMagicNumbers;

    /// @notice The magic number refering to unregistered callbacks.
    bytes4 internal constant UNREGISTERED_CALLBACK = bytes4(0);

    /// @notice Thrown if the callback function is not registered.
    /// @param callbackSelector The selector of the callback function.
    /// @param magicNumber The magic number to be registered for the callback function selector.
    error UnknownCallback(bytes4 callbackSelector, bytes4 magicNumber);

    /// @notice Emitted when `_handleCallback` is called.
    /// @param sender Who called the callback.
    /// @param sig The function signature.
    /// @param data The calldata.
    event CallbackReceived(address sender, bytes4 indexed sig, bytes data);

    /// @notice Handles callbacks to adaptively support ERC standards.
    /// @dev This function is supposed to be called via `_handleCallback(msg.sig, msg.data)` in the `fallback()` function of the inheriting contract.
    /// @param _callbackSelector The function selector of the callback function.
    /// @param _data The calldata.
    /// @return The magic number registered for the function selector triggering the fallback.
    function _handleCallback(
        bytes4 _callbackSelector,
        bytes memory _data
    ) internal virtual returns (bytes4) {
        bytes4 magicNumber = callbackMagicNumbers[_callbackSelector];
        if (magicNumber == UNREGISTERED_CALLBACK) {
            revert UnknownCallback({callbackSelector: _callbackSelector, magicNumber: magicNumber});
        }

        emit CallbackReceived({sender: msg.sender, sig: _callbackSelector, data: _data});

        return magicNumber;
    }

    /// @notice Registers a magic number for a callback function selector.
    /// @param _callbackSelector The selector of the callback function.
    /// @param _magicNumber The magic number to be registered for the callback function selector.
    function _registerCallback(bytes4 _callbackSelector, bytes4 _magicNumber) internal virtual {
        callbackMagicNumbers[_callbackSelector] = _magicNumber;
    }

    /// @notice This empty reserved space is put in place to allow future versions to add new variables without shifting down storage in the inheritance chain (see [OpenZeppelin's guide about storage gaps](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps)).
    uint256[49] private __gap;
}

// lib/ens-contracts/contracts/registry/ENS.sol

interface ENS {
    // Logged when the owner of a node assigns a new owner to a subnode.
    event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);

    // Logged when the owner of a node transfers ownership to a new account.
    event Transfer(bytes32 indexed node, address owner);

    // Logged when the resolver for a node changes.
    event NewResolver(bytes32 indexed node, address resolver);

    // Logged when the TTL of a node changes
    event NewTTL(bytes32 indexed node, uint64 ttl);

    // Logged when an operator is added or removed.
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    function setRecord(
        bytes32 node,
        address owner,
        address resolver,
        uint64 ttl
    ) external;

    function setSubnodeRecord(
        bytes32 node,
        bytes32 label,
        address owner,
        address resolver,
        uint64 ttl
    ) external;

    function setSubnodeOwner(
        bytes32 node,
        bytes32 label,
        address owner
    ) external returns (bytes32);

    function setResolver(bytes32 node, address resolver) external;

    function setOwner(bytes32 node, address owner) external;

    function setTTL(bytes32 node, uint64 ttl) external;

    function setApprovalForAll(address operator, bool approved) external;

    function owner(bytes32 node) external view returns (address);

    function resolver(bytes32 node) external view returns (address);

    function ttl(bytes32 node) external view returns (uint64);

    function recordExists(bytes32 node) external view returns (bool);

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);
}

// lib/ens-contracts/contracts/resolvers/profiles/IABIResolver.sol

interface IABIResolver {
    event ABIChanged(bytes32 indexed node, uint256 indexed contentType);

    /**
     * Returns the ABI associated with an ENS node.
     * Defined in EIP205.
     * @param node The ENS node to query
     * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
     * @return contentType The content type of the return value
     * @return data The ABI data
     */
    function ABI(
        bytes32 node,
        uint256 contentTypes
    ) external view returns (uint256, bytes memory);
}

// lib/ens-contracts/contracts/resolvers/profiles/IAddrResolver.sol

/**
 * Interface for the legacy (ETH-only) addr function.
 */
interface IAddrResolver {
    event AddrChanged(bytes32 indexed node, address a);

    /**
     * Returns the address associated with an ENS node.
     * @param node The ENS node to query.
     * @return The associated address.
     */
    function addr(bytes32 node) external view returns (address payable);
}

// lib/ens-contracts/contracts/resolvers/profiles/IAddressResolver.sol

/**
 * Interface for the new (multicoin) addr function.
 */
interface IAddressResolver {
    event AddressChanged(
        bytes32 indexed node,
        uint256 coinType,
        bytes newAddress
    );

    function addr(
        bytes32 node,
        uint256 coinType
    ) external view returns (bytes memory);
}

// lib/openzeppelin-contracts-upgradeable/contracts/proxy/beacon/IBeaconUpgradeable.sol

// OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)

/**
 * @dev This is the interface that {BeaconProxy} expects of its beacon.
 */
interface IBeaconUpgradeable {
    /**
     * @dev Must return an address that can be used as a delegate call target.
     *
     * {BeaconProxy} will check that this address is a contract.
     */
    function implementation() external view returns (address);
}

// lib/ens-contracts/contracts/resolvers/profiles/IContentHashResolver.sol

interface IContentHashResolver {
    event ContenthashChanged(bytes32 indexed node, bytes hash);

    /**
     * Returns the contenthash associated with an ENS node.
     * @param node The ENS node to query.
     * @return The associated contenthash.
     */
    function contenthash(bytes32 node) external view returns (bytes memory);
}

// lib/osx-commons/contracts/src/dao/IDAO.sol

/// @title IDAO
/// @author Aragon X - 2022-2024
/// @notice The interface required for DAOs within the Aragon App DAO framework.
/// @custom:security-contact sirt@aragon.org
interface IDAO {
    /// @notice Checks if an address has permission on a contract via a permission identifier and considers if `ANY_ADDRESS` was used in the granting process.
    /// @param _where The address of the contract.
    /// @param _who The address of a EOA or contract to give the permissions.
    /// @param _permissionId The permission identifier.
    /// @param _data The optional data passed to the `PermissionCondition` registered.
    /// @return Returns true if the address has permission, false if not.
    function hasPermission(
        address _where,
        address _who,
        bytes32 _permissionId,
        bytes memory _data
    ) external view returns (bool);

    /// @notice Updates the DAO metadata (e.g., an IPFS hash).
    /// @param _metadata The IPFS hash of the new metadata object.
    function setMetadata(bytes calldata _metadata) external;

    /// @notice Emitted when the DAO metadata is updated.
    /// @param metadata The IPFS hash of the new metadata object.
    event MetadataSet(bytes metadata);

    /// @notice Emitted when a standard callback is registered.
    /// @param interfaceId The ID of the interface.
    /// @param callbackSelector The selector of the callback function.
    /// @param magicNumber The magic number to be registered for the callback function selector.
    event StandardCallbackRegistered(
        bytes4 interfaceId,
        bytes4 callbackSelector,
        bytes4 magicNumber
    );

    /// @notice Deposits (native) tokens to the DAO contract with a reference string.
    /// @param _token The address of the token or address(0) in case of the native token.
    /// @param _amount The amount of tokens to deposit.
    /// @param _reference The reference describing the deposit reason.
    function deposit(address _token, uint256 _amount, string calldata _reference) external payable;

    /// @notice Emitted when a token deposit has been made to the DAO.
    /// @param sender The address of the sender.
    /// @param token The address of the deposited token.
    /// @param amount The amount of tokens deposited.
    /// @param _reference The reference describing the deposit reason.
    event Deposited(
        address indexed sender,
        address indexed token,
        uint256 amount,
        string _reference
    );

    /// @notice Emitted when a native token deposit has been made to the DAO.
    /// @dev This event is intended to be emitted in the `receive` function and is therefore bound by the gas limitations for `send`/`transfer` calls introduced by [ERC-2929](https://eips.ethereum.org/EIPS/eip-2929).
    /// @param sender The address of the sender.
    /// @param amount The amount of native tokens deposited.
    event NativeTokenDeposited(address sender, uint256 amount);

    /// @notice Setter for the trusted forwarder verifying the meta transaction.
    /// @param _trustedForwarder The trusted forwarder address.
    function setTrustedForwarder(address _trustedForwarder) external;

    /// @notice Getter for the trusted forwarder verifying the meta transaction.
    /// @return The trusted forwarder address.
    function getTrustedForwarder() external view returns (address);

    /// @notice Emitted when a new TrustedForwarder is set on the DAO.
    /// @param forwarder the new forwarder address.
    event TrustedForwarderSet(address forwarder);

    /// @notice Checks whether a signature is valid for a provided hash according to [ERC-1271](https://eips.ethereum.org/EIPS/eip-1271).
    /// @param _hash The hash of the data to be signed.
    /// @param _signature The signature byte array associated with `_hash`.
    /// @return Returns the `bytes4` magic value `0x1626ba7e` if the signature is valid and `0xffffffff` if not.
    function isValidSignature(bytes32 _hash, bytes memory _signature) external returns (bytes4);

    /// @notice Registers an ERC standard having a callback by registering its [ERC-165](https://eips.ethereum.org/EIPS/eip-165) interface ID and callback function signature.
    /// @param _interfaceId The ID of the interface.
    /// @param _callbackSelector The selector of the callback function.
    /// @param _magicNumber The magic number to be registered for the function signature.
    function registerStandardCallback(
        bytes4 _interfaceId,
        bytes4 _callbackSelector,
        bytes4 _magicNumber
    ) external;

    /// @notice Removed function being left here to not corrupt the IDAO interface ID. Any call will revert.
    /// @dev Introduced in v1.0.0. Removed in v1.4.0.
    function setSignatureValidator(address) external;
}

// lib/ens-contracts/contracts/resolvers/profiles/IDNSRecordResolver.sol

interface IDNSRecordResolver {
    // DNSRecordChanged is emitted whenever a given node/name/resource's RRSET is updated.
    event DNSRecordChanged(
        bytes32 indexed node,
        bytes name,
        uint16 resource,
        bytes record
    );
    // DNSRecordDeleted is emitted whenever a given node/name/resource's RRSET is deleted.
    event DNSRecordDeleted(bytes32 indexed node, bytes name, uint16 resource);

    /**
     * Obtain a DNS record.
     * @param node the namehash of the node for which to fetch the record
     * @param name the keccak-256 hash of the fully-qualified name for which to fetch the record
     * @param resource the ID of the resource as per https://en.wikipedia.org/wiki/List_of_DNS_record_types
     * @return the DNS record in wire format if present, otherwise empty
     */
    function dnsRecord(
        bytes32 node,
        bytes32 name,
        uint16 resource
    ) external view returns (bytes memory);
}

// lib/ens-contracts/contracts/resolvers/profiles/IDNSZoneResolver.sol

interface IDNSZoneResolver {
    // DNSZonehashChanged is emitted whenever a given node's zone hash is updated.
    event DNSZonehashChanged(
        bytes32 indexed node,
        bytes lastzonehash,
        bytes zonehash
    );

    /**
     * zonehash obtains the hash for the zone.
     * @param node The ENS node to query.
     * @return The associated contenthash.
     */
    function zonehash(bytes32 node) external view returns (bytes memory);
}

// lib/osx/packages/contracts/src/core/dao/IEIP4824.sol

/// @title EIP-4824 Common Interfaces for DAOs
/// @dev See https://eips.ethereum.org/EIPS/eip-4824
/// @author Aragon X - 2021-2023
/// @custom:security-contact sirt@aragon.org
interface IEIP4824 {
    /// @notice A distinct Uniform Resource Identifier (URI) pointing to a JSON object following the "EIP-4824 DAO JSON-LD Schema". This JSON file splits into four URIs: membersURI, proposalsURI, activityLogURI, and governanceURI. The membersURI should point to a JSON file that conforms to the "EIP-4824 Members JSON-LD Schema". The proposalsURI should point to a JSON file that conforms to the "EIP-4824 Proposals JSON-LD Schema". The activityLogURI should point to a JSON file that conforms to the "EIP-4824 Activity Log JSON-LD Schema". The governanceURI should point to a flatfile, normatively a .md file. Each of the JSON files named above can be statically hosted or dynamically-generated.
    /// @return _daoURI The DAO URI.
    function daoURI() external view returns (string memory _daoURI);
}

// lib/openzeppelin-contracts/contracts/interfaces/IERC1271.sol

// OpenZeppelin Contracts v4.4.1 (interfaces/IERC1271.sol)

/**
 * @dev Interface of the ERC1271 standard signature validation method for
 * contracts as defined in https://eips.ethereum.org/EIPS/eip-1271[ERC-1271].
 *
 * _Available since v4.1._
 */
interface IERC1271 {
    /**
     * @dev Should return whether the signature provided is valid for the provided data
     * @param hash      Hash of the data to be signed
     * @param signature Signature byte array associated with _data
     */
    function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
}

// lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol

// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/introspection/IERC165Upgradeable.sol

// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165Upgradeable {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// lib/openzeppelin-contracts-upgradeable/contracts/interfaces/IERC1967Upgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC1967.sol)

/**
 * @dev ERC-1967: Proxy Storage Slots. This interface contains the events defined in the ERC.
 *
 * _Available since v4.8.3._
 */
interface IERC1967Upgradeable {
    /**
     * @dev Emitted when the implementation is upgraded.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Emitted when the admin account has changed.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Emitted when the beacon is changed.
     */
    event BeaconUpgraded(address indexed beacon);
}

// lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/extensions/IERC20PermitUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.4) (token/ERC20/extensions/IERC20Permit.sol)

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 *
 * ==== Security Considerations
 *
 * There are two important considerations concerning the use of `permit`. The first is that a valid permit signature
 * expresses an allowance, and it should not be assumed to convey additional meaning. In particular, it should not be
 * considered as an intention to spend the allowance in any specific way. The second is that because permits have
 * built-in replay protection and can be submitted by anyone, they can be frontrun. A protocol that uses permits should
 * take this into consideration and allow a `permit` call to fail. Combining these two aspects, a pattern that may be
 * generally recommended is:
 *
 * ```solidity
 * function doThingWithPermit(..., uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public {
 *     try token.permit(msg.sender, address(this), value, deadline, v, r, s) {} catch {}
 *     doThing(..., value);
 * }
 *
 * function doThing(..., uint256 value) public {
 *     token.safeTransferFrom(msg.sender, address(this), value);
 *     ...
 * }
 * ```
 *
 * Observe that: 1) `msg.sender` is used as the owner, leaving no ambiguity as to the signer intent, and 2) the use of
 * `try/catch` allows the permit to fail and makes the code tolerant to frontrunning. (See also
 * {SafeERC20-safeTransferFrom}).
 *
 * Additionally, note that smart contract wallets (such as Argent or Safe) are not able to produce permit signatures, so
 * contracts should have entry points that don't rely on permit.
 */
interface IERC20PermitUpgradeable {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     *
     * CAUTION: See Security Considerations above.
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/IERC20Upgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Upgradeable {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// lib/openzeppelin-contracts-upgradeable/contracts/token/ERC721/IERC721ReceiverUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721ReceiverUpgradeable {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// lib/osx-commons/contracts/src/executors/IExecutor.sol

/// @notice The action struct to be consumed by the DAO's `execute` function resulting in an external call.
/// @param to The address to call.
/// @param value The native token value to be sent with the call.
/// @param data The bytes-encoded function selector and calldata for the call.
struct Action {
    address to;
    uint256 value;
    bytes data;
}

/// @title IExecutor
/// @author Aragon X - 2024
/// @notice The interface required for Executors within the Aragon App DAO framework.
/// @custom:security-contact sirt@aragon.org
interface IExecutor {
    /// @notice Emitted when a proposal is executed.
    /// @dev The value of `callId` is defined by the component/contract calling the execute function.
    ///      A `Plugin` implementation can use it, for example, as a nonce.
    /// @param actor The address of the caller.
    /// @param callId The ID of the call.
    /// @param actions The array of actions executed.
    /// @param allowFailureMap The allow failure map encoding which actions are allowed to fail.
    /// @param failureMap The failure map encoding which actions have failed.
    /// @param execResults The array with the results of the executed actions.
    event Executed(
        address indexed actor,
        bytes32 callId,
        Action[] actions,
        uint256 allowFailureMap,
        uint256 failureMap,
        bytes[] execResults
    );

    /// @notice Executes a list of actions. If a zero allow-failure map is provided, a failing action reverts the entire execution. If a non-zero allow-failure map is provided, allowed actions can fail without the entire call being reverted.
    /// @param _callId The ID of the call. The definition of the value of `callId` is up to the calling contract and can be used, e.g., as a nonce.
    /// @param _actions The array of actions.
    /// @param _allowFailureMap A bitmap allowing execution to succeed, even if individual actions might revert. If the bit at index `i` is 1, the execution succeeds even if the `i`th action reverts. A failure map value of 0 requires every action to not revert.
    /// @return The array of results obtained from the executed actions in `bytes`.
    /// @return The resulting failure map containing the actions have actually failed.
    function execute(
        bytes32 _callId,
        Action[] memory _actions,
        uint256 _allowFailureMap
    ) external returns (bytes[] memory, uint256);
}

// lib/ens-contracts/contracts/resolvers/profiles/IExtendedResolver.sol

interface IExtendedResolver {
    function resolve(
        bytes memory name,
        bytes memory data
    ) external view returns (bytes memory);
}

// lib/ens-contracts/contracts/resolvers/profiles/IInterfaceResolver.sol

interface IInterfaceResolver {
    event InterfaceChanged(
        bytes32 indexed node,
        bytes4 indexed interfaceID,
        address implementer
    );

    /**
     * Returns the address of a contract that implements the specified interface for this name.
     * If an implementer has not been set for this interfaceID and name, the resolver will query
     * the contract at `addr()`. If `addr()` is set, a contract exists at that address, and that
     * contract implements EIP165 and returns `true` for the specified interfaceID, its address
     * will be returned.
     * @param node The ENS node to query.
     * @param interfaceID The EIP 165 interface ID to check for.
     * @return The address that implements this interface, or 0 if the interface is unsupported.
     */
    function interfaceImplementer(
        bytes32 node,
        bytes4 interfaceID
    ) external view returns (address);
}

// lib/ens-contracts/contracts/resolvers/profiles/INameResolver.sol

interface INameResolver {
    event NameChanged(bytes32 indexed node, string name);

    /**
     * Returns the name associated with an ENS node, for reverse records.
     * Defined in EIP181.
     * @param node The ENS node to query.
     * @return The associated name.
     */
    function name(bytes32 node) external view returns (string memory);
}

// lib/osx-commons/contracts/src/permission/condition/IPermissionCondition.sol

/// @title IPermissionCondition
/// @author Aragon X - 2021-2023
/// @notice An interface to be implemented to support custom permission logic.
/// @dev To attach a condition to a permission, the `grantWithCondition` function must be used and refer to the implementing contract's address with the `condition` argument.
/// @custom:security-contact sirt@aragon.org
interface IPermissionCondition {
    /// @notice Checks if a call is permitted.
    /// @param _where The address of the target contract.
    /// @param _who The address (EOA or contract) for which the permissions are checked.
    /// @param _permissionId The permission identifier.
    /// @param _data Optional data passed to the `PermissionCondition` implementation.
    /// @return isPermitted Returns true if the call is permitted.
    function isGranted(
        address _where,
        address _who,
        bytes32 _permissionId,
        bytes calldata _data
    ) external view returns (bool isPermitted);
}

// lib/osx-commons/contracts/src/plugin/IPlugin.sol

/// @title IPlugin
/// @author Aragon X - 2022-2024
/// @notice An interface defining the traits of a plugin.
/// @custom:security-contact sirt@aragon.org
interface IPlugin {
    /// @notice Types of plugin implementations available within OSx.
    enum PluginType {
        UUPS,
        Cloneable,
        Constructable
    }

    /// @notice Specifies the type of operation to perform.
    enum Operation {
        Call,
        DelegateCall
    }

    /// @notice Configuration for the target contract that the plugin will interact with, including the address and operation type.
    /// @dev By default, the plugin typically targets the associated DAO and performs a `Call` operation. However, this
    ///      configuration allows the plugin to specify a custom executor and select either `Call` or `DelegateCall` based on
    ///      the desired execution context.
    /// @param target The address of the target contract, typically the associated DAO but configurable to a custom executor.
    /// @param operation The type of operation (`Call` or `DelegateCall`) to execute on the target, as defined by `Operation`.
    struct TargetConfig {
        address target;
        Operation operation;
    }

    /// @notice Returns the plugin's type
    function pluginType() external view returns (PluginType);
}

// lib/osx/packages/contracts/src/framework/plugin/repo/IPluginRepo.sol

/// @title IPluginRepo
/// @author Aragon X - 2022-2023
/// @notice The interface required for a plugin repository.
/// @custom:security-contact sirt@aragon.org
interface IPluginRepo {
    /// @notice Updates the metadata for release with content `@fromHex(_releaseMetadata)`.
    /// @param _release The release number.
    /// @param _releaseMetadata The release metadata URI.
    function updateReleaseMetadata(uint8 _release, bytes calldata _releaseMetadata) external;

    /// @notice Creates a new plugin version as the latest build for an existing release number or the first build for a new release number for the provided `PluginSetup` contract address and metadata.
    /// @param _release The release number.
    /// @param _pluginSetupAddress The address of the plugin setup contract.
    /// @param _buildMetadata The build metadata URI.
    /// @param _releaseMetadata The release metadata URI.
    function createVersion(
        uint8 _release,
        address _pluginSetupAddress,
        bytes calldata _buildMetadata,
        bytes calldata _releaseMetadata
    ) external;

    /// @notice Emitted if the same plugin setup exists in previous releases.
    /// @param release The release number.
    /// @param build The build number.
    /// @param pluginSetup The address of the plugin setup contract.
    /// @param buildMetadata The build metadata URI.
    event VersionCreated(
        uint8 release,
        uint16 build,
        address indexed pluginSetup,
        bytes buildMetadata
    );

    /// @notice Emitted when a release's metadata was updated.
    /// @param release The release number.
    /// @param releaseMetadata The release metadata URI.
    event ReleaseMetadataUpdated(uint8 release, bytes releaseMetadata);
}

// lib/osx-commons/contracts/src/utils/versioning/IProtocolVersion.sol

/// @title IProtocolVersion
/// @author Aragon X - 2022-2023
/// @notice An interface defining the semantic Aragon OSx protocol version number.
/// @custom:security-contact sirt@aragon.org
interface IProtocolVersion {
    /// @notice Returns the semantic Aragon OSx protocol version number that the implementing contract is associated with.
    /// @return _version Returns the semantic Aragon OSx protocol version number.
    /// @dev This version number is not to be confused with the `release` and `build` numbers found in the `Version.Tag` struct inside the `PluginRepo` contract being used to version plugin setup and associated plugin implementation contracts.
    function protocolVersion() external view returns (uint8[3] memory _version);
}

// lib/ens-contracts/contracts/resolvers/profiles/IPubkeyResolver.sol

interface IPubkeyResolver {
    event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);

    /**
     * Returns the SECP256k1 public key associated with an ENS node.
     * Defined in EIP 619.
     * @param node The ENS node to query
     * @return x The X coordinate of the curve point for the public key.
     * @return y The Y coordinate of the curve point for the public key.
     */
    function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y);
}

// lib/ens-contracts/contracts/resolvers/profiles/ITextResolver.sol

interface ITextResolver {
    event TextChanged(
        bytes32 indexed node,
        string indexed indexedKey,
        string key,
        string value
    );

    /**
     * Returns the text data associated with an ENS node and key.
     * @param node The ENS node to query.
     * @param key The text data key to query.
     * @return The associated text data.
     */
    function text(
        bytes32 node,
        string calldata key
    ) external view returns (string memory);
}

// lib/osx-commons/contracts/src/permission/PermissionLib.sol

/// @title PermissionLib
/// @author Aragon X - 2021-2023
/// @notice A library containing objects for permission processing.
/// @custom:security-contact sirt@aragon.org
library PermissionLib {
    /// @notice A constant expressing that no condition is applied to a permission.
    address public constant NO_CONDITION = address(0);

    /// @notice The types of permission operations available in the `PermissionManager`.
    /// @param Grant The grant operation setting a permission without a condition.
    /// @param Revoke The revoke operation removing a permission (that was granted with or without a condition).
    /// @param GrantWithCondition The grant operation setting a permission with a condition.
    enum Operation {
        Grant,
        Revoke,
        GrantWithCondition
    }

    /// @notice A struct containing the information for a permission to be applied on a single target contract without a condition.
    /// @param operation The permission operation type.
    /// @param who The address (EOA or contract) receiving the permission.
    /// @param permissionId The permission identifier.
    struct SingleTargetPermission {
        Operation operation;
        address who;
        bytes32 permissionId;
    }

    /// @notice A struct containing the information for a permission to be applied on multiple target contracts, optionally, with a condition.
    /// @param operation The permission operation type.
    /// @param where The address of the target contract for which `who` receives permission.
    /// @param who The address (EOA or contract) receiving the permission.
    /// @param condition The `PermissionCondition` that will be asked for authorization on calls connected to the specified permission identifier.
    /// @param permissionId The permission identifier.
    struct MultiTargetPermission {
        Operation operation;
        address where;
        address who;
        address condition;
        bytes32 permissionId;
    }
}

// lib/osx/packages/contracts/src/framework/utils/RegistryUtils.sol

/// @notice Validates that a subdomain name is composed only from characters in the allowed character set:
/// - the lowercase letters `a-z`
/// - the digits `0-9`
/// - the hyphen `-`
/// @dev This function allows empty (zero-length) subdomains. If this should not be allowed, make sure to add a respective check when using this function in your code.
/// @param subDomain The name of the DAO.
/// @return `true` if the name is valid or `false` if at least one char is invalid.
/// @dev Aborts on the first invalid char found.
/// @custom:security-contact sirt@aragon.org
function isSubdomainValid(string calldata subDomain) pure returns (bool) {
    bytes calldata nameBytes = bytes(subDomain);
    uint256 nameLength = nameBytes.length;
    for (uint256 i; i < nameLength; i++) {
        uint8 char = uint8(nameBytes[i]);

        // if char is between a-z
        if (char > 96 && char < 123) {
            continue;
        }

        // if char is between 0-9
        if (char > 47 && char < 58) {
            continue;
        }

        // if char is -
        if (char == 45) {
            continue;
        }

        // invalid if one char doesn't work with the rules above
        return false;
    }
    return true;
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/StorageSlotUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
// This file was procedurally generated from scripts/generate/templates/StorageSlot.js.

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC1967 implementation slot:
 * ```solidity
 * contract ERC1967 {
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
 * _Available since v4.9 for `string`, `bytes`._
 */
library StorageSlotUpgradeable {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    struct StringSlot {
        string value;
    }

    struct BytesSlot {
        bytes value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` with member `value` located at `slot`.
     */
    function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
     */
    function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := store.slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` with member `value` located at `slot`.
     */
    function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
     */
    function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := store.slot
        }
    }
}

// lib/osx-commons/contracts/src/utils/versioning/VersionComparisonLib.sol

/// @title VersionComparisonLib
/// @author Aragon X - 2023
/// @notice A library containing methods for [semantic version number](https://semver.org/spec/v2.0.0.html) comparison.
/// @custom:security-contact sirt@aragon.org
library VersionComparisonLib {
    /// @notice Equality comparator for two semantic version numbers.
    /// @param lhs The left-hand side semantic version number.
    /// @param rhs The right-hand side semantic version number.
    /// @return Whether the two numbers are equal or not.
    function eq(uint8[3] memory lhs, uint8[3] memory rhs) internal pure returns (bool) {
        if (lhs[0] != rhs[0]) return false;

        if (lhs[1] != rhs[1]) return false;

        if (lhs[2] != rhs[2]) return false;

        return true;
    }

    /// @notice Inequality comparator for two semantic version numbers.
    /// @param lhs The left-hand side semantic version number.
    /// @param rhs The right-hand side semantic version number.
    /// @return Whether the two numbers are inequal or not.
    function neq(uint8[3] memory lhs, uint8[3] memory rhs) internal pure returns (bool) {
        if (lhs[0] != rhs[0]) return true;

        if (lhs[1] != rhs[1]) return true;

        if (lhs[2] != rhs[2]) return true;

        return false;
    }

    /// @notice Less than comparator for two semantic version numbers.
    /// @param lhs The left-hand side semantic version number.
    /// @param rhs The right-hand side semantic version number.
    /// @return Whether the first number is less than the second number or not.
    function lt(uint8[3] memory lhs, uint8[3] memory rhs) internal pure returns (bool) {
        if (lhs[0] < rhs[0]) return true;
        if (lhs[0] > rhs[0]) return false;

        if (lhs[1] < rhs[1]) return true;
        if (lhs[1] > rhs[1]) return false;

        if (lhs[2] < rhs[2]) return true;

        return false;
    }

    /// @notice Less than or equal to comparator for two semantic version numbers.
    /// @param lhs The left-hand side semantic version number.
    /// @param rhs The right-hand side semantic version number.
    /// @return Whether the first number is less than or equal to the second number or not.
    function lte(uint8[3] memory lhs, uint8[3] memory rhs) internal pure returns (bool) {
        if (lhs[0] < rhs[0]) return true;
        if (lhs[0] > rhs[0]) return false;

        if (lhs[1] < rhs[1]) return true;
        if (lhs[1] > rhs[1]) return false;

        if (lhs[2] <= rhs[2]) return true;

        return false;
    }

    /// @notice Greater than comparator for two semantic version numbers.
    /// @param lhs The left-hand side semantic version number.
    /// @param rhs The right-hand side semantic version number.
    /// @return Whether the first number is greater than the second number or not.
    function gt(uint8[3] memory lhs, uint8[3] memory rhs) internal pure returns (bool) {
        if (lhs[0] > rhs[0]) return true;
        if (lhs[0] < rhs[0]) return false;

        if (lhs[1] > rhs[1]) return true;
        if (lhs[1] < rhs[1]) return false;

        if (lhs[2] > rhs[2]) return true;

        return false;
    }

    /// @notice Greater than or equal to comparator for two semantic version numbers.
    /// @param lhs The left-hand side semantic version number.
    /// @param rhs The right-hand side semantic version number.
    /// @return Whether the first number is greater than or equal to the second number or not.
    function gte(uint8[3] memory lhs, uint8[3] memory rhs) internal pure returns (bool) {
        if (lhs[0] > rhs[0]) return true;
        if (lhs[0] < rhs[0]) return false;

        if (lhs[1] > rhs[1]) return true;
        if (lhs[1] < rhs[1]) return false;

        if (lhs[2] >= rhs[2]) return true;

        return false;
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/interfaces/draft-IERC1822Upgradeable.sol

// OpenZeppelin Contracts (last updated v4.5.0) (interfaces/draft-IERC1822.sol)

/**
 * @dev ERC1822: Universal Upgradeable Proxy Standard (UUPS) documents a method for upgradeability through a simplified
 * proxy whose upgrades are fully controlled by the current implementation.
 */
interface IERC1822ProxiableUpgradeable {
    /**
     * @dev Returns the storage slot that the proxiable contract assumes is being used to store the implementation
     * address.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy.
     */
    function proxiableUUID() external view returns (bytes32);
}

// lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol

// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// lib/openzeppelin-contracts/contracts/utils/introspection/ERC165Checker.sol

// OpenZeppelin Contracts (last updated v4.9.0) (utils/introspection/ERC165Checker.sol)

/**
 * @dev Library used to query support of an interface declared via {IERC165}.
 *
 * Note that these functions return the actual result of the query: they do not
 * `revert` if an interface is not supported. It is up to the caller to decide
 * what to do in these cases.
 */
library ERC165Checker {
    // As per the EIP-165 spec, no interface should ever match 0xffffffff
    bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;

    /**
     * @dev Returns true if `account` supports the {IERC165} interface.
     */
    function supportsERC165(address account) internal view returns (bool) {
        // Any contract that implements ERC165 must explicitly indicate support of
        // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
        return
            supportsERC165InterfaceUnchecked(account, type(IERC165).interfaceId) &&
            !supportsERC165InterfaceUnchecked(account, _INTERFACE_ID_INVALID);
    }

    /**
     * @dev Returns true if `account` supports the interface defined by
     * `interfaceId`. Support for {IERC165} itself is queried automatically.
     *
     * See {IERC165-supportsInterface}.
     */
    function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
        // query support of both ERC165 as per the spec and support of _interfaceId
        return supportsERC165(account) && supportsERC165InterfaceUnchecked(account, interfaceId);
    }

    /**
     * @dev Returns a boolean array where each value corresponds to the
     * interfaces passed in and whether they're supported or not. This allows
     * you to batch check interfaces for a contract where your expectation
     * is that some interfaces may not be supported.
     *
     * See {IERC165-supportsInterface}.
     *
     * _Available since v3.4._
     */
    function getSupportedInterfaces(
        address account,
        bytes4[] memory interfaceIds
    ) internal view returns (bool[] memory) {
        // an array of booleans corresponding to interfaceIds and whether they're supported or not
        bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);

        // query support of ERC165 itself
        if (supportsERC165(account)) {
            // query support of each interface in interfaceIds
            for (uint256 i = 0; i < interfaceIds.length; i++) {
                interfaceIdsSupported[i] = supportsERC165InterfaceUnchecked(account, interfaceIds[i]);
            }
        }

        return interfaceIdsSupported;
    }

    /**
     * @dev Returns true if `account` supports all the interfaces defined in
     * `interfaceIds`. Support for {IERC165} itself is queried automatically.
     *
     * Batch-querying can lead to gas savings by skipping repeated checks for
     * {IERC165} support.
     *
     * See {IERC165-supportsInterface}.
     */
    function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
        // query support of ERC165 itself
        if (!supportsERC165(account)) {
            return false;
        }

        // query support of each interface in interfaceIds
        for (uint256 i = 0; i < interfaceIds.length; i++) {
            if (!supportsERC165InterfaceUnchecked(account, interfaceIds[i])) {
                return false;
            }
        }

        // all interfaces supported
        return true;
    }

    /**
     * @notice Query if a contract implements an interface, does not check ERC165 support
     * @param account The address of the contract to query for support of an interface
     * @param interfaceId The interface identifier, as specified in ERC-165
     * @return true if the contract at account indicates support of the interface with
     * identifier interfaceId, false otherwise
     * @dev Assumes that account contains a contract that supports ERC165, otherwise
     * the behavior of this method is undefined. This precondition can be checked
     * with {supportsERC165}.
     *
     * Some precompiled contracts will falsely indicate support for a given interface, so caution
     * should be exercised when using this function.
     *
     * Interface identification is specified in ERC-165.
     */
    function supportsERC165InterfaceUnchecked(address account, bytes4 interfaceId) internal view returns (bool) {
        // prepare call
        bytes memory encodedParams = abi.encodeWithSelector(IERC165.supportsInterface.selector, interfaceId);

        // perform static call
        bool success;
        uint256 returnSize;
        uint256 returnValue;
        assembly {
            success := staticcall(30000, account, add(encodedParams, 0x20), mload(encodedParams), 0x00, 0x20)
            returnSize := returndatasize()
            returnValue := mload(0x00)
        }

        return success && returnSize >= 0x20 && returnValue > 0;
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/introspection/ERC165CheckerUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (utils/introspection/ERC165Checker.sol)

/**
 * @dev Library used to query support of an interface declared via {IERC165}.
 *
 * Note that these functions return the actual result of the query: they do not
 * `revert` if an interface is not supported. It is up to the caller to decide
 * what to do in these cases.
 */
library ERC165CheckerUpgradeable {
    // As per the EIP-165 spec, no interface should ever match 0xffffffff
    bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;

    /**
     * @dev Returns true if `account` supports the {IERC165} interface.
     */
    function supportsERC165(address account) internal view returns (bool) {
        // Any contract that implements ERC165 must explicitly indicate support of
        // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
        return
            supportsERC165InterfaceUnchecked(account, type(IERC165Upgradeable).interfaceId) &&
            !supportsERC165InterfaceUnchecked(account, _INTERFACE_ID_INVALID);
    }

    /**
     * @dev Returns true if `account` supports the interface defined by
     * `interfaceId`. Support for {IERC165} itself is queried automatically.
     *
     * See {IERC165-supportsInterface}.
     */
    function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
        // query support of both ERC165 as per the spec and support of _interfaceId
        return supportsERC165(account) && supportsERC165InterfaceUnchecked(account, interfaceId);
    }

    /**
     * @dev Returns a boolean array where each value corresponds to the
     * interfaces passed in and whether they're supported or not. This allows
     * you to batch check interfaces for a contract where your expectation
     * is that some interfaces may not be supported.
     *
     * See {IERC165-supportsInterface}.
     *
     * _Available since v3.4._
     */
    function getSupportedInterfaces(
        address account,
        bytes4[] memory interfaceIds
    ) internal view returns (bool[] memory) {
        // an array of booleans corresponding to interfaceIds and whether they're supported or not
        bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);

        // query support of ERC165 itself
        if (supportsERC165(account)) {
            // query support of each interface in interfaceIds
            for (uint256 i = 0; i < interfaceIds.length; i++) {
                interfaceIdsSupported[i] = supportsERC165InterfaceUnchecked(account, interfaceIds[i]);
            }
        }

        return interfaceIdsSupported;
    }

    /**
     * @dev Returns true if `account` supports all the interfaces defined in
     * `interfaceIds`. Support for {IERC165} itself is queried automatically.
     *
     * Batch-querying can lead to gas savings by skipping repeated checks for
     * {IERC165} support.
     *
     * See {IERC165-supportsInterface}.
     */
    function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
        // query support of ERC165 itself
        if (!supportsERC165(account)) {
            return false;
        }

        // query support of each interface in interfaceIds
        for (uint256 i = 0; i < interfaceIds.length; i++) {
            if (!supportsERC165InterfaceUnchecked(account, interfaceIds[i])) {
                return false;
            }
        }

        // all interfaces supported
        return true;
    }

    /**
     * @notice Query if a contract implements an interface, does not check ERC165 support
     * @param account The address of the contract to query for support of an interface
     * @param interfaceId The interface identifier, as specified in ERC-165
     * @return true if the contract at account indicates support of the interface with
     * identifier interfaceId, false otherwise
     * @dev Assumes that account contains a contract that supports ERC165, otherwise
     * the behavior of this method is undefined. This precondition can be checked
     * with {supportsERC165}.
     *
     * Some precompiled contracts will falsely indicate support for a given interface, so caution
     * should be exercised when using this function.
     *
     * Interface identification is specified in ERC-165.
     */
    function supportsERC165InterfaceUnchecked(address account, bytes4 interfaceId) internal view returns (bool) {
        // prepare call
        bytes memory encodedParams = abi.encodeWithSelector(IERC165Upgradeable.supportsInterface.selector, interfaceId);

        // perform static call
        bool success;
        uint256 returnSize;
        uint256 returnValue;
        assembly {
            success := staticcall(30000, account, add(encodedParams, 0x20), mload(encodedParams), 0x00, 0x20)
            returnSize := returndatasize()
            returnValue := mload(0x00)
        }

        return success && returnSize >= 0x20 && returnValue > 0;
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/IERC1155ReceiverUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)

/**
 * @dev _Available since v3.1._
 */
interface IERC1155ReceiverUpgradeable is IERC165Upgradeable {
    /**
     * @dev Handles the receipt of a single ERC1155 token type. This function is
     * called at the end of a `safeTransferFrom` after the balance has been updated.
     *
     * NOTE: To accept the transfer, this must return
     * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     * (i.e. 0xf23a6e61, or its own function selector).
     *
     * @param operator The address which initiated the transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param id The ID of the token being transferred
     * @param value The amount of tokens being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
     */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @dev Handles the receipt of a multiple ERC1155 token types. This function
     * is called at the end of a `safeBatchTransferFrom` after the balances have
     * been updated.
     *
     * NOTE: To accept the transfer(s), this must return
     * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     * (i.e. 0xbc197c81, or its own function selector).
     *
     * @param operator The address which initiated the batch transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param ids An array containing ids of each token being transferred (order and length must match values array)
     * @param values An array containing amounts of each token being transferred (order and length must match ids array)
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

// lib/openzeppelin-contracts-upgradeable/contracts/token/ERC1155/IERC1155Upgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC1155/IERC1155.sol)

/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155Upgradeable is IERC165Upgradeable {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(
        address[] calldata accounts,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}

// lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/Initializable.sol)

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     * @custom:oz-retyped-from bool
     */
    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
     * constructor.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        bool isTopLevelCall = !_initializing;
        require(
            (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
            "Initializable: contract is already initialized"
        );
        _initialized = 1;
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: setting the version to 255 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint8 version) {
        require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
        _initialized = version;
        _initializing = true;
        _;
        _initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized != type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint8) {
        return _initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _initializing;
    }
}

// lib/osx-commons/contracts/src/utils/versioning/ProtocolVersion.sol

/// @title ProtocolVersion
/// @author Aragon X - 2023
/// @notice An abstract, stateless, non-upgradeable contract providing the current Aragon OSx protocol version number.
/// @dev Do not add any new variables to this contract that would shift down storage in the inheritance chain.
/// @custom:security-contact sirt@aragon.org
abstract contract ProtocolVersion is IProtocolVersion {
    // IMPORTANT: Do not add any storage variable, see the above notice.

    /// @inheritdoc IProtocolVersion
    function protocolVersion() public pure returns (uint8[3] memory) {
        return [1, 4, 0];
    }
}

// lib/osx-commons/contracts/src/permission/auth/auth.sol

/// @title DAO Authorization Utilities
/// @author Aragon X - 2022-2024
/// @notice Provides utility functions for verifying if a caller has specific permissions in an associated DAO.
/// @custom:security-contact sirt@aragon.org

/// @notice Thrown if a call is unauthorized in the associated DAO.
/// @param dao The associated DAO.
/// @param where The context in which the authorization reverted.
/// @param who The address (EOA or contract) missing the permission.
/// @param permissionId The permission identifier.
error DaoUnauthorized(address dao, address where, address who, bytes32 permissionId);

/// @notice A free function checking if a caller is granted permissions on a target contract via a permission identifier that redirects the approval to a `PermissionCondition` if this was specified in the setup.
/// @param _where The address of the target contract for which `who` receives permission.
/// @param _who The address (EOA or contract) owning the permission.
/// @param _permissionId The permission identifier.
/// @param _data The optional data passed to the `PermissionCondition` registered.
function _auth(
    IDAO _dao,
    address _where,
    address _who,
    bytes32 _permissionId,
    bytes calldata _data
) view {
    if (!_dao.hasPermission(_where, _who, _permissionId, _data))
        revert DaoUnauthorized({
            dao: address(_dao),
            where: _where,
            who: _who,
            permissionId: _permissionId
        });
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/ContextUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.4) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// lib/osx-commons/contracts/src/plugin/setup/IPluginSetup.sol

// solhint-disable-next-line no-unused-import

/// @title IPluginSetup
/// @author Aragon X - 2022-2023
/// @notice The interface required for a plugin setup contract to be consumed by the `PluginSetupProcessor` for plugin installations, updates, and uninstallations.
/// @custom:security-contact sirt@aragon.org
interface IPluginSetup {
    /// @notice The data associated with a prepared setup.
    /// @param helpers The address array of helpers (contracts or EOAs) associated with this plugin version after the installation or update.
    /// @param permissions The array of multi-targeted permission operations to be applied by the `PluginSetupProcessor` to the installing or updating DAO.
    struct PreparedSetupData {
        address[] helpers;
        PermissionLib.MultiTargetPermission[] permissions;
    }

    /// @notice The payload for plugin updates and uninstallations containing the existing contracts as well as optional data to be consumed by the plugin setup.
    /// @param plugin The address of the `Plugin`.
    /// @param currentHelpers The address array of all current helpers (contracts or EOAs) associated with the plugin to update from.
    /// @param data The bytes-encoded data containing the input parameters for the preparation of update/uninstall as specified in the corresponding ABI on the version's metadata.
    struct SetupPayload {
        address plugin;
        address[] currentHelpers;
        bytes data;
    }

    /// @notice Prepares the installation of a plugin.
    /// @param _dao The address of the installing DAO.
    /// @param _data The bytes-encoded data containing the input parameters for the installation as specified in the plugin's build metadata JSON file.
    /// @return plugin The address of the `Plugin` contract being prepared for installation.
    /// @return preparedSetupData The deployed plugin's relevant data which consists of helpers and permissions.
    function prepareInstallation(
        address _dao,
        bytes calldata _data
    ) external returns (address plugin, PreparedSetupData memory preparedSetupData);

    /// @notice Prepares the update of a plugin.
    /// @param _dao The address of the updating DAO.
    /// @param _fromBuild The build number of the plugin to update from.
    /// @param _payload The relevant data necessary for the `prepareUpdate`. See above.
    /// @return initData The initialization data to be passed to upgradeable contracts when the update is applied in the `PluginSetupProcessor`.
    /// @return preparedSetupData The deployed plugin's relevant data which consists of helpers and permissions.
    function prepareUpdate(
        address _dao,
        uint16 _fromBuild,
        SetupPayload calldata _payload
    ) external returns (bytes memory initData, PreparedSetupData memory preparedSetupData);

    /// @notice Prepares the uninstallation of a plugin.
    /// @param _dao The address of the uninstalling DAO.
    /// @param _payload The relevant data necessary for the `prepareUninstallation`. See above.
    /// @return permissions The array of multi-targeted permission operations to be applied by the `PluginSetupProcessor` to the uninstalling DAO.
    function prepareUninstallation(
        address _dao,
        SetupPayload calldata _payload
    ) external returns (PermissionLib.MultiTargetPermission[] memory permissions);

    /// @notice Returns the plugin implementation address.
    /// @return The address of the plugin implementation contract.
    /// @dev The implementation can be instantiated via the `new` keyword, cloned via the minimal proxy pattern (see [ERC-1167](https://eips.ethereum.org/EIPS/eip-1167)), or proxied via the UUPS proxy pattern (see [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822)).
    function implementation() external view returns (address);
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/introspection/ERC165Upgradeable.sol

// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
    function __ERC165_init() internal onlyInitializing {
    }

    function __ERC165_init_unchained() internal onlyInitializing {
    }
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165Upgradeable).interfaceId;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// lib/openzeppelin-contracts-upgradeable/contracts/token/ERC20/utils/SafeERC20Upgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.3) (token/ERC20/utils/SafeERC20.sol)

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20Upgradeable {
    using AddressUpgradeable for address;

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20Upgradeable token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20Upgradeable token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    /**
     * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeIncreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
    }

    /**
     * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeDecreaseAllowance(IERC20Upgradeable token, address spender, uint256 value) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
        }
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Meant to be used with tokens that require the approval
     * to be set to zero before setting it to a non-zero value, such as USDT.
     */
    function forceApprove(IERC20Upgradeable token, address spender, uint256 value) internal {
        bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
            _callOptionalReturn(token, approvalCall);
        }
    }

    /**
     * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
     * Revert on invalid signature.
     */
    function safePermit(
        IERC20PermitUpgradeable token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
     */
    function _callOptionalReturnBool(IERC20Upgradeable token, bytes memory data) private returns (bool) {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
        // and not revert is the subcall reverts.

        (bool success, bytes memory returndata) = address(token).call(data);
        return
            success && (returndata.length == 0 || abi.decode(returndata, (bool))) && AddressUpgradeable.isContract(address(token));
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/utils/introspection/ERC165StorageUpgradeable.sol

// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165Storage.sol)

/**
 * @dev Storage based implementation of the {IERC165} interface.
 *
 * Contracts may inherit from this and call {_registerInterface} to declare
 * their support of an interface.
 */
abstract contract ERC165StorageUpgradeable is Initializable, ERC165Upgradeable {
    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    function __ERC165Storage_init() internal onlyInitializing {
    }

    function __ERC165Storage_init_unchained() internal onlyInitializing {
    }
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return super.supportsInterface(interfaceId) || _supportedInterfaces[interfaceId];
    }

    /**
     * @dev Registers the contract as an implementer of the interface defined by
     * `interfaceId`. Support of the actual ERC165 interface is automatic and
     * registering its interface id is not required.
     *
     * See {IERC165-supportsInterface}.
     *
     * Requirements:
     *
     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
     */
    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

// lib/osx-commons/contracts/src/executors/Executor.sol

/// @title IDAO
/// @author Aragon X - 2024
/// @notice Simple Executor that loops through the actions and executes them.
/// @dev This doesn't use any type of permission for execution and can be called by anyone.
///      Most useful use-case is to deploy it as non-upgradeable and call from another contract via delegatecall.
///      If used with delegatecall, DO NOT add state variables in sequential slots, otherwise this will overwrite
///      the storage of the calling contract.
/// @custom:security-contact sirt@aragon.org
contract Executor is IExecutor, ERC165 {
    /// @notice The internal constant storing the maximal action array length.
    uint256 internal constant MAX_ACTIONS = 256;

    // keccak256("osx-commons.storage.Executor")
    bytes32 private constant REENTRANCY_GUARD_STORAGE_LOCATION =
        0x4d6542319dfb3f7c8adbb488d7b4d7cf849381f14faf4b64de3ac05d08c0bdec;

    /// @notice The first out of two values to which the `_reentrancyStatus` state variable (used by the `nonReentrant` modifier) can be set indicating that a function was not entered.
    uint256 private constant _NOT_ENTERED = 1;

    /// @notice The second out of two values to which the `_reentrancyStatus` state variable (used by the `nonReentrant` modifier) can be set indicating that a function was entered.
    uint256 private constant _ENTERED = 2;

    /// @notice Thrown if the action array length is larger than `MAX_ACTIONS`.
    error TooManyActions();

    /// @notice Thrown if an action has insufficient gas left.
    error InsufficientGas();

    /// @notice Thrown if action execution has failed.
    /// @param index The index of the action in the action array that failed.
    error ActionFailed(uint256 index);

    /// @notice Thrown if a call is reentrant.
    error ReentrantCall();

    /// @notice Initializes the contract with a non-entered reentrancy status.
    /// @dev Sets the reentrancy guard status to `_NOT_ENTERED` to prevent reentrant calls from the start.
    constructor() {
        _storeReentrancyStatus(_NOT_ENTERED);
    }

    /// @notice Prevents reentrant calls to a function.
    /// @dev This modifier checks the reentrancy status before function execution. If already entered, it reverts with
    ///      `ReentrantCall()`. Sets the status to `_ENTERED` during execution and resets it to `_NOT_ENTERED` afterward.
    modifier nonReentrant() {
        if (_getReentrancyStatus() == _ENTERED) {
            revert ReentrantCall();
        }

        _storeReentrancyStatus(_ENTERED);

        _;

        _storeReentrancyStatus(_NOT_ENTERED);
    }

    /// @notice Checks if this or the parent contract supports an interface by its ID.
    /// @param _interfaceId The ID of the interface.
    /// @return Returns `true` if the interface is supported.
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return _interfaceId == type(IExecutor).interfaceId || super.supportsInterface(_interfaceId);
    }

    /// @inheritdoc IExecutor
    function execute(
        bytes32 _callId,
        Action[] memory _actions,
        uint256 _allowFailureMap
    )
        public
        virtual
        override
        nonReentrant
        returns (bytes[] memory execResults, uint256 failureMap)
    {
        // Check that the action array length is within bounds.
        if (_actions.length > MAX_ACTIONS) {
            revert TooManyActions();
        }

        execResults = new bytes[](_actions.length);

        uint256 gasBefore;
        uint256 gasAfter;

        for (uint256 i = 0; i < _actions.length; ) {
            gasBefore = gasleft();

            (bool success, bytes memory data) = _actions[i].to.call{value: _actions[i].value}(
                _actions[i].data
            );

            gasAfter = gasleft();

            // Check if failure is allowed
            if (!success) {
                if (!hasBit(_allowFailureMap, uint8(i))) {
                    revert ActionFailed(i);
                }

                // Make sure that the action call did not fail because 63/64 of `gasleft()` was insufficient to execute the external call `.to.call` (see [ERC-150](https://eips.ethereum.org/EIPS/eip-150)).
                // In specific scenarios, i.e. proposal execution where the last action in the action array is allowed to fail, the account calling `execute` could force-fail this action by setting a gas limit
                // where 63/64 is insufficient causing the `.to.call` to fail, but where the remaining 1/64 gas are sufficient to successfully finish the `execute` call.
                if (gasAfter < gasBefore / 64) {
                    revert InsufficientGas();
                }
                // Store that this action failed.
                failureMap = flipBit(failureMap, uint8(i));
            }

            execResults[i] = data;

            unchecked {
                ++i;
            }
        }

        emit Executed({
            actor: msg.sender,
            callId: _callId,
            actions: _actions,
            allowFailureMap: _allowFailureMap,
            failureMap: failureMap,
            execResults: execResults
        });
    }

    /// @notice Gets the current reentrancy status.
    /// @return status This returns the current reentrancy status.
    function _getReentrancyStatus() private view returns (uint256 status) {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            status := sload(REENTRANCY_GUARD_STORAGE_LOCATION)
        }
    }

    /// @notice Stores the reentrancy status at a specific storage slot.
    /// @param _status The reentrancy status to be stored, typically `_ENTERED` or `_NOT_ENTERED`.
    /// @dev Uses inline assembly to store the `_status` value at `REENTRANCY_GUARD_STORAGE_LOCATION` to manage
    ///      reentrancy status efficiently.
    function _storeReentrancyStatus(uint256 _status) private {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            sstore(REENTRANCY_GUARD_STORAGE_LOCATION, _status)
        }
    }
}

// lib/osx-commons/contracts/src/permission/auth/DaoAuthorizableUpgradeable.sol

/// @title DaoAuthorizableUpgradeable
/// @author Aragon X - 2022-2023
/// @notice An abstract contract providing a meta-transaction compatible modifier for upgradeable or cloneable contracts to authorize function calls through an associated DAO.
/// @dev Make sure to call `__DaoAuthorizableUpgradeable_init` during initialization of the inheriting contract.
/// @custom:security-contact sirt@aragon.org
abstract contract DaoAuthorizableUpgradeable is ContextUpgradeable {
    /// @notice The associated DAO managing the permissions of inheriting contracts.
    IDAO private dao_;

    /// @notice Initializes the contract by setting the associated DAO.
    /// @param _dao The associated DAO address.
    // solhint-disable-next-line func-name-mixedcase
    function __DaoAuthorizableUpgradeable_init(IDAO _dao) internal onlyInitializing {
        dao_ = _dao;
    }

    /// @notice Returns the DAO contract.
    /// @return The DAO contract.
    function dao() public view returns (IDAO) {
        return dao_;
    }

    /// @notice A modifier to make functions on inheriting contracts authorized. Permissions to call the function are checked through the associated DAO's permission manager.
    /// @param _permissionId The permission identifier required to call the method this modifier is applied to.
    modifier auth(bytes32 _permissionId) {
        _auth(dao_, address(this), _msgSender(), _permissionId, _msgData());
        _;
    }

    /// @notice This empty reserved space is put in place to allow future versions to add new variables without shifting down storage in the inheritance chain (see [OpenZeppelin's guide about storage gaps](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps)).
    uint256[49] private __gap;
}

// lib/osx-commons/contracts/src/permission/condition/PermissionCondition.sol

/// @title PermissionCondition
/// @author Aragon X - 2023
/// @notice An abstract contract for non-upgradeable contracts instantiated via the `new` keyword  to inherit from to support customary permissions depending on arbitrary on-chain state.
/// @custom:security-contact sirt@aragon.org
abstract contract PermissionCondition is ERC165, IPermissionCondition, ProtocolVersion {
    /// @notice Checks if an interface is supported by this or its parent contract.
    /// @param _interfaceId The ID of the interface.
    /// @return Returns `true` if the interface is supported.
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return
            _interfaceId == type(IPermissionCondition).interfaceId ||
            _interfaceId == type(IProtocolVersion).interfaceId ||
            super.supportsInterface(_interfaceId);
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (proxy/ERC1967/ERC1967Upgrade.sol)

/**
 * @dev This abstract contract provides getters and event emitting update functions for
 * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
 *
 * _Available since v4.1._
 */
abstract contract ERC1967UpgradeUpgradeable is Initializable, IERC1967Upgradeable {
    // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
    bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function __ERC1967Upgrade_init() internal onlyInitializing {
    }

    function __ERC1967Upgrade_init_unchained() internal onlyInitializing {
    }
    /**
     * @dev Returns the current implementation address.
     */
    function _getImplementation() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 implementation slot.
     */
    function _setImplementation(address newImplementation) private {
        require(AddressUpgradeable.isContract(newImplementation), "ERC1967: new implementation is not a contract");
        StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
    }

    /**
     * @dev Perform implementation upgrade
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    /**
     * @dev Perform implementation upgrade with additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCall(address newImplementation, bytes memory data, bool forceCall) internal {
        _upgradeTo(newImplementation);
        if (data.length > 0 || forceCall) {
            AddressUpgradeable.functionDelegateCall(newImplementation, data);
        }
    }

    /**
     * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCallUUPS(address newImplementation, bytes memory data, bool forceCall) internal {
        // Upgrades from old implementations will perform a rollback test. This test requires the new
        // implementation to upgrade back to the old, non-ERC1822 compliant, implementation. Removing
        // this special case will break upgrade paths from old UUPS implementation to new ones.
        if (StorageSlotUpgradeable.getBooleanSlot(_ROLLBACK_SLOT).value) {
            _setImplementation(newImplementation);
        } else {
            try IERC1822ProxiableUpgradeable(newImplementation).proxiableUUID() returns (bytes32 slot) {
                require(slot == _IMPLEMENTATION_SLOT, "ERC1967Upgrade: unsupported proxiableUUID");
            } catch {
                revert("ERC1967Upgrade: new implementation is not UUPS");
            }
            _upgradeToAndCall(newImplementation, data, forceCall);
        }
    }

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Returns the current admin.
     */
    function _getAdmin() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 admin slot.
     */
    function _setAdmin(address newAdmin) private {
        require(newAdmin != address(0), "ERC1967: new admin is the zero address");
        StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
    }

    /**
     * @dev Changes the admin of the proxy.
     *
     * Emits an {AdminChanged} event.
     */
    function _changeAdmin(address newAdmin) internal {
        emit AdminChanged(_getAdmin(), newAdmin);
        _setAdmin(newAdmin);
    }

    /**
     * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
     * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
     */
    bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;

    /**
     * @dev Returns the current beacon.
     */
    function _getBeacon() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value;
    }

    /**
     * @dev Stores a new beacon in the EIP1967 beacon slot.
     */
    function _setBeacon(address newBeacon) private {
        require(AddressUpgradeable.isContract(newBeacon), "ERC1967: new beacon is not a contract");
        require(
            AddressUpgradeable.isContract(IBeaconUpgradeable(newBeacon).implementation()),
            "ERC1967: beacon implementation is not a contract"
        );
        StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value = newBeacon;
    }

    /**
     * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
     * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
     *
     * Emits a {BeaconUpgraded} event.
     */
    function _upgradeBeaconToAndCall(address newBeacon, bytes memory data, bool forceCall) internal {
        _setBeacon(newBeacon);
        emit BeaconUpgraded(newBeacon);
        if (data.length > 0 || forceCall) {
            AddressUpgradeable.functionDelegateCall(IBeaconUpgradeable(newBeacon).implementation(), data);
        }
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// lib/osx-commons/contracts/src/plugin/setup/PluginSetup.sol

/// @title PluginSetup
/// @author Aragon X - 2022-2024
/// @notice An abstract contract to inherit from to implement the plugin setup for non-upgradeable plugins, i.e,
/// - `Plugin` being deployed via the `new` keyword
/// - `PluginCloneable` being deployed via the minimal proxy pattern (see [ERC-1167](https://eips.ethereum.org/EIPS/eip-1167)).
/// @custom:security-contact sirt@aragon.org
abstract contract PluginSetup is ERC165, IPluginSetup, ProtocolVersion {
    /// @notice The address of the plugin implementation contract for initial block explorer verification and, in the case of `PluginClonable` implementations, to create [ERC-1167](https://eips.ethereum.org/EIPS/eip-1167) clones from.
    address internal immutable IMPLEMENTATION;

    /// @notice Thrown when attempting to prepare an update on a non-upgradeable plugin.
    error NonUpgradeablePlugin();

    /// @notice The contract constructor, that setting the plugin implementation contract.
    /// @param _implementation The address of the plugin implementation contract.
    constructor(address _implementation) {
        IMPLEMENTATION = _implementation;
    }

    /// @inheritdoc IPluginSetup
    /// @dev Since the underlying plugin is non-upgradeable, this non-virtual function must always revert.
    function prepareUpdate(
        address _dao,
        uint16 _fromBuild,
        SetupPayload calldata _payload
    ) external returns (bytes memory, PreparedSetupData memory) {
        (_dao, _fromBuild, _payload);
        revert NonUpgradeablePlugin();
    }

    /// @notice Checks if this or the parent contract supports an interface by its ID.
    /// @param _interfaceId The ID of the interface.
    /// @return Returns `true` if the interface is supported.
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return
            _interfaceId == type(IPluginSetup).interfaceId ||
            _interfaceId == type(IProtocolVersion).interfaceId ||
            super.supportsInterface(_interfaceId);
    }

    /// @inheritdoc IPluginSetup
    function implementation() public view returns (address) {
        return IMPLEMENTATION;
    }
}

// lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol

// OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/UUPSUpgradeable.sol)

/**
 * @dev An upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an
 * {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
 *
 * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is
 * reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing
 * `UUPSUpgradeable` with a custom implementation of upgrades.
 *
 * The {_authorizeUpgrade} function must be overridden to include access restriction to the upgrade mechanism.
 *
 * _Available since v4.1._
 */
abstract contract UUPSUpgradeable is Initializable, IERC1822ProxiableUpgradeable, ERC1967UpgradeUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
    address private immutable __self = address(this);

    /**
     * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
     * a proxy contract with an implementation (as defined in ERC1967) pointing to self. This should only be the case
     * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
     * function through ERC1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
     * fail.
     */
    modifier onlyProxy() {
        require(address(this) != __self, "Function must be called through delegatecall");
        require(_getImplementation() == __self, "Function must be called through active proxy");
        _;
    }

    /**
     * @dev Check that the execution is not being performed through a delegate call. This allows a function to be
     * callable on the implementing contract but not through proxies.
     */
    modifier notDelegated() {
        require(address(this) == __self, "UUPSUpgradeable: must not be called through delegatecall");
        _;
    }

    function __UUPSUpgradeable_init() internal onlyInitializing {
    }

    function __UUPSUpgradeable_init_unchained() internal onlyInitializing {
    }
    /**
     * @dev Implementation of the ERC1822 {proxiableUUID} function. This returns the storage slot used by the
     * implementation. It is used to validate the implementation's compatibility when performing an upgrade.
     *
     * IMPORTANT: A proxy pointing at a proxiable contract should not be considered proxiable itself, because this risks
     * bricking a proxy that upgrades to it, by delegating to itself until out of gas. Thus it is critical that this
     * function revert if invoked through a proxy. This is guaranteed by the `notDelegated` modifier.
     */
    function proxiableUUID() external view virtual override notDelegated returns (bytes32) {
        return _IMPLEMENTATION_SLOT;
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     *
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function upgradeTo(address newImplementation) public virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
     * encoded in `data`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     *
     * @custom:oz-upgrades-unsafe-allow-reachable delegatecall
     */
    function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, data, true);
    }

    /**
     * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
     * {upgradeTo} and {upgradeToAndCall}.
     *
     * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
     *
     * ```solidity
     * function _authorizeUpgrade(address) internal override onlyOwner {}
     * ```
     */
    function _authorizeUpgrade(address newImplementation) internal virtual;

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// lib/osx/packages/contracts/src/core/permission/PermissionManager.sol

/// @title PermissionManager
/// @author Aragon X - 2021-2023
/// @notice The abstract permission manager used in a DAO, its associated plugins, and other framework-related components.
/// @custom:security-contact sirt@aragon.org
abstract contract PermissionManager is Initializable {
    using AddressUpgradeable for address;

    /// @notice The ID of the permission required to call the `grant`, `grantWithCondition`, `revoke`, and `bulk` function.
    bytes32 public constant ROOT_PERMISSION_ID = keccak256("ROOT_PERMISSION");

    /// @notice A special address encoding permissions that are valid for any address `who` or `where`.
    address internal constant ANY_ADDR = address(type(uint160).max);

    /// @notice A special address encoding if a permissions is not set and therefore not allowed.
    address internal constant UNSET_FLAG = address(0);

    /// @notice A special address encoding if a permission is allowed.
    address internal constant ALLOW_FLAG = address(2);

    /// @notice A mapping storing permissions as hashes (i.e., `permissionHash(where, who, permissionId)`) and their status encoded by an address (unset, allowed, or redirecting to a `PermissionCondition`).
    mapping(bytes32 => address) internal permissionsHashed;

    /// @notice Thrown if a call is unauthorized.
    /// @param where The context in which the authorization reverted.
    /// @param who The address (EOA or contract) missing the permission.
    /// @param permissionId The permission identifier.
    error Unauthorized(address where, address who, bytes32 permissionId);

    /// @notice Thrown if a permission has been already granted with a different condition.
    /// @dev This makes sure that condition on the same permission can not be overwriten by a different condition.
    /// @param where The address of the target contract to grant `_who` permission to.
    /// @param who The address (EOA or contract) to which the permission has already been granted.
    /// @param permissionId The permission identifier.
    /// @param currentCondition The current condition set for permissionId.
    /// @param newCondition The new condition it tries to set for permissionId.
    error PermissionAlreadyGrantedForDifferentCondition(
        address where,
        address who,
        bytes32 permissionId,
        address currentCondition,
        address newCondition
    );

    /// @notice Thrown if a condition address is not a contract.
    /// @param condition The address that is not a contract.
    error ConditionNotAContract(IPermissionCondition condition);

    /// @notice Thrown if a condition contract does not support the `IPermissionCondition` interface.
    /// @param condition The address that is not a contract.
    error ConditionInterfaceNotSupported(IPermissionCondition condition);

    /// @notice Thrown for `ROOT_PERMISSION_ID` or `EXECUTE_PERMISSION_ID` permission grants where `who` or `where` is `ANY_ADDR`.
    error PermissionsForAnyAddressDisallowed();

    /// @notice Thrown for permission grants where `who` and `where` are both `ANY_ADDR`.
    error AnyAddressDisallowedForWhoAndWhere();

    /// @notice Thrown if `Operation.GrantWithCondition` is requested as an operation but the method does not support it.
    error GrantWithConditionNotSupported();

    /// @notice Emitted when a permission `permission` is granted in the context `here` to the address `_who` for the contract `_where`.
    /// @param permissionId The permission identifier.
    /// @param here The address of the context in which the permission is granted.
    /// @param where The address of the target contract for which `_who` receives permission.
    /// @param who The address (EOA or contract) receiving the permission.
    /// @param condition The address `ALLOW_FLAG` for regular permissions or, alternatively, the `IPermissionCondition` contract implementation to be used.
    event Granted(
        bytes32 indexed permissionId,
        address indexed here,
        address where,
        address indexed who,
        address condition
    );

    /// @notice Emitted when a permission `permission` is revoked in the context `here` from the address `_who` for the contract `_where`.
    /// @param permissionId The permission identifier.
    /// @param here The address of the context in which the permission is revoked.
    /// @param where The address of the target contract for which `_who` loses permission.
    /// @param who The address (EOA or contract) losing the permission.
    event Revoked(
        bytes32 indexed permissionId,
        address indexed here,
        address where,
        address indexed who
    );

    /// @notice A modifier to make functions on inheriting contracts authorized. Permissions to call the function are checked through this permission manager.
    /// @param _permissionId The permission identifier required to call the method this modifier is applied to.
    modifier auth(bytes32 _permissionId) {
        _auth(_permissionId);
        _;
    }

    /// @notice Initialization method to set the initial owner of the permission manager.
    /// @dev The initial owner is granted the `ROOT_PERMISSION_ID` permission.
    /// @param _initialOwner The initial owner of the permission manager.
    function __PermissionManager_init(address _initialOwner) internal onlyInitializing {
        _initializePermissionManager({_initialOwner: _initialOwner});
    }

    /// @notice Grants permission to an address to call methods in a contract guarded by an auth modifier with the specified permission identifier.
    /// @dev Requires the `ROOT_PERMISSION_ID` permission.
    /// @param _where The address of the target contract for which `_who` receives permission.
    /// @param _who The address (EOA or contract) receiving the permission.
    /// @param _permissionId The permission identifier.
    /// @dev Note, that granting permissions with `_who` or `_where` equal to `ANY_ADDR` does not replace other permissions with specific `_who` and `_where` addresses that exist in parallel.
    function grant(
        address _where,
        address _who,
        bytes32 _permissionId
    ) external virtual auth(ROOT_PERMISSION_ID) {
        _grant({_where: _where, _who: _who, _permissionId: _permissionId});
    }

    /// @notice Grants permission to an address to call methods in a target contract guarded by an auth modifier with the specified permission identifier if the referenced condition permits it.
    /// @dev Requires the `ROOT_PERMISSION_ID` permission
    /// @param _where The address of the target contract for which `_who` receives permission.
    /// @param _who The address (EOA or contract) receiving the permission.
    /// @param _permissionId The permission identifier.
    /// @param _condition The `PermissionCondition` that will be asked for authorization on calls connected to the specified permission identifier.
    /// @dev Note, that granting permissions with `_who` or `_where` equal to `ANY_ADDR` does not replace other permissions with specific `_who` and `_where` addresses that exist in parallel.
    function grantWithCondition(
        address _where,
        address _who,
        bytes32 _permissionId,
        IPermissionCondition _condition
    ) external virtual auth(ROOT_PERMISSION_ID) {
        _grantWithCondition({
            _where: _where,
            _who: _who,
            _permissionId: _permissionId,
            _condition: _condition
        });
    }

    /// @notice Revokes permission from an address to call methods in a target contract guarded by an auth modifier with the specified permission identifier.
    /// @dev Requires the `ROOT_PERMISSION_ID` permission.
    /// @param _where The address of the target contract for which `_who` loses permission.
    /// @param _who The address (EOA or contract) losing the permission.
    /// @param _permissionId The permission identifier.
    /// @dev Note, that revoking permissions with `_who` or `_where` equal to `ANY_ADDR` does not revoke other permissions with specific `_who` and `_where` addresses that exist in parallel.
    function revoke(
        address _where,
        address _who,
        bytes32 _permissionId
    ) external virtual auth(ROOT_PERMISSION_ID) {
        _revoke({_where: _where, _who: _who, _permissionId: _permissionId});
    }

    /// @notice Applies an array of permission operations on a single target contracts `_where`.
    /// @param _where The address of the single target contract.
    /// @param items The array of single-targeted permission operations to apply.
    function applySingleTargetPermissions(
        address _where,
        PermissionLib.SingleTargetPermission[] calldata items
    ) external virtual auth(ROOT_PERMISSION_ID) {
        for (uint256 i; i < items.length; ) {
            PermissionLib.SingleTargetPermission memory item = items[i];

            if (item.operation == PermissionLib.Operation.Grant) {
                _grant({_where: _where, _who: item.who, _permissionId: item.permissionId});
            } else if (item.operation == PermissionLib.Operation.Revoke) {
                _revoke({_where: _where, _who: item.who, _permissionId: item.permissionId});
            } else if (item.operation == PermissionLib.Operation.GrantWithCondition) {
                revert GrantWithConditionNotSupported();
            }

            unchecked {
                ++i;
            }
        }
    }

    /// @notice Applies an array of permission operations on multiple target contracts `items[i].where`.
    /// @param _items The array of multi-targeted permission operations to apply.
    function applyMultiTargetPermissions(
        PermissionLib.MultiTargetPermission[] calldata _items
    ) external virtual auth(ROOT_PERMISSION_ID) {
        for (uint256 i; i < _items.length; ) {
            PermissionLib.MultiTargetPermission memory item = _items[i];

            if (item.operation == PermissionLib.Operation.Grant) {
                // Ensure a non-zero condition isn't passed, as `_grant` can't handle conditions.
                // This avoids the false impression that a conditional grant occurred,
                // since the transaction would still succeed without conditions.
                if (item.condition != address(0)) {
                    revert GrantWithConditionNotSupported();
                }
                _grant({_where: item.where, _who: item.who, _permissionId: item.permissionId});
            } else if (item.operation == PermissionLib.Operation.Revoke) {
                _revoke({_where: item.where, _who: item.who, _permissionId: item.permissionId});
            } else if (item.operation == PermissionLib.Operation.GrantWithCondition) {
                _grantWithCondition({
                    _where: item.where,
                    _who: item.who,
                    _permissionId: item.permissionId,
                    _condition: IPermissionCondition(item.condition)
                });
            }

            unchecked {
                ++i;
            }
        }
    }

    /// @notice Checks if the caller address has permission on the target contract via a permission identifier and relays the answer to a condition contract if this was declared during the granting process.
    /// @param _where The address of the target contract for which `_who` receives permission.
    /// @param _who The address (EOA or contract) for which the permission is checked.
    /// @param _permissionId The permission identifier.
    /// @param _data Optional data to be passed to the set `PermissionCondition`.
    /// @return Returns true if `_who` has the permissions on the target contract via the specified permission identifier.
    function isGranted(
        address _where,
        address _who,
        bytes32 _permissionId,
        bytes memory _data
    ) public view virtual returns (bool) {
        // Specific caller (`_who`) and target (`_where`) permission check
        {
            // This permission may have been granted directly via the `grant` function or with a condition via the `grantWithCondition` function.
            address specificCallerTargetPermission = permissionsHashed[
                permissionHash({_where: _where, _who: _who, _permissionId: _permissionId})
            ];

            // If the permission was granted directly, return `true`.
            if (specificCallerTargetPermission == ALLOW_FLAG) return true;

            // If the permission was granted with a condition, check the condition and return the result.
            if (specificCallerTargetPermission != UNSET_FLAG) {
                return
                    _checkCondition({
                        _condition: specificCallerTargetPermission,
                        _where: _where,
                        _who: _who,
                        _permissionId: _permissionId,
                        _data: _data
                    });
            }

            // If this permission is not set, continue.
        }

        // Generic caller (`_who: ANY_ADDR`)
        {
            address genericCallerPermission = permissionsHashed[
                permissionHash({_where: _where, _who: ANY_ADDR, _permissionId: _permissionId})
            ];

            // If the permission was granted directly to (`_who: ANY_ADDR`), return `true`.
            if (genericCallerPermission == ALLOW_FLAG) return true;

            // If the permission was granted with a condition, check the condition and return the result.
            if (genericCallerPermission != UNSET_FLAG) {
                return
                    _checkCondition({
                        _condition: genericCallerPermission,
                        _where: _where,
                        _who: _who,
                        _permissionId: _permissionId,
                        _data: _data
                    });
            }
            // If this permission is not set, continue.
        }

        // Generic target (`_where: ANY_ADDR`) condition check
        {
            // This permission can only be granted in conjunction with a condition via the `grantWithCondition` function.
            address genericTargetPermission = permissionsHashed[
                permissionHash({_where: ANY_ADDR, _who: _who, _permissionId: _permissionId})
            ];

            // If the permission was granted with a condition, check the condition and return the result.
            if (genericTargetPermission != UNSET_FLAG) {
                return
                    _checkCondition({
                        _condition: genericTargetPermission,
                        _where: _where,
                        _who: _who,
                        _permissionId: _permissionId,
                        _data: _data
                    });
            }
            // If this permission is not set, continue.
        }

        // No specific or generic permission applies to the `_who`, `_where`, `_permissionId`, so we return `false`.
        return false;
    }

    /// @notice Relays the question if caller address has permission on target contract via a permission identifier to a condition contract.
    /// @notice Checks a condition contract by doing an external call via try/catch.
    /// @param _condition The condition contract that is called.
    /// @param _where The address of the target contract for which `_who` receives permission.
    /// @param _who The address (EOA or contract) owning the permission.
    /// @param _permissionId The permission identifier.
    /// @param _data Optional data to be passed to a referenced `PermissionCondition`.
    /// @return Returns `true` if a caller (`_who`) has the permissions on the contract (`_where`) via the specified permission identifier.
    /// @dev If the external call fails, we return `false`.
    function _checkCondition(
        address _condition,
        address _where,
        address _who,
        bytes32 _permissionId,
        bytes memory _data
    ) internal view virtual returns (bool) {
        // Try-catch to skip failures
        try
            IPermissionCondition(_condition).isGranted({
                _where: _where,
                _who: _who,
                _permissionId: _permissionId,
                _data: _data
            })
        returns (bool result) {
            if (result) {
                return true;
            }
        } catch {}
        return false;
    }

    /// @notice Grants the `ROOT_PERMISSION_ID` permission to the initial owner during initialization of the permission manager.
    /// @param _initialOwner The initial owner of the permission manager.
    function _initializePermissionManager(address _initialOwner) internal {
        _grant({_where: address(this), _who: _initialOwner, _permissionId: ROOT_PERMISSION_ID});
    }

    /// @notice This method is used in the external `grant` method of the permission manager.
    /// @param _where The address of the target contract for which `_who` receives permission.
    /// @param _who The address (EOA or contract) owning the permission.
    /// @param _permissionId The permission identifier.
    /// @dev Note, that granting permissions with `_who` or `_where` equal to `ANY_ADDR` does not replace other permissions with specific `_who` and `_where` addresses that exist in parallel.
    function _grant(address _where, address _who, bytes32 _permissionId) internal virtual {
        if (_where == ANY_ADDR) {
            revert PermissionsForAnyAddressDisallowed();
        }

        if (_who == ANY_ADDR) {
            if (
                _permissionId == ROOT_PERMISSION_ID ||
                isPermissionRestrictedForAnyAddr(_permissionId)
            ) {
                revert PermissionsForAnyAddressDisallowed();
            }
        }

        bytes32 permHash = permissionHash({
            _where: _where,
            _who: _who,
            _permissionId: _permissionId
        });

        address currentFlag = permissionsHashed[permHash];

        // Means permHash is not currently set.
        if (currentFlag == UNSET_FLAG) {
            permissionsHashed[permHash] = ALLOW_FLAG;

            emit Granted({
                permissionId: _permissionId,
                here: msg.sender,
                where: _where,
                who: _who,
                condition: ALLOW_FLAG
            });
        }
    }

    /// @notice This method is used in the external `grantWithCondition` method of the permission manager.
    /// @param _where The address of the target contract for which `_who` receives permission.
    /// @param _who The address (EOA or contract) owning the permission.
    /// @param _permissionId The permission identifier.
    /// @param _condition An address either resolving to a `PermissionCondition` contract address or being the `ALLOW_FLAG` address (`address(2)`).
    /// @dev Note, that granting permissions with `_who` or `_where` equal to `ANY_ADDR` does not replace other permissions with specific `_who` and `_where` addresses that exist in parallel.
    function _grantWithCondition(
        address _where,
        address _who,
        bytes32 _permissionId,
        IPermissionCondition _condition
    ) internal virtual {
        address conditionAddr = address(_condition);

        if (!conditionAddr.isContract()) {
            revert ConditionNotAContract(_condition);
        }

        if (
            !PermissionCondition(conditionAddr).supportsInterface(
                type(IPermissionCondition).interfaceId
            )
        ) {
            revert ConditionInterfaceNotSupported(_condition);
        }

        if (_where == ANY_ADDR && _who == ANY_ADDR) {
            revert AnyAddressDisallowedForWhoAndWhere();
        }

        if (_where == ANY_ADDR || _who == ANY_ADDR) {
            if (
                _permissionId == ROOT_PERMISSION_ID ||
                isPermissionRestrictedForAnyAddr(_permissionId)
            ) {
                revert PermissionsForAnyAddressDisallowed();
            }
        }

        bytes32 permHash = permissionHash({
            _where: _where,
            _who: _who,
            _permissionId: _permissionId
        });

        address currentCondition = permissionsHashed[permHash];

        // Means permHash is not currently set.
        if (currentCondition == UNSET_FLAG) {
            permissionsHashed[permHash] = conditionAddr;

            emit Granted({
                permissionId: _permissionId,
                here: msg.sender,
                where: _where,
                who: _who,
                condition: conditionAddr
            });
        } else if (currentCondition != conditionAddr) {
            // Revert if `permHash` is already granted, but uses a different condition.
            // If we don't revert, we either should:
            //   - allow overriding the condition on the same permission
            //     which could be confusing whoever granted the same permission first
            //   - or do nothing and succeed silently which could be confusing for the caller.
            revert PermissionAlreadyGrantedForDifferentCondition({
                where: _where,
                who: _who,
                permissionId: _permissionId,
                currentCondition: currentCondition,
                newCondition: conditionAddr
            });
        }
    }

    /// @notice This method is used in the public `revoke` method of the permission manager.
    /// @param _where The address of the target contract for which `_who` receives permission.
    /// @param _who The address (EOA or contract) owning the permission.
    /// @param _permissionId The permission identifier.
    /// @dev Note, that revoking permissions with `_who` or `_where` equal to `ANY_ADDR` does not revoke other permissions with specific `_who` and `_where` addresses that might have been granted in parallel.
    function _revoke(address _where, address _who, bytes32 _permissionId) internal virtual {
        bytes32 permHash = permissionHash({
            _where: _where,
            _who: _who,
            _permissionId: _permissionId
        });
        if (permissionsHashed[permHash] != UNSET_FLAG) {
            permissionsHashed[permHash] = UNSET_FLAG;

            emit Revoked({permissionId: _permissionId, here: msg.sender, where: _where, who: _who});
        }
    }

    /// @notice A private function to be used to check permissions on the permission manager contract (`address(this)`) itself.
    /// @param _permissionId The permission identifier required to call the method this modifier is applied to.
    function _auth(bytes32 _permissionId) internal view virtual {
        if (!isGranted(address(this), msg.sender, _permissionId, msg.data)) {
            revert Unauthorized({
                where: address(this),
                who: msg.sender,
                permissionId: _permissionId
            });
        }
    }

    /// @notice Generates the hash for the `permissionsHashed` mapping obtained from the word "PERMISSION", the contract address, the address owning the permission, and the permission identifier.
    /// @param _where The address of the target contract for which `_who` receives permission.
    /// @param _who The address (EOA or contract) owning the permission.
    /// @param _permissionId The permission identifier.
    /// @return The permission hash.
    function permissionHash(
        address _where,
        address _who,
        bytes32 _permissionId
    ) internal pure virtual returns (bytes32) {
        return keccak256(abi.encodePacked("PERMISSION", _who, _where, _permissionId));
    }

    /// @notice Decides if the granting permissionId is restricted when `_who == ANY_ADDR` or `_where == ANY_ADDR`.
    /// @param _permissionId The permission identifier.
    /// @return Whether or not the permission is restricted.
    /// @dev By default, every permission is unrestricted and it is the derived contract's responsibility to override it. Note, that the `ROOT_PERMISSION_ID` is included and not required to be set it again.
    function isPermissionRestrictedForAnyAddr(
        bytes32 _permissionId
    ) internal view virtual returns (bool) {
        (_permissionId); // silence the warning.
        return false;
    }

    /// @notice This empty reserved space is put in place to allow future versions to add new variables without shifting down storage in the inheritance chain (see [OpenZeppelin's guide about storage gaps](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps)).
    uint256[49] private __gap;
}

// lib/ens-contracts/contracts/resolvers/Resolver.sol

/**
 * A generic resolver interface which includes all the functions including the ones deprecated
 */
interface Resolver is
    IERC165,
    IABIResolver,
    IAddressResolver,
    IAddrResolver,
    IContentHashResolver,
    IDNSRecordResolver,
    IDNSZoneResolver,
    IInterfaceResolver,
    INameResolver,
    IPubkeyResolver,
    ITextResolver,
    IExtendedResolver
{
    /* Deprecated events */
    event ContentChanged(bytes32 indexed node, bytes32 hash);

    function setABI(
        bytes32 node,
        uint256 contentType,
        bytes calldata data
    ) external;

    function setAddr(bytes32 node, address addr) external;

    function setAddr(bytes32 node, uint256 coinType, bytes calldata a) external;

    function setContenthash(bytes32 node, bytes calldata hash) external;

    function setDnsrr(bytes32 node, bytes calldata data) external;

    function setName(bytes32 node, string calldata _name) external;

    function setPubkey(bytes32 node, bytes32 x, bytes32 y) external;

    function setText(
        bytes32 node,
        string calldata key,
        string calldata value
    ) external;

    function setInterface(
        bytes32 node,
        bytes4 interfaceID,
        address implementer
    ) external;

    function multicall(
        bytes[] calldata data
    ) external returns (bytes[] memory results);

    function multicallWithNodeCheck(
        bytes32 nodehash,
        bytes[] calldata data
    ) external returns (bytes[] memory results);

    /* Deprecated functions */
    function content(bytes32 node) external view returns (bytes32);

    function multihash(bytes32 node) external view returns (bytes memory);

    function setContent(bytes32 node, bytes32 hash) external;

    function setMultihash(bytes32 node, bytes calldata hash) external;
}

// lib/osx/packages/contracts/src/framework/utils/InterfaceBasedRegistry.sol

/// @title InterfaceBasedRegistry
/// @author Aragon X - 2022-2023
/// @notice An [ERC-165](https://eips.ethereum.org/EIPS/eip-165)-based registry for contracts.
/// @custom:security-contact sirt@aragon.org
abstract contract InterfaceBasedRegistry is UUPSUpgradeable, DaoAuthorizableUpgradeable {
    using ERC165CheckerUpgradeable for address;

    /// @notice The ID of the permission required to call the `_authorizeUpgrade` function.
    bytes32 public constant UPGRADE_REGISTRY_PERMISSION_ID =
        keccak256("UPGRADE_REGISTRY_PERMISSION");

    /// @notice The [ERC-165](https://eips.ethereum.org/EIPS/eip-165) interface ID that the target contracts being registered must support.
    bytes4 public targetInterfaceId;

    /// @notice The mapping containing the registry entries returning true for registered contract addresses.
    mapping(address => bool) public entries;

    /// @notice Thrown if the contract is already registered.
    /// @param registrant The address of the contract to be registered.
    error ContractAlreadyRegistered(address registrant);

    /// @notice Thrown if the contract does not support the required interface.
    /// @param registrant The address of the contract to be registered.
    error ContractInterfaceInvalid(address registrant);

    /// @notice Thrown if the contract does not support ERC165.
    /// @param registrant The address of the contract.
    error ContractERC165SupportInvalid(address registrant);

    /// @notice Initializes the component.
    /// @dev This is required for the UUPS upgradeability pattern.
    /// @param _managingDao The interface of the DAO managing the components permissions.
    /// @param _targetInterfaceId The [ERC-165](https://eips.ethereum.org/EIPS/eip-165) interface id of the contracts to be registered.
    function __InterfaceBasedRegistry_init(
        IDAO _managingDao,
        bytes4 _targetInterfaceId
    ) internal virtual onlyInitializing {
        __DaoAuthorizableUpgradeable_init(_managingDao);

        targetInterfaceId = _targetInterfaceId;
    }

    /// @notice Internal method authorizing the upgrade of the contract via the [upgradeability mechanism for UUPS proxies](https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable) (see [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822)).
    /// @dev The caller must have the `UPGRADE_REGISTRY_PERMISSION_ID` permission.
    function _authorizeUpgrade(
        address
    ) internal virtual override auth(UPGRADE_REGISTRY_PERMISSION_ID) {}

    /// @notice Register an [ERC-165](https://eips.ethereum.org/EIPS/eip-165) contract address.
    /// @dev The managing DAO needs to grant REGISTER_PERMISSION_ID to registrar.
    /// @param _registrant The address of an [ERC-165](https://eips.ethereum.org/EIPS/eip-165) contract.
    function _register(address _registrant) internal {
        if (entries[_registrant]) {
            revert ContractAlreadyRegistered({registrant: _registrant});
        }

        // Will revert if address is not a contract or doesn't fully support targetInterfaceId + ERC165.
        if (!_registrant.supportsInterface(targetInterfaceId)) {
            revert ContractInterfaceInvalid(_registrant);
        }

        entries[_registrant] = true;
    }

    /// @notice This empty reserved space is put in place to allow future versions to add new variables without shifting down storage in the inheritance chain (see [OpenZeppelin's guide about storage gaps](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps)).
    uint256[48] private __gap;
}

// lib/osx-commons/contracts/src/plugin/PluginUUPSUpgradeable.sol

/// @title PluginUUPSUpgradeable
/// @author Aragon X - 2022-2024
/// @notice An abstract, upgradeable contract to inherit from when creating a plugin being deployed via the UUPS pattern (see [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822)).
/// @custom:security-contact sirt@aragon.org
abstract contract PluginUUPSUpgradeable is
    IPlugin,
    ERC165Upgradeable,
    UUPSUpgradeable,
    DaoAuthorizableUpgradeable,
    ProtocolVersion
{
    using ERC165CheckerUpgradeable for address;

    // NOTE: When adding new state variables to the contract, the size of `_gap` has to be adapted below as well.

    /// @notice Stores the current target configuration, defining the target contract and operation type for a plugin.
    TargetConfig private currentTargetConfig;

    /// @notice Thrown when target is of type 'IDAO', but operation is `delegateCall`.
    /// @param targetConfig The target config to update it to.
    error InvalidTargetConfig(TargetConfig targetConfig);

    /// @notice Thrown when `delegatecall` fails.
    error DelegateCallFailed();

    /// @notice Thrown when initialize is called after it has already been executed.
    error AlreadyInitialized();

    /// @notice Emitted each time the TargetConfig is set.
    event TargetSet(TargetConfig newTargetConfig);

    /// @notice The ID of the permission required to call the `setTargetConfig` function.
    bytes32 public constant SET_TARGET_CONFIG_PERMISSION_ID =
        keccak256("SET_TARGET_CONFIG_PERMISSION");

    /// @notice The ID of the permission required to call the `_authorizeUpgrade` function.
    bytes32 public constant UPGRADE_PLUGIN_PERMISSION_ID = keccak256("UPGRADE_PLUGIN_PERMISSION");

    /// @notice Disables the initializers on the implementation contract to prevent it from being left uninitialized.
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @notice This ensures that the initialize function cannot be called during the upgrade process.
    modifier onlyCallAtInitialization() {
        if (_getInitializedVersion() != 0) {
            revert AlreadyInitialized();
        }

        _;
    }

    /// @inheritdoc IPlugin
    function pluginType() public pure override returns (PluginType) {
        return PluginType.UUPS;
    }

    /// @notice Returns the currently set target contract.
    /// @return TargetConfig The currently set target.
    function getCurrentTargetConfig() public view virtual returns (TargetConfig memory) {
        return currentTargetConfig;
    }

    /// @notice A convenient function to get current target config only if its target is not address(0), otherwise dao().
    /// @return TargetConfig The current target config if its target is not address(0), otherwise returns dao()."
    function getTargetConfig() public view virtual returns (TargetConfig memory) {
        TargetConfig memory targetConfig = currentTargetConfig;

        if (targetConfig.target == address(0)) {
            targetConfig = TargetConfig({target: address(dao()), operation: Operation.Call});
        }

        return targetConfig;
    }

    /// @notice Initializes the plugin by storing the associated DAO.
    /// @param _dao The DAO contract.
    // solhint-disable-next-line func-name-mixedcase
    function __PluginUUPSUpgradeable_init(IDAO _dao) internal virtual onlyInitializing {
        __DaoAuthorizableUpgradeable_init(_dao);
    }

    /// @dev Sets the target to a new target (`newTarget`).
    ///      The caller must have the `SET_TARGET_CONFIG_PERMISSION_ID` permission.
    /// @param _targetConfig The target Config containing the address and operation type.
    function setTargetConfig(
        TargetConfig calldata _targetConfig
    ) public auth(SET_TARGET_CONFIG_PERMISSION_ID) {
        _setTargetConfig(_targetConfig);
    }

    /// @notice Checks if an interface is supported by this or its parent contract.
    /// @param _interfaceId The ID of the interface.
    /// @return Returns `true` if the interface is supported.
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return
            _interfaceId == type(IPlugin).interfaceId ||
            _interfaceId == type(IProtocolVersion).interfaceId ||
            _interfaceId == type(IERC1822ProxiableUpgradeable).interfaceId ||
            _interfaceId ==
            this.setTargetConfig.selector ^
                this.getTargetConfig.selector ^
                this.getCurrentTargetConfig.selector ||
            super.supportsInterface(_interfaceId);
    }

    /// @notice Returns the address of the implementation contract in the [proxy storage slot](https://eips.ethereum.org/EIPS/eip-1967) slot the [UUPS proxy](https://eips.ethereum.org/EIPS/eip-1822) is pointing to.
    /// @return The address of the implementation contract.
    function implementation() public view returns (address) {
        return _getImplementation();
    }

    /// @notice Sets the target to a new target (`newTarget`).
    /// @param _targetConfig The target Config containing the address and operation type.
    function _setTargetConfig(TargetConfig memory _targetConfig) internal virtual {
        // safety check to avoid setting dao as `target` with `delegatecall` operation
        // as this would not work and cause the plugin to be bricked.
        if (
            _targetConfig.target.supportsInterface(type(IDAO).interfaceId) &&
            _targetConfig.operation == Operation.DelegateCall
        ) {
            revert InvalidTargetConfig(_targetConfig);
        }

        currentTargetConfig = _targetConfig;

        emit TargetSet(_targetConfig);
    }

    /// @notice Forwards the actions to the currently set `target` for the execution.
    /// @dev If target is not set, passes actions to the dao.
    /// @param _callId Identifier for this execution.
    /// @param _actions actions that will be eventually called.
    /// @param _allowFailureMap Bitmap-encoded number.
    /// @return execResults address of the implementation contract.
    /// @return failureMap address of the implementation contract.
    function _execute(
        bytes32 _callId,
        Action[] memory _actions,
        uint256 _allowFailureMap
    ) internal virtual returns (bytes[] memory execResults, uint256 failureMap) {
        TargetConfig memory targetConfig = getTargetConfig();

        return
            _execute(
                targetConfig.target,
                _callId,
                _actions,
                _allowFailureMap,
                targetConfig.operation
            );
    }

    /// @notice Forwards the actions to the `target` for the execution.
    /// @param _target The address of the target contract.
    /// @param _callId Identifier for this execution.
    /// @param _actions actions that will be eventually called.
    /// @param _allowFailureMap A bitmap allowing the execution to succeed, even if individual actions might revert.
    ///     If the bit at index `i` is 1, the execution succeeds even if the `i`th action reverts.
    ///     A failure map value of 0 requires every action to not revert.
    /// @param _op The type of operation (`Call` or `DelegateCall`) to be used for the execution.
    /// @return execResults address of the implementation contract.
    /// @return failureMap address of the implementation contract.
    function _execute(
        address _target,
        bytes32 _callId,
        Action[] memory _actions,
        uint256 _allowFailureMap,
        Operation _op
    ) internal virtual returns (bytes[] memory execResults, uint256 failureMap) {
        if (_op == Operation.DelegateCall) {
            bool success;
            bytes memory data;

            // solhint-disable-next-line avoid-low-level-calls
            (success, data) = _target.delegatecall(
                abi.encodeCall(IExecutor.execute, (_callId, _actions, _allowFailureMap))
            );

            if (!success) {
                if (data.length > 0) {
                    // solhint-disable-next-line no-inline-assembly
                    assembly {
                        let returndata_size := mload(data)
                        revert(add(32, data), returndata_size)
                    }
                } else {
                    revert DelegateCallFailed();
                }
            }
            (execResults, failureMap) = abi.decode(data, (bytes[], uint256));
        } else {
            (execResults, failureMap) = IExecutor(_target).execute(
                _callId,
                _actions,
                _allowFailureMap
            );
        }
    }

    /// @notice Internal method authorizing the upgrade of the contract via the [upgradeability mechanism for UUPS proxies](https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable) (see [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822)).
    /// @dev The caller must have the `UPGRADE_PLUGIN_PERMISSION_ID` permission.
    function _authorizeUpgrade(
        address
    )
        internal
        virtual
        override
        auth(UPGRADE_PLUGIN_PERMISSION_ID)
    // solhint-disable-next-line no-empty-blocks
    {

    }

    /// @notice This empty reserved space is put in place to allow future versions to add new variables without shifting down storage in the inheritance chain (see [OpenZeppelin's guide about storage gaps](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps)).
    uint256[49] private __gap;
}

// lib/osx/packages/contracts/src/framework/plugin/repo/PluginRepo.sol

/// @title PluginRepo
/// @author Aragon X - 2020 - 2023
/// @notice The plugin repository contract required for managing and publishing different plugin versions within the Aragon DAO framework.
/// @custom:security-contact sirt@aragon.org
contract PluginRepo is
    Initializable,
    ERC165Upgradeable,
    IPluginRepo,
    UUPSUpgradeable,
    ProtocolVersion,
    PermissionManager
{
    using AddressUpgradeable for address;
    using ERC165CheckerUpgradeable for address;

    /// @notice The struct describing the tag of a version obtained by a release and build number as `RELEASE.BUILD`.
    /// @param release The release number.
    /// @param build The build number
    /// @dev Releases mark incompatible changes (e.g., the plugin interface, storage layout, or incompatible behavior) whereas builds mark compatible changes (e.g., patches and compatible feature additions).
    struct Tag {
        uint8 release;
        uint16 build;
    }

    /// @notice The struct describing a plugin version (release and build).
    /// @param tag The version tag.
    /// @param pluginSetup The setup contract associated with this version.
    /// @param buildMetadata The build metadata URI.
    struct Version {
        Tag tag;
        address pluginSetup;
        bytes buildMetadata;
    }

    /// @notice The ID of the permission required to call the `createVersion` function.
    bytes32 public constant MAINTAINER_PERMISSION_ID = keccak256("MAINTAINER_PERMISSION");

    /// @notice The ID of the permission required to call the `createVersion` function.
    bytes32 public constant UPGRADE_REPO_PERMISSION_ID = keccak256("UPGRADE_REPO_PERMISSION");

    /// @notice The mapping between release and build numbers.
    mapping(uint8 => uint16) internal buildsPerRelease;

    /// @notice The mapping between the version hash and the corresponding version information.
    mapping(bytes32 => Version) internal versions;

    /// @notice The mapping between the plugin setup address and its corresponding version hash.
    mapping(address => bytes32) internal latestTagHashForPluginSetup;

    /// @notice The ID of the latest release.
    /// @dev The maximum release number is 255.
    uint8 public latestRelease;

    /// @notice Thrown if a version does not exist.
    /// @param versionHash The tag hash.
    error VersionHashDoesNotExist(bytes32 versionHash);

    /// @notice Thrown if a plugin setup contract does not inherit from `PluginSetup`.
    error InvalidPluginSetupInterface();

    /// @notice Thrown if a release number is zero.
    error ReleaseZeroNotAllowed();

    /// @notice Thrown if a release number is incremented by more than one.
    /// @param latestRelease The latest release number.
    /// @param newRelease The new release number.
    error InvalidReleaseIncrement(uint8 latestRelease, uint8 newRelease);

    /// @notice Thrown if the same plugin setup contract exists already in a previous releases.
    /// @param release The release number of the already existing plugin setup.
    /// @param build The build number of the already existing plugin setup.
    /// @param pluginSetup The plugin setup contract address.
    error PluginSetupAlreadyInPreviousRelease(uint8 release, uint16 build, address pluginSetup);

    /// @notice Thrown if the metadata URI is empty.
    error EmptyReleaseMetadata();

    /// @notice Thrown if release does not exist.
    error ReleaseDoesNotExist();

    /// @dev Used to disallow initializing the implementation contract by an attacker for extra safety.
    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes the contract by
    /// - initializing the permission manager
    /// - granting the `MAINTAINER_PERMISSION_ID` permission to the initial owner.
    /// @dev This method is required to support [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822).
    function initialize(address initialOwner) external initializer {
        __PermissionManager_init(initialOwner);

        _grant(address(this), initialOwner, MAINTAINER_PERMISSION_ID);
        _grant(address(this), initialOwner, UPGRADE_REPO_PERMISSION_ID);
    }

    /// @notice Initializes the pluginRepo after an upgrade from a previous protocol version.
    /// @param _previousProtocolVersion The semantic protocol version number of the previous DAO implementation contract this upgrade is transitioning from.
    /// @param _initData The initialization data to be passed to via `upgradeToAndCall` (see [ERC-1967](https://docs.openzeppelin.com/contracts/4.x/api/proxy#ERC1967Upgrade)).
    /// @dev This function is a placeholder until we require reinitialization.
    function initializeFrom(
        uint8[3] calldata _previousProtocolVersion,
        bytes calldata _initData
    ) external reinitializer(2) {
        // Silences the unused function parameter warning.
        _previousProtocolVersion;
        _initData;

        // Revert because this is a placeholder until this contract requires reinitialization.
        revert();
    }

    /// @inheritdoc IPluginRepo
    function createVersion(
        uint8 _release,
        address _pluginSetup,
        bytes calldata _buildMetadata,
        bytes calldata _releaseMetadata
    ) external auth(MAINTAINER_PERMISSION_ID) {
        if (!_pluginSetup.supportsInterface(type(IPluginSetup).interfaceId)) {
            revert InvalidPluginSetupInterface();
        }

        if (_release == 0) {
            revert ReleaseZeroNotAllowed();
        }

        // Check that the release number is not incremented by more than one
        if (_release - latestRelease > 1) {
            revert InvalidReleaseIncrement({latestRelease: latestRelease, newRelease: _release});
        }

        if (_release > latestRelease) {
            latestRelease = _release;

            if (_releaseMetadata.length == 0) {
                revert EmptyReleaseMetadata();
            }
        }

        // Make sure the same plugin setup wasn't used in previous releases.
        Version storage version = versions[latestTagHashForPluginSetup[_pluginSetup]];
        if (version.tag.release != 0 && version.tag.release != _release) {
            revert PluginSetupAlreadyInPreviousRelease(
                version.tag.release,
                version.tag.build,
                _pluginSetup
            );
        }

        uint16 build = ++buildsPerRelease[_release];

        Tag memory tag = Tag(_release, build);
        bytes32 _tagHash = tagHash(tag);

        versions[_tagHash] = Version(tag, _pluginSetup, _buildMetadata);

        latestTagHashForPluginSetup[_pluginSetup] = _tagHash;

        emit VersionCreated({
            release: _release,
            build: build,
            pluginSetup: _pluginSetup,
            buildMetadata: _buildMetadata
        });

        if (_releaseMetadata.length > 0) {
            emit ReleaseMetadataUpdated(_release, _releaseMetadata);
        }
    }

    /// @inheritdoc IPluginRepo
    function updateReleaseMetadata(
        uint8 _release,
        bytes calldata _releaseMetadata
    ) external auth(MAINTAINER_PERMISSION_ID) {
        if (_release == 0) {
            revert ReleaseZeroNotAllowed();
        }

        if (_release > latestRelease) {
            revert ReleaseDoesNotExist();
        }

        if (_releaseMetadata.length == 0) {
            revert EmptyReleaseMetadata();
        }

        emit ReleaseMetadataUpdated(_release, _releaseMetadata);
    }

    /// @notice Returns the latest version for a given release number.
    /// @param _release The release number.
    /// @return The latest version of this release.
    function getLatestVersion(uint8 _release) public view returns (Version memory) {
        uint16 latestBuild = uint16(buildsPerRelease[_release]);
        return getVersion(tagHash(Tag(_release, latestBuild)));
    }

    /// @notice Returns the latest version for a given plugin setup.
    /// @param _pluginSetup The plugin setup address
    /// @return The latest version associated with the plugin Setup.
    function getLatestVersion(address _pluginSetup) public view returns (Version memory) {
        return getVersion(latestTagHashForPluginSetup[_pluginSetup]);
    }

    /// @notice Returns the version associated with a tag.
    /// @param _tag The version tag.
    /// @return The version associated with the tag.
    function getVersion(Tag calldata _tag) public view returns (Version memory) {
        return getVersion(tagHash(_tag));
    }

    /// @notice Returns the version for a tag hash.
    /// @param _tagHash The tag hash.
    /// @return The version associated with a tag hash.
    function getVersion(bytes32 _tagHash) public view returns (Version memory) {
        Version storage version = versions[_tagHash];

        if (version.tag.release == 0) {
            revert VersionHashDoesNotExist(_tagHash);
        }

        return version;
    }

    /// @notice Gets the total number of builds for a given release number.
    /// @param _release The release number.
    /// @return The number of builds of this release.
    function buildCount(uint8 _release) public view returns (uint256) {
        return buildsPerRelease[_release];
    }

    /// @notice The hash of the version tag obtained from the packed, bytes-encoded release and build number.
    /// @param _tag The version tag.
    /// @return The version tag hash.
    function tagHash(Tag memory _tag) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(_tag.release, _tag.build));
    }

    /// @notice Internal method authorizing the upgrade of the contract via the [upgradeability mechanism for UUPS proxies](https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable) (see [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822)).
    /// @dev The caller must have the `UPGRADE_REPO_PERMISSION_ID` permission.
    function _authorizeUpgrade(
        address
    ) internal virtual override auth(UPGRADE_REPO_PERMISSION_ID) {}

    /// @notice Checks if this or the parent contract supports an interface by its ID.
    /// @param _interfaceId The ID of the interface.
    /// @return Returns `true` if the interface is supported.
    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return
            _interfaceId == type(IPluginRepo).interfaceId ||
            _interfaceId == type(IProtocolVersion).interfaceId ||
            super.supportsInterface(_interfaceId);
    }

    /// @notice This empty reserved space is put in place to allow future versions to add new variables without shifting down storage in the inheritance chain (see [OpenZeppelin's guide about storage gaps](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps)).
    uint256[46] private __gap;
}

// lib/osx/packages/contracts/src/framework/plugin/setup/PluginSetupProcessorHelpers.sol

/// @notice The struct containing a reference to a plugin setup by specifying the containing plugin repository and the associated version tag.
/// @param versionTag The tag associated with the plugin setup version.
/// @param pluginSetupRepo The plugin setup repository.
struct PluginSetupRef {
    PluginRepo.Tag versionTag;
    PluginRepo pluginSetupRepo;
}

/// @notice The different types describing a prepared setup.
/// @param None The default indicating the lack of a preparation type.
/// @param Installation The prepared setup installs a new plugin.
/// @param Update The prepared setup updates an existing plugin.
/// @param Uninstallation The prepared setup uninstalls an existing plugin.
enum PreparationType {
    None,
    Installation,
    Update,
    Uninstallation
}

/// @notice Returns an ID for plugin installation by hashing the DAO and plugin address.
/// @param _dao The address of the DAO conducting the setup.
/// @param _plugin The plugin address.
/// @custom:security-contact sirt@aragon.org
function _getPluginInstallationId(address _dao, address _plugin) pure returns (bytes32) {
    return keccak256(abi.encode(_dao, _plugin));
}

/// @notice Returns an ID for prepared setup obtained from hashing characterizing elements.
/// @param _pluginSetupRef The reference of the plugin setup containing plugin setup repo and version tag.
/// @param _permissionsHash The hash of the permission operations requested by the setup.
/// @param _helpersHash The hash of the helper contract addresses.
/// @param _data The bytes-encoded initialize data for the upgrade that is returned by `prepareUpdate`.
/// @param _preparationType The type of preparation the plugin is currently undergoing. Without this, it is possible to call `applyUpdate` even after `applyInstallation` is called.
/// @return The prepared setup id.
/// @custom:security-contact sirt@aragon.org
function _getPreparedSetupId(
    PluginSetupRef memory _pluginSetupRef,
    bytes32 _permissionsHash,
    bytes32 _helpersHash,
    bytes memory _data,
    PreparationType _preparationType
) pure returns (bytes32) {
    return
        keccak256(
            abi.encode(
                _pluginSetupRef.versionTag,
                _pluginSetupRef.pluginSetupRepo,
                _permissionsHash,
                _helpersHash,
                keccak256(_data),
                _preparationType
            )
        );
}

/// @notice Returns an identifier for applied installations.
/// @param _pluginSetupRef The reference of the plugin setup containing plugin setup repo and version tag.
/// @param _helpersHash The hash of the helper contract addresses.
/// @return The applied setup id.
/// @custom:security-contact sirt@aragon.org
function _getAppliedSetupId(
    PluginSetupRef memory _pluginSetupRef,
    bytes32 _helpersHash
) pure returns (bytes32) {
    return
        keccak256(
            abi.encode(_pluginSetupRef.versionTag, _pluginSetupRef.pluginSetupRepo, _helpersHash)
        );
}

/// @notice Returns a hash of an array of helper addresses (contracts or EOAs).
/// @param _helpers The array of helper addresses (contracts or EOAs) to be hashed.
/// @custom:security-contact sirt@aragon.org
function hashHelpers(address[] memory _helpers) pure returns (bytes32) {
    return keccak256(abi.encode(_helpers));
}

/// @notice Returns a hash of an array of multi-targeted permission operations.
/// @param _permissions The array of of multi-targeted permission operations.
/// @return The hash of the array of permission operations.
/// @custom:security-contact sirt@aragon.org
function hashPermissions(
    PermissionLib.MultiTargetPermission[] memory _permissions
) pure returns (bytes32) {
    return keccak256(abi.encode(_permissions));
}

// lib/osx/packages/contracts/src/framework/utils/ens/ENSSubdomainRegistrar.sol

/// @title ENSSubdomainRegistrar
/// @author Aragon X - 2022-2023
/// @notice This contract registers ENS subdomains under a parent domain specified in the initialization process and maintains ownership of the subdomain since only the resolver address is set. This contract must either be the domain node owner or an approved operator of the node owner. The default resolver being used is the one specified in the parent domain.
/// @custom:security-contact sirt@aragon.org
contract ENSSubdomainRegistrar is UUPSUpgradeable, DaoAuthorizableUpgradeable, ProtocolVersion {
    /// @notice The ID of the permission required to call the `_authorizeUpgrade` function.
    bytes32 public constant UPGRADE_REGISTRAR_PERMISSION_ID =
        keccak256("UPGRADE_REGISTRAR_PERMISSION");

    /// @notice The ID of the permission required to call the `registerSubnode` and `setDefaultResolver` function.
    bytes32 public constant REGISTER_ENS_SUBDOMAIN_PERMISSION_ID =
        keccak256("REGISTER_ENS_SUBDOMAIN_PERMISSION");

    /// @notice The ENS registry contract
    ENS public ens;

    /// @notice The namehash of the domain on which subdomains are registered.
    bytes32 public node;

    /// @notice The address of the ENS resolver resolving the names to an address.
    address public resolver;

    /// @notice Thrown if the subnode is already registered.
    /// @param subnode The subnode namehash.
    /// @param nodeOwner The node owner address.
    error AlreadyRegistered(bytes32 subnode, address nodeOwner);

    /// @notice Thrown if node's resolver is invalid.
    /// @param node The node namehash.
    /// @param resolver The node resolver address.
    error InvalidResolver(bytes32 node, address resolver);

    /// @dev Used to disallow initializing the implementation contract by an attacker for extra safety.
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes the component by
    /// - checking that the contract is the domain node owner or an approved operator
    /// - initializing the underlying component
    /// - registering the [ERC-165](https://eips.ethereum.org/EIPS/eip-165) interface ID
    /// - setting the ENS contract, the domain node hash, and resolver.
    /// @param _managingDao The interface of the DAO managing the components permissions.
    /// @param _ens The interface of the ENS registry to be used.
    /// @param _node The ENS parent domain node under which the subdomains are to be registered.
    function initialize(IDAO _managingDao, ENS _ens, bytes32 _node) external initializer {
        __DaoAuthorizableUpgradeable_init(_managingDao);

        ens = _ens;
        node = _node;

        address nodeResolver = ens.resolver(_node);

        if (nodeResolver == address(0)) {
            revert InvalidResolver({node: _node, resolver: nodeResolver});
        }

        resolver = nodeResolver;
    }

    /// @notice Internal method authorizing the upgrade of the contract via the [upgradeability mechanism for UUPS proxies](https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable) (see [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822)).
    /// @dev The caller must have the `UPGRADE_REGISTRAR_PERMISSION_ID` permission.
    function _authorizeUpgrade(
        address
    ) internal virtual override auth(UPGRADE_REGISTRAR_PERMISSION_ID) {}

    /// @notice Registers a new subdomain with this registrar as the owner and set the target address in the resolver.
    /// @dev It reverts with no message if this contract isn't the owner nor an approved operator for the given node.
    /// @param _label The labelhash of the subdomain name.
    /// @param _targetAddress The address to which the subdomain resolves.
    function registerSubnode(
        bytes32 _label,
        address _targetAddress
    ) external auth(REGISTER_ENS_SUBDOMAIN_PERMISSION_ID) {
        bytes32 subnode = keccak256(abi.encodePacked(node, _label));
        address currentOwner = ens.owner(subnode);

        if (currentOwner != address(0)) {
            revert AlreadyRegistered(subnode, currentOwner);
        }

        ens.setSubnodeOwner(node, _label, address(this));
        ens.setResolver(subnode, resolver);
        Resolver(resolver).setAddr(subnode, _targetAddress);
    }

    /// @notice Sets the default resolver contract address that the subdomains being registered will use.
    /// @param _resolver The resolver contract to be used.
    function setDefaultResolver(
        address _resolver
    ) external auth(REGISTER_ENS_SUBDOMAIN_PERMISSION_ID) {
        if (_resolver == address(0)) {
            revert InvalidResolver({node: node, resolver: _resolver});
        }

        resolver = _resolver;
    }

    /// @notice This empty reserved space is put in place to allow future versions to add new variables without shifting down storage in the inheritance chain (see [OpenZeppelin's guide about storage gaps](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps)).
    uint256[47] private __gap;
}

// lib/osx/packages/contracts/src/core/dao/DAO.sol

/// @title DAO
/// @author Aragon X - 2021-2024
/// @notice This contract is the entry point to the Aragon DAO framework and provides our users a simple and easy to use public interface.
/// @dev Public API of the Aragon DAO framework.
/// @custom:security-contact sirt@aragon.org
contract DAO is
    IEIP4824,
    Initializable,
    IERC1271,
    ERC165StorageUpgradeable,
    IDAO,
    IExecutor,
    UUPSUpgradeable,
    ProtocolVersion,
    PermissionManager,
    CallbackHandler
{
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using AddressUpgradeable for address;
    using VersionComparisonLib for uint8[3];

    /// @notice The ID of the permission required to call the `execute` function.
    bytes32 public constant EXECUTE_PERMISSION_ID = keccak256("EXECUTE_PERMISSION");

    /// @notice The ID of the permission required to call the `_authorizeUpgrade` function.
    bytes32 public constant UPGRADE_DAO_PERMISSION_ID = keccak256("UPGRADE_DAO_PERMISSION");

    /// @notice The ID of the permission required to call the `setMetadata` function.
    bytes32 public constant SET_METADATA_PERMISSION_ID = keccak256("SET_METADATA_PERMISSION");

    /// @notice The ID of the permission required to call the `setTrustedForwarder` function.
    bytes32 public constant SET_TRUSTED_FORWARDER_PERMISSION_ID =
        keccak256("SET_TRUSTED_FORWARDER_PERMISSION");

    /// @notice The ID of the permission required to call the `registerStandardCallback` function.
    bytes32 public constant REGISTER_STANDARD_CALLBACK_PERMISSION_ID =
        keccak256("REGISTER_STANDARD_CALLBACK_PERMISSION");

    /// @notice The ID of the permission required to validate [ERC-1271](https://eips.ethereum.org/EIPS/eip-1271) signatures.
    bytes32 public constant VALIDATE_SIGNATURE_PERMISSION_ID =
        keccak256("VALIDATE_SIGNATURE_PERMISSION");

    /// @notice The internal constant storing the maximal action array length.
    uint256 internal constant MAX_ACTIONS = 256;

    /// @notice The first out of two values to which the `_reentrancyStatus` state variable (used by the `nonReentrant` modifier) can be set indicating that a function was not entered.
    uint256 private constant _NOT_ENTERED = 1;

    /// @notice The second out of two values to which the `_reentrancyStatus` state variable (used by the `nonReentrant` modifier) can be set indicating that a function was entered.
    uint256 private constant _ENTERED = 2;

    /// @notice Removed variable that is left here to maintain the storage layout.
    /// @dev Introduced in v1.0.0. Removed in v1.4.0.
    /// @custom:oz-renamed-from signatureValidator
    address private __removed0;

    /// @notice The address of the trusted forwarder verifying meta transactions.
    /// @dev Added in v1.0.0.
    address private trustedForwarder;

    /// @notice The [EIP-4824](https://eips.ethereum.org/EIPS/eip-4824) DAO URI.
    /// @dev Added in v1.0.0.
    string private _daoURI;

    /// @notice The state variable for the reentrancy guard of the `execute` function.
    /// @dev Added in v1.3.0. The variable can be of value `_NOT_ENTERED = 1` or `_ENTERED = 2` in usage and is initialized with `_NOT_ENTERED`.
    uint256 private _reentrancyStatus;

    /// @notice Thrown if a call is reentrant.
    error ReentrantCall();

    /// @notice Thrown if the action array length is larger than `MAX_ACTIONS`.
    error TooManyActions();

    /// @notice Thrown if action execution has failed.
    /// @param index The index of the action in the action array that failed.
    error ActionFailed(uint256 index);

    /// @notice Thrown if an action has insufficient gas left.
    error InsufficientGas();

    /// @notice Thrown if the deposit amount is zero.
    error ZeroAmount();

    /// @notice Thrown if there is a mismatch between the expected and actually deposited amount of native tokens.
    /// @param expected The expected native token amount.
    /// @param actual The actual native token amount deposited.
    error NativeTokenDepositAmountMismatch(uint256 expected, uint256 actual);

    /// @notice Thrown if an upgrade is not supported from a specific protocol version .
    error ProtocolVersionUpgradeNotSupported(uint8[3] protocolVersion);

    /// @notice Thrown when a function is removed but left to not corrupt the interface ID.
    error FunctionRemoved();

    /// @notice Thrown when initialize is called after it has already been executed.
    error AlreadyInitialized();

    /// @notice Emitted when a new DAO URI is set.
    /// @param daoURI The new URI.
    event NewURI(string daoURI);

    /// @notice A modifier to protect a function from calling itself, directly or indirectly (reentrancy).
    /// @dev Currently, this modifier is only applied to the `execute()` function. If this is used multiple times, private `_beforeNonReentrant()` and `_afterNonReentrant()` functions should be created to prevent code duplication.
    modifier nonReentrant() {
        if (_reentrancyStatus == _ENTERED) {
            revert ReentrantCall();
        }
        _reentrancyStatus = _ENTERED;

        _;

        _reentrancyStatus = _NOT_ENTERED;
    }

    /// @notice This ensures that the initialize function cannot be called during the upgrade process.
    modifier onlyCallAtInitialization() {
        if (_getInitializedVersion() != 0) {
            revert AlreadyInitialized();
        }

        _;
    }

    /// @notice Disables the initializers on the implementation contract to prevent it from being left uninitialized.
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes the DAO by
    /// - setting the reentrancy status variable to `_NOT_ENTERED`
    /// - registering the [ERC-165](https://eips.ethereum.org/EIPS/eip-165) interface ID
    /// - setting the trusted forwarder for meta transactions
    /// - giving the `ROOT_PERMISSION_ID` permission to the initial owner (that should be revoked and transferred to the DAO after setup).
    /// @dev This method is required to support [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822).
    /// @param _metadata IPFS hash that points to all the metadata (logo, description, tags, etc.) of a DAO.
    /// @param _initialOwner The initial owner of the DAO having the `ROOT_PERMISSION_ID` permission.
    /// @param _trustedForwarder The trusted forwarder responsible for verifying meta transactions.
    /// @param daoURI_ The DAO URI required to support [ERC-4824](https://eips.ethereum.org/EIPS/eip-4824).
    function initialize(
        bytes calldata _metadata,
        address _initialOwner,
        address _trustedForwarder,
        string calldata daoURI_
    ) external onlyCallAtInitialization reinitializer(3) {
        _reentrancyStatus = _NOT_ENTERED; // added in v1.3.0

        // In addition to the current interfaceId, also support previous version of the interfaceId.
        _registerInterface(type(IDAO).interfaceId ^ IExecutor.execute.selector);

        _registerInterface(type(IDAO).interfaceId);
        _registerInterface(type(IExecutor).interfaceId);
        _registerInterface(type(IERC1271).interfaceId);
        _registerInterface(type(IEIP4824).interfaceId);
        _registerInterface(type(IProtocolVersion).interfaceId); // added in v1.3.0
        _registerTokenInterfaces();

        _setMetadata(_metadata);
        _setTrustedForwarder(_trustedForwarder);
        _setDaoURI(daoURI_);
        __PermissionManager_init(_initialOwner);
    }

    /// @notice Initializes the DAO after an upgrade from a previous protocol version.
    /// @param _previousProtocolVersion The semantic protocol version number of the previous DAO implementation contract this upgrade is transitioning from.
    /// @param _initData The initialization data to be passed to via `upgradeToAndCall` (see [ERC-1967](https://docs.openzeppelin.com/contracts/4.x/api/proxy#ERC1967Upgrade)).
    function initializeFrom(
        uint8[3] calldata _previousProtocolVersion,
        bytes calldata _initData
    ) external reinitializer(3) {
        _initData; // Silences the unused function parameter warning.

        // Check that the contract is not upgrading from a different major release.
        if (_previousProtocolVersion[0] != 1) {
            revert ProtocolVersionUpgradeNotSupported(_previousProtocolVersion);
        }

        // Initialize `_reentrancyStatus` that was added in v1.3.0.
        // Register Interface `ProtocolVersion` that was added in v1.3.0.
        if (_previousProtocolVersion.lt([1, 3, 0])) {
            _reentrancyStatus = _NOT_ENTERED;
            _registerInterface(type(IProtocolVersion).interfaceId);
        }

        // Revoke the `SET_SIGNATURE_VALIDATOR_PERMISSION` that was deprecated in v1.4.0.
        if (_previousProtocolVersion.lt([1, 4, 0])) {
            _revoke({
                _where: address(this),
                _who: address(this),
                _permissionId: keccak256("SET_SIGNATURE_VALIDATOR_PERMISSION")
            });

            _registerInterface(type(IDAO).interfaceId);
            _registerInterface(type(IExecutor).interfaceId);
        }
    }

    /// @inheritdoc PermissionManager
    function isPermissionRestrictedForAnyAddr(
        bytes32 _permissionId
    ) internal pure override returns (bool) {
        return
            _permissionId == EXECUTE_PERMISSION_ID ||
            _permissionId == UPGRADE_DAO_PERMISSION_ID ||
            _permissionId == SET_METADATA_PERMISSION_ID ||
            _permissionId == SET_TRUSTED_FORWARDER_PERMISSION_ID ||
            _permissionId == REGISTER_STANDARD_CALLBACK_PERMISSION_ID;
    }

    /// @notice Internal method authorizing the upgrade of the contract via the [upgradeability mechanism for UUPS proxies](https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable) (see [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822)).
    /// @dev The caller must have the `UPGRADE_DAO_PERMISSION_ID` permission.
    function _authorizeUpgrade(address) internal virtual override auth(UPGRADE_DAO_PERMISSION_ID) {}

    /// @inheritdoc IDAO
    function setTrustedForwarder(
        address _newTrustedForwarder
    ) external override auth(SET_TRUSTED_FORWARDER_PERMISSION_ID) {
        _setTrustedForwarder(_newTrustedForwarder);
    }

    /// @inheritdoc IDAO
    function getTrustedForwarder() external view virtual override returns (address) {
        return trustedForwarder;
    }

    /// @inheritdoc IDAO
    function hasPermission(
        address _where,
        address _who,
        bytes32 _permissionId,
        bytes memory _data
    ) external view override returns (bool) {
        return isGranted({_where: _where, _who: _who, _permissionId: _permissionId, _data: _data});
    }

    /// @inheritdoc IDAO
    function setMetadata(
        bytes calldata _metadata
    ) external override auth(SET_METADATA_PERMISSION_ID) {
        _setMetadata(_metadata);
    }

    /// @inheritdoc IExecutor
    function execute(
        bytes32 _callId,
        Action[] calldata _actions,
        uint256 _allowFailureMap
    )
        external
        override
        nonReentrant
        auth(EXECUTE_PERMISSION_ID)
        returns (bytes[] memory execResults, uint256 failureMap)
    {
        // Check that the action array length is within bounds.
        if (_actions.length > MAX_ACTIONS) {
            revert TooManyActions();
        }

        execResults = new bytes[](_actions.length);

        uint256 gasBefore;
        uint256 gasAfter;

        for (uint256 i = 0; i < _actions.length; ) {
            gasBefore = gasleft();

            (bool success, bytes memory result) = _actions[i].to.call{value: _actions[i].value}(
                _actions[i].data
            );
            gasAfter = gasleft();

            // Check if failure is allowed
            if (!hasBit(_allowFailureMap, uint8(i))) {
                // Check if the call failed.
                if (!success) {
                    revert ActionFailed(i);
                }
            } else {
                // Check if the call failed.
                if (!success) {
                    // Make sure that the action call did not fail because 63/64 of `gasleft()` was insufficient to execute the external call `.to.call` (see [ERC-150](https://eips.ethereum.org/EIPS/eip-150)).
                    // In specific scenarios, i.e. proposal execution where the last action in the action array is allowed to fail, the account calling `execute` could force-fail this action by setting a gas limit
                    // where 63/64 is insufficient causing the `.to.call` to fail, but where the remaining 1/64 gas are sufficient to successfully finish the `execute` call.
                    if (gasAfter < gasBefore / 64) {
                        revert InsufficientGas();
                    }

                    // Store that this action failed.
                    failureMap = flipBit(failureMap, uint8(i));
                }
            }

            execResults[i] = result;

            unchecked {
                ++i;
            }
        }

        emit Executed({
            actor: msg.sender,
            callId: _callId,
            actions: _actions,
            allowFailureMap: _allowFailureMap,
            failureMap: failureMap,
            execResults: execResults
        });
    }

    /// @inheritdoc IDAO
    function deposit(
        address _token,
        uint256 _amount,
        string calldata _reference
    ) external payable override {
        if (_amount == 0) revert ZeroAmount();

        if (_token == address(0)) {
            if (msg.value != _amount)
                revert NativeTokenDepositAmountMismatch({expected: _amount, actual: msg.value});
        } else {
            if (msg.value != 0)
                revert NativeTokenDepositAmountMismatch({expected: 0, actual: msg.value});

            IERC20Upgradeable(_token).safeTransferFrom(msg.sender, address(this), _amount);
        }

        emit Deposited(msg.sender, _token, _amount, _reference);
    }

    /// @inheritdoc IDAO
    function setSignatureValidator(address) external pure override {
        revert FunctionRemoved();
    }

    /// @inheritdoc IDAO
    /// @dev Relays the validation logic determining who is allowed to sign on behalf of the DAO to its permission manager.
    /// Caller specific bypassing can be set direct granting (i.e., `grant({_where: dao, _who: specificErc1271Caller, _permissionId: VALIDATE_SIGNATURE_PERMISSION_ID})`).
    /// Caller specific signature validation logic can be set by granting with a `PermissionCondition` (i.e., `grantWithCondition({_where: dao, _who: specificErc1271Caller, _permissionId: VALIDATE_SIGNATURE_PERMISSION_ID, _condition: yourConditionImplementation})`)
    /// Generic signature validation logic can be set for all calling contracts by granting with a `PermissionCondition` to `PermissionManager.ANY_ADDR()` (i.e., `grantWithCondition({_where: dao, _who: PermissionManager.ANY_ADDR(), _permissionId: VALIDATE_SIGNATURE_PERMISSION_ID, _condition: yourConditionImplementation})`).
    function isValidSignature(
        bytes32 _hash,
        bytes memory _signature
    ) external view override(IDAO, IERC1271) returns (bytes4) {
        if (
            isGranted({
                _where: address(this),
                _who: msg.sender,
                _permissionId: VALIDATE_SIGNATURE_PERMISSION_ID,
                _data: abi.encode(_hash, _signature)
            })
        ) {
            return 0x1626ba7e; // `type(IERC1271).interfaceId` = bytes4(keccak256("isValidSignature(bytes32,bytes)")`
        }
        return 0xffffffff; // `bytes4(uint32(type(uint32).max-1))`
    }

    /// @notice Emits the `NativeTokenDeposited` event to track native token deposits that weren't made via the deposit method.
    /// @dev This call is bound by the gas limitations for `send`/`transfer` calls introduced by [ERC-2929](https://eips.ethereum.org/EIPS/eip-2929).
    /// Gas cost increases in future hard forks might break this function. As an alternative, [ERC-2930](https://eips.ethereum.org/EIPS/eip-2930)-type transactions using access lists can be employed.
    receive() external payable {
        emit NativeTokenDeposited(msg.sender, msg.value);
    }

    /// @notice Fallback to handle future versions of the [ERC-165](https://eips.ethereum.org/EIPS/eip-165) standard.
    /// @param _input An alias being equivalent to `msg.data`. This feature of the fallback function was introduced with the [solidity compiler version 0.7.6](https://github.com/ethereum/solidity/releases/tag/v0.7.6)
    /// @return The magic number registered for the function selector triggering the fallback.
    fallback(bytes calldata _input) external returns (bytes memory) {
        bytes4 magicNumber = _handleCallback(msg.sig, _input);
        return abi.encode(magicNumber);
    }

    /// @notice Emits the MetadataSet event if new metadata is set.
    /// @param _metadata Hash of the IPFS metadata object.
    function _setMetadata(bytes calldata _metadata) internal {
        emit MetadataSet(_metadata);
    }

    /// @notice Sets the trusted forwarder on the DAO and emits the associated event.
    /// @param _trustedForwarder The trusted forwarder address.
    function _setTrustedForwarder(address _trustedForwarder) internal {
        trustedForwarder = _trustedForwarder;

        emit TrustedForwarderSet(_trustedForwarder);
    }

    /// @notice Registers the [ERC-721](https://eips.ethereum.org/EIPS/eip-721) and [ERC-1155](https://eips.ethereum.org/EIPS/eip-1155) interfaces and callbacks.
    function _registerTokenInterfaces() private {
        _registerInterface(type(IERC721ReceiverUpgradeable).interfaceId);
        _registerInterface(type(IERC1155ReceiverUpgradeable).interfaceId);

        _registerCallback(
            IERC721ReceiverUpgradeable.onERC721Received.selector,
            IERC721ReceiverUpgradeable.onERC721Received.selector
        );
        _registerCallback(
            IERC1155ReceiverUpgradeable.onERC1155Received.selector,
            IERC1155ReceiverUpgradeable.onERC1155Received.selector
        );
        _registerCallback(
            IERC1155ReceiverUpgradeable.onERC1155BatchReceived.selector,
            IERC1155ReceiverUpgradeable.onERC1155BatchReceived.selector
        );
    }

    /// @inheritdoc IDAO
    function registerStandardCallback(
        bytes4 _interfaceId,
        bytes4 _callbackSelector,
        bytes4 _magicNumber
    ) external override auth(REGISTER_STANDARD_CALLBACK_PERMISSION_ID) {
        _registerInterface(_interfaceId);
        _registerCallback(_callbackSelector, _magicNumber);
        emit StandardCallbackRegistered(_interfaceId, _callbackSelector, _magicNumber);
    }

    /// @inheritdoc IEIP4824
    function daoURI() external view returns (string memory) {
        return _daoURI;
    }

    /// @notice Updates the set DAO URI to a new value.
    /// @param newDaoURI The new DAO URI to be set.
    function setDaoURI(string calldata newDaoURI) external auth(SET_METADATA_PERMISSION_ID) {
        _setDaoURI(newDaoURI);
    }

    /// @notice Sets the new [ERC-4824](https://eips.ethereum.org/EIPS/eip-4824) DAO URI and emits the associated event.
    /// @param daoURI_ The new DAO URI.
    function _setDaoURI(string calldata daoURI_) internal {
        _daoURI = daoURI_;

        emit NewURI(daoURI_);
    }

    /// @notice This empty reserved space is put in place to allow future versions to add new variables without shifting down storage in the inheritance chain (see [OpenZeppelin's guide about storage gaps](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps)).
    uint256[46] private __gap;
}

// lib/osx/packages/contracts/src/framework/plugin/repo/PluginRepoRegistry.sol

/// @title PluginRepoRegistry
/// @author Aragon X - 2022-2023
/// @notice This contract maintains an address-based registry of plugin repositories in the Aragon App DAO framework.
/// @custom:security-contact sirt@aragon.org
contract PluginRepoRegistry is InterfaceBasedRegistry, ProtocolVersion {
    /// @notice The ID of the permission required to call the `register` function.
    bytes32 public constant REGISTER_PLUGIN_REPO_PERMISSION_ID =
        keccak256("REGISTER_PLUGIN_REPO_PERMISSION");

    /// @notice The ENS subdomain registrar registering the PluginRepo subdomains.
    ENSSubdomainRegistrar public subdomainRegistrar;

    /// @notice Emitted if a new plugin repository is registered.
    /// @param subdomain The subdomain of the plugin repository.
    /// @param pluginRepo The address of the plugin repository.
    event PluginRepoRegistered(string subdomain, address pluginRepo);

    /// @notice Thrown if the plugin subdomain doesn't match the regex `[0-9a-z\-]`
    error InvalidPluginSubdomain(string subdomain);

    /// @notice Thrown if the subdomain is present, but registrar is address(0).
    error ENSNotSupported();

    /// @dev Used to disallow initializing the implementation contract by an attacker for extra safety.
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes the contract by setting calling the `InterfaceBasedRegistry` base class initialize method.
    /// @param _dao The address of the managing DAO.
    /// @param _subdomainRegistrar The `ENSSubdomainRegistrar` where `ENS` subdomain will be registered.
    function initialize(IDAO _dao, ENSSubdomainRegistrar _subdomainRegistrar) external initializer {
        bytes4 pluginRepoInterfaceId = type(IPluginRepo).interfaceId;
        __InterfaceBasedRegistry_init(_dao, pluginRepoInterfaceId);

        subdomainRegistrar = _subdomainRegistrar;
    }

    /// @notice Registers a plugin repository with a subdomain and address.
    /// @dev If subdomain is empty, registration on ENS is skipped.
    /// @param subdomain The subdomain of the PluginRepo.
    /// @param pluginRepo The address of the PluginRepo contract.
    function registerPluginRepo(
        string calldata subdomain,
        address pluginRepo
    ) external auth(REGISTER_PLUGIN_REPO_PERMISSION_ID) {
        if (bytes(subdomain).length > 0) {
            if (address(subdomainRegistrar) == address(0)) {
                revert ENSNotSupported();
            }

            if (!isSubdomainValid(subdomain)) {
                revert InvalidPluginSubdomain({subdomain: subdomain});
            }

            bytes32 labelhash = keccak256(bytes(subdomain));
            subdomainRegistrar.registerSubnode(labelhash, pluginRepo);
        }

        _register(pluginRepo);

        emit PluginRepoRegistered(subdomain, pluginRepo);
    }

    /// @notice This empty reserved space is put in place to allow future versions to add new variables without shifting down storage in the inheritance chain (see [OpenZeppelin's guide about storage gaps](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps)).
    uint256[49] private __gap;
}

// lib/osx/packages/contracts/src/framework/plugin/setup/PluginSetupProcessor.sol

/// @title PluginSetupProcessor
/// @author Aragon X - 2022-2023
/// @notice This contract processes the preparation and application of plugin setups (installation, update, uninstallation) on behalf of a requesting DAO.
/// @dev This contract is temporarily granted the `ROOT_PERMISSION_ID` permission on the applying DAO and therefore is highly security critical.
/// @custom:security-contact sirt@aragon.org
contract PluginSetupProcessor is ProtocolVersion {
    using ERC165Checker for address;

    /// @notice The ID of the permission required to call the `applyInstallation` function.
    bytes32 public constant APPLY_INSTALLATION_PERMISSION_ID =
        keccak256("APPLY_INSTALLATION_PERMISSION");

    /// @notice The ID of the permission required to call the `applyUpdate` function.
    bytes32 public constant APPLY_UPDATE_PERMISSION_ID = keccak256("APPLY_UPDATE_PERMISSION");

    /// @notice The ID of the permission required to call the `applyUninstallation` function.
    bytes32 public constant APPLY_UNINSTALLATION_PERMISSION_ID =
        keccak256("APPLY_UNINSTALLATION_PERMISSION");

    /// @notice The hash obtained from the bytes-encoded empty array to be used for UI updates being required to submit an empty permission array.
    /// @dev The hash is computed via `keccak256(abi.encode([]))`.
    bytes32 private constant EMPTY_ARRAY_HASH =
        0x569e75fc77c1a856f6daaf9e69d8a9566ca34aa47f9133711ce065a571af0cfd;

    /// @notice The hash obtained from the bytes-encoded zero value.
    /// @dev The hash is computed via `keccak256(abi.encode(0))`.
    bytes32 private constant ZERO_BYTES_HASH =
        0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563;

    /// @notice A struct containing information related to plugin setups that have been applied.
    /// @param blockNumber The block number at which the `applyInstallation`, `applyUpdate` or `applyUninstallation` was executed.
    /// @param currentAppliedSetupId The current setup id that plugin holds. Needed to confirm that `prepareUpdate` or `prepareUninstallation` happens for the plugin's current/valid dependencies.
    /// @param preparedSetupIdToBlockNumber The mapping between prepared setup IDs and block numbers at which `prepareInstallation`, `prepareUpdate` or `prepareUninstallation` was executed.
    struct PluginState {
        uint256 blockNumber;
        bytes32 currentAppliedSetupId;
        mapping(bytes32 => uint256) preparedSetupIdToBlockNumber;
    }

    /// @notice A mapping between the plugin installation ID (obtained from the DAO and plugin address) and the plugin state information.
    /// @dev This variable is public on purpose to allow future versions to access and migrate the storage.
    mapping(bytes32 => PluginState) public states;

    /// @notice The struct containing the parameters for the `prepareInstallation` function.
    /// @param pluginSetupRef The reference to the plugin setup to be used for the installation.
    /// @param data The bytes-encoded data containing the input parameters for the installation preparation as specified in the corresponding ABI on the version's metadata.
    struct PrepareInstallationParams {
        PluginSetupRef pluginSetupRef;
        bytes data;
    }

    /// @notice The struct containing the parameters for the `applyInstallation` function.
    /// @param pluginSetupRef The reference to the plugin setup used for the installation.
    /// @param plugin The address of the plugin contract to be installed.
    /// @param permissions The array of multi-targeted permission operations to be applied by the `PluginSetupProcessor` to the DAO.
    /// @param helpersHash The hash of helpers that were deployed in `prepareInstallation`. This helps to derive the setup ID.
    struct ApplyInstallationParams {
        PluginSetupRef pluginSetupRef;
        address plugin;
        PermissionLib.MultiTargetPermission[] permissions;
        bytes32 helpersHash;
    }

    /// @notice The struct containing the parameters for the `prepareUpdate` function.
    /// @param currentVersionTag The tag of the current plugin version to update from.
    /// @param newVersionTag The tag of the new plugin version to update to.
    /// @param pluginSetupRepo The plugin setup repository address on which the plugin exists.
    /// @param setupPayload The payload containing the plugin and helper contract addresses deployed in a preparation step as well as optional data to be consumed by the plugin setup.
    ///  This includes the bytes-encoded data containing the input parameters for the update preparation as specified in the corresponding ABI on the version's metadata.
    struct PrepareUpdateParams {
        PluginRepo.Tag currentVersionTag;
        PluginRepo.Tag newVersionTag;
        PluginRepo pluginSetupRepo;
        IPluginSetup.SetupPayload setupPayload;
    }

    /// @notice The struct containing the parameters for the `applyUpdate` function.
    /// @param plugin The address of the plugin contract to be updated.
    /// @param pluginSetupRef The reference to the plugin setup used for the update.
    /// @param initData The encoded data (function selector and arguments) to be provided to `upgradeToAndCall`.
    /// @param permissions The array of multi-targeted permission operations to be applied by the `PluginSetupProcessor` to the DAO.
    /// @param helpersHash The hash of helpers that were deployed in `prepareUpdate`. This helps to derive the setup ID.
    struct ApplyUpdateParams {
        address plugin;
        PluginSetupRef pluginSetupRef;
        bytes initData;
        PermissionLib.MultiTargetPermission[] permissions;
        bytes32 helpersHash;
    }

    /// @notice The struct containing the parameters for the `prepareUninstallation` function.
    /// @param pluginSetupRef The reference to the plugin setup to be used for the uninstallation.
    /// @param setupPayload The payload containing the plugin and helper contract addresses deployed in a preparation step as well as optional data to be consumed by the plugin setup.
    ///  This includes the bytes-encoded data containing the input parameters for the uninstallation preparation as specified in the corresponding ABI on the version's metadata.
    struct PrepareUninstallationParams {
        PluginSetupRef pluginSetupRef;
        IPluginSetup.SetupPayload setupPayload;
    }

    /// @notice The struct containing the parameters for the `applyInstallation` function.
    /// @param plugin The address of the plugin contract to be uninstalled.
    /// @param pluginSetupRef The reference to the plugin setup used for the uninstallation.
    /// @param permissions The array of multi-targeted permission operations to be applied by the `PluginSetupProcess.
    struct ApplyUninstallationParams {
        address plugin;
        PluginSetupRef pluginSetupRef;
        PermissionLib.MultiTargetPermission[] permissions;
    }

    /// @notice The plugin repo registry listing the `PluginRepo` contracts versioning the `PluginSetup` contracts.
    PluginRepoRegistry public repoRegistry;

    /// @notice Thrown if a setup is unauthorized and cannot be applied because of a missing permission of the associated DAO.
    /// @param dao The address of the DAO to which the plugin belongs.
    /// @param caller The address (EOA or contract) that requested the application of a setup on the associated DAO.
    /// @param permissionId The permission identifier.
    /// @dev This is thrown if the `APPLY_INSTALLATION_PERMISSION_ID`, `APPLY_UPDATE_PERMISSION_ID`, or APPLY_UNINSTALLATION_PERMISSION_ID is missing.
    error SetupApplicationUnauthorized(address dao, address caller, bytes32 permissionId);

    /// @notice Thrown if a plugin is not upgradeable.
    /// @param plugin The address of the plugin contract.
    error PluginNonupgradeable(address plugin);

    /// @notice Thrown if the upgrade of an `UUPSUpgradeable` proxy contract (see [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822)) failed.
    /// @param proxy The address of the proxy.
    /// @param implementation The address of the implementation contract.
    /// @param initData The initialization data to be passed to the upgradeable plugin contract via `upgradeToAndCall`.
    error PluginProxyUpgradeFailed(address proxy, address implementation, bytes initData);

    /// @notice Thrown if a contract does not support the `IPlugin` interface.
    /// @param plugin The address of the contract.
    error IPluginNotSupported(address plugin);

    /// @notice Thrown if a plugin repository does not exist on the plugin repo registry.
    error PluginRepoNonexistent();

    /// @notice Thrown if a plugin setup was already prepared indicated by the prepared setup ID.
    /// @param preparedSetupId The prepared setup ID.
    error SetupAlreadyPrepared(bytes32 preparedSetupId);

    /// @notice Thrown if a prepared setup ID is not eligible to be applied. This can happen if another setup has been already applied or if the setup wasn't prepared in the first place.
    /// @param preparedSetupId The prepared setup ID.
    error SetupNotApplicable(bytes32 preparedSetupId);

    /// @notice Thrown if the update version is invalid.
    /// @param currentVersionTag The tag of the current version to update from.
    /// @param newVersionTag The tag of the new version to update to.
    error InvalidUpdateVersion(PluginRepo.Tag currentVersionTag, PluginRepo.Tag newVersionTag);

    /// @notice Thrown if plugin is already installed and one tries to prepare or apply install on it.
    error PluginAlreadyInstalled();

    /// @notice Thrown if the applied setup ID resulting from the supplied setup payload does not match with the current applied setup ID.
    /// @param currentAppliedSetupId The current applied setup ID with which the data in the supplied payload must match.
    /// @param appliedSetupId The applied setup ID obtained from the data in the supplied setup payload.
    error InvalidAppliedSetupId(bytes32 currentAppliedSetupId, bytes32 appliedSetupId);

    /// @notice Emitted with a prepared plugin installation to store data relevant for the application step.
    /// @param sender The sender that prepared the plugin installation.
    /// @param dao The address of the DAO to which the plugin belongs.
    /// @param preparedSetupId The prepared setup ID obtained from the supplied data.
    /// @param pluginSetupRepo The repository storing the `PluginSetup` contracts of all versions of a plugin.
    /// @param versionTag The version tag of the plugin setup of the prepared installation.
    /// @param data The bytes-encoded data containing the input parameters for the preparation as specified in the corresponding ABI on the version's metadata.
    /// @param plugin The address of the plugin contract.
    /// @param preparedSetupData The deployed plugin's relevant data which consists of helpers and permissions.
    event InstallationPrepared(
        address indexed sender,
        address indexed dao,
        bytes32 preparedSetupId,
        PluginRepo indexed pluginSetupRepo,
        PluginRepo.Tag versionTag,
        bytes data,
        address plugin,
        IPluginSetup.PreparedSetupData preparedSetupData
    );

    /// @notice Emitted after a plugin installation was applied.
    /// @param dao The address of the DAO to which the plugin belongs.
    /// @param plugin The address of the plugin contract.
    /// @param preparedSetupId The prepared setup ID.
    /// @param appliedSetupId The applied setup ID.
    event InstallationApplied(
        address indexed dao,
        address indexed plugin,
        bytes32 preparedSetupId,
        bytes32 appliedSetupId
    );

    /// @notice Emitted with a prepared plugin update to store data relevant for the application step.
    /// @param sender The sender that prepared the plugin update.
    /// @param dao The address of the DAO to which the plugin belongs.
    /// @param preparedSetupId The prepared setup ID.
    /// @param pluginSetupRepo The repository storing the `PluginSetup` contracts of all versions of a plugin.
    /// @param versionTag The version tag of the plugin setup of the prepared update.
    /// @param setupPayload The payload containing the plugin and helper contract addresses deployed in a preparation step as well as optional data to be consumed by the plugin setup.
    /// @param preparedSetupData The deployed plugin's relevant data which consists of helpers and permissions.
    /// @param initData The initialization data to be passed to the upgradeable plugin contract.
    event UpdatePrepared(
        address indexed sender,
        address indexed dao,
        bytes32 preparedSetupId,
        PluginRepo indexed pluginSetupRepo,
        PluginRepo.Tag versionTag,
        IPluginSetup.SetupPayload setupPayload,
        IPluginSetup.PreparedSetupData preparedSetupData,
        bytes initData
    );

    /// @notice Emitted after a plugin update was applied.
    /// @param dao The address of the DAO to which the plugin belongs.
    /// @param plugin The address of the plugin contract.
    /// @param preparedSetupId The prepared setup ID.
    /// @param appliedSetupId The applied setup ID.
    event UpdateApplied(
        address indexed dao,
        address indexed plugin,
        bytes32 preparedSetupId,
        bytes32 appliedSetupId
    );

    /// @notice Emitted with a prepared plugin uninstallation to store data relevant for the application step.
    /// @param sender The sender that prepared the plugin uninstallation.
    /// @param dao The address of the DAO to which the plugin belongs.
    /// @param preparedSetupId The prepared setup ID.
    /// @param pluginSetupRepo The repository storing the `PluginSetup` contracts of all versions of a plugin.
    /// @param versionTag The version tag of the plugin to used for install preparation.
    /// @param setupPayload The payload containing the plugin and helper contract addresses deployed in a preparation step as well as optional data to be consumed by the plugin setup.
    /// @param permissions The list of multi-targeted permission operations to be applied to the installing DAO.
    event UninstallationPrepared(
        address indexed sender,
        address indexed dao,
        bytes32 preparedSetupId,
        PluginRepo indexed pluginSetupRepo,
        PluginRepo.Tag versionTag,
        IPluginSetup.SetupPayload setupPayload,
        PermissionLib.MultiTargetPermission[] permissions
    );

    /// @notice Emitted after a plugin installation was applied.
    /// @param dao The address of the DAO to which the plugin belongs.
    /// @param plugin The address of the plugin contract.
    /// @param preparedSetupId The prepared setup ID.
    event UninstallationApplied(
        address indexed dao,
        address indexed plugin,
        bytes32 preparedSetupId
    );

    /// @notice A modifier to check if a caller has the permission to apply a prepared setup.
    /// @param _dao The address of the DAO.
    /// @param _permissionId The permission identifier.
    modifier canApply(address _dao, bytes32 _permissionId) {
        _canApply(_dao, _permissionId);
        _;
    }

    /// @notice Constructs the plugin setup processor by setting the associated plugin repo registry.
    /// @param _repoRegistry The plugin repo registry contract.
    constructor(PluginRepoRegistry _repoRegistry) {
        repoRegistry = _repoRegistry;
    }

    /// @notice Prepares the installation of a plugin.
    /// @param _dao The address of the installing DAO.
    /// @param _params The struct containing the parameters for the `prepareInstallation` function.
    /// @return plugin The prepared plugin contract address.
    /// @return preparedSetupData The data struct containing the array of helper contracts and permissions that the setup has prepared.
    function prepareInstallation(
        address _dao,
        PrepareInstallationParams calldata _params
    ) external returns (address plugin, IPluginSetup.PreparedSetupData memory preparedSetupData) {
        PluginRepo pluginSetupRepo = _params.pluginSetupRef.pluginSetupRepo;

        // Check that the plugin repository exists on the plugin repo registry.
        if (!repoRegistry.entries(address(pluginSetupRepo))) {
            revert PluginRepoNonexistent();
        }

        // reverts if not found
        PluginRepo.Version memory version = pluginSetupRepo.getVersion(
            _params.pluginSetupRef.versionTag
        );

        // Prepare the installation
        (plugin, preparedSetupData) = PluginSetup(version.pluginSetup).prepareInstallation(
            _dao,
            _params.data
        );

        bytes32 pluginInstallationId = _getPluginInstallationId(_dao, plugin);

        bytes32 preparedSetupId = _getPreparedSetupId(
            _params.pluginSetupRef,
            hashPermissions(preparedSetupData.permissions),
            hashHelpers(preparedSetupData.helpers),
            bytes(""),
            PreparationType.Installation
        );

        PluginState storage pluginState = states[pluginInstallationId];

        // Check if this plugin is already installed.
        if (pluginState.currentAppliedSetupId != bytes32(0)) {
            revert PluginAlreadyInstalled();
        }

        // Check if this setup has already been prepared before and is pending.
        if (pluginState.blockNumber < pluginState.preparedSetupIdToBlockNumber[preparedSetupId]) {
            revert SetupAlreadyPrepared({preparedSetupId: preparedSetupId});
        }

        pluginState.preparedSetupIdToBlockNumber[preparedSetupId] = block.number;

        emit InstallationPrepared({
            sender: msg.sender,
            dao: _dao,
            preparedSetupId: preparedSetupId,
            pluginSetupRepo: pluginSetupRepo,
            versionTag: _params.pluginSetupRef.versionTag,
            data: _params.data,
            plugin: plugin,
            preparedSetupData: preparedSetupData
        });

        return (plugin, preparedSetupData);
    }

    /// @notice Applies the permissions of a prepared installation to a DAO.
    /// @param _dao The address of the installing DAO.
    /// @param _params The struct containing the parameters for the `applyInstallation` function.
    function applyInstallation(
        address _dao,
        ApplyInstallationParams calldata _params
    ) external canApply(_dao, APPLY_INSTALLATION_PERMISSION_ID) {
        bytes32 pluginInstallationId = _getPluginInstallationId(_dao, _params.plugin);

        PluginState storage pluginState = states[pluginInstallationId];

        bytes32 preparedSetupId = _getPreparedSetupId(
            _params.pluginSetupRef,
            hashPermissions(_params.permissions),
            _params.helpersHash,
            bytes(""),
            PreparationType.Installation
        );

        // Check if this plugin is already installed.
        if (pluginState.currentAppliedSetupId != bytes32(0)) {
            revert PluginAlreadyInstalled();
        }

        validatePreparedSetupId(pluginInstallationId, preparedSetupId);

        bytes32 appliedSetupId = _getAppliedSetupId(_params.pluginSetupRef, _params.helpersHash);

        pluginState.currentAppliedSetupId = appliedSetupId;
        pluginState.blockNumber = block.number;

        // If the list of requested permission changes is not empty, process them.
        // Note, that this requires the `PluginSetupProcessor` to have the `ROOT_PERMISSION_ID` permission on the
        // installing DAO. Make sure this permission is only granted TEMPORARILY.
        if (_params.permissions.length > 0) {
            DAO(payable(_dao)).applyMultiTargetPermissions(_params.permissions);
        }

        emit InstallationApplied({
            dao: _dao,
            plugin: _params.plugin,
            preparedSetupId: preparedSetupId,
            appliedSetupId: appliedSetupId
        });
    }

    /// @notice Prepares the update of an UUPS upgradeable plugin.
    /// @param _dao The address of the DAO For which preparation of update happens.
    /// @param _params The struct containing the parameters for the `prepareUpdate` function.
    /// @return initData The initialization data to be passed to upgradeable contracts when the update is applied
    /// @return preparedSetupData The data struct containing the array of helper contracts and permissions that the setup has prepared.
    /// @dev The list of `_params.setupPayload.currentHelpers` has to be specified in the same order as they were returned from previous setups preparation steps (the latest `prepareInstallation` or `prepareUpdate` step that has happened) on which the update is prepared for.
    function prepareUpdate(
        address _dao,
        PrepareUpdateParams calldata _params
    )
        external
        returns (bytes memory initData, IPluginSetup.PreparedSetupData memory preparedSetupData)
    {
        if (
            _params.currentVersionTag.release != _params.newVersionTag.release ||
            _params.currentVersionTag.build >= _params.newVersionTag.build
        ) {
            revert InvalidUpdateVersion({
                currentVersionTag: _params.currentVersionTag,
                newVersionTag: _params.newVersionTag
            });
        }

        bytes32 pluginInstallationId = _getPluginInstallationId(_dao, _params.setupPayload.plugin);

        PluginState storage pluginState = states[pluginInstallationId];

        bytes32 currentHelpersHash = hashHelpers(_params.setupPayload.currentHelpers);

        bytes32 appliedSetupId = _getAppliedSetupId(
            PluginSetupRef(_params.currentVersionTag, _params.pluginSetupRepo),
            currentHelpersHash
        );

        // The following check implicitly confirms that plugin is currently installed.
        // Otherwise, `currentAppliedSetupId` would not be set.
        if (pluginState.currentAppliedSetupId != appliedSetupId) {
            revert InvalidAppliedSetupId({
                currentAppliedSetupId: pluginState.currentAppliedSetupId,
                appliedSetupId: appliedSetupId
            });
        }

        PluginRepo.Version memory currentVersion = _params.pluginSetupRepo.getVersion(
            _params.currentVersionTag
        );

        PluginRepo.Version memory newVersion = _params.pluginSetupRepo.getVersion(
            _params.newVersionTag
        );

        bytes32 preparedSetupId;

        // If the current and new plugin setup are identical, this is an UI update.
        // In this case, the permission hash is set to the empty array hash and the `prepareUpdate` call is skipped to avoid side effects.
        if (currentVersion.pluginSetup == newVersion.pluginSetup) {
            preparedSetupId = _getPreparedSetupId(
                PluginSetupRef(_params.newVersionTag, _params.pluginSetupRepo),
                EMPTY_ARRAY_HASH,
                currentHelpersHash,
                bytes(""),
                PreparationType.Update
            );

            // Because UI updates do not change the plugin functionality, the array of helpers
            // associated with this plugin version `preparedSetupData.helpers` and being returned must
            // equal `_params.setupPayload.currentHelpers` returned by the previous setup step (installation or update )
            // that this update is transitioning from.
            preparedSetupData.helpers = _params.setupPayload.currentHelpers;
        } else {
            // Check that plugin is `PluginUUPSUpgradable`.
            if (!_params.setupPayload.plugin.supportsInterface(type(IPlugin).interfaceId)) {
                revert IPluginNotSupported({plugin: _params.setupPayload.plugin});
            }
            if (IPlugin(_params.setupPayload.plugin).pluginType() != IPlugin.PluginType.UUPS) {
                revert PluginNonupgradeable({plugin: _params.setupPayload.plugin});
            }

            // Prepare the update.
            (initData, preparedSetupData) = PluginSetup(newVersion.pluginSetup).prepareUpdate(
                _dao,
                _params.currentVersionTag.build,
                _params.setupPayload
            );

            preparedSetupId = _getPreparedSetupId(
                PluginSetupRef(_params.newVersionTag, _params.pluginSetupRepo),
                hashPermissions(preparedSetupData.permissions),
                hashHelpers(preparedSetupData.helpers),
                initData,
                PreparationType.Update
            );
        }

        // Check if this setup has already been prepared before and is pending.
        if (pluginState.blockNumber < pluginState.preparedSetupIdToBlockNumber[preparedSetupId]) {
            revert SetupAlreadyPrepared({preparedSetupId: preparedSetupId});
        }

        pluginState.preparedSetupIdToBlockNumber[preparedSetupId] = block.number;

        // Avoid stack too deep.
        emitPrepareUpdateEvent(_dao, preparedSetupId, _params, preparedSetupData, initData);

        return (initData, preparedSetupData);
    }

    /// @notice Applies the permissions of a prepared update of an UUPS upgradeable proxy contract to a DAO.
    /// @param _dao The address of the updating DAO.
    /// @param _params The struct containing the parameters for the `applyUpdate` function.
    function applyUpdate(
        address _dao,
        ApplyUpdateParams calldata _params
    ) external canApply(_dao, APPLY_UPDATE_PERMISSION_ID) {
        bytes32 pluginInstallationId = _getPluginInstallationId(_dao, _params.plugin);

        PluginState storage pluginState = states[pluginInstallationId];

        bytes32 preparedSetupId = _getPreparedSetupId(
            _params.pluginSetupRef,
            hashPermissions(_params.permissions),
            _params.helpersHash,
            _params.initData,
            PreparationType.Update
        );

        validatePreparedSetupId(pluginInstallationId, preparedSetupId);

        bytes32 appliedSetupId = _getAppliedSetupId(_params.pluginSetupRef, _params.helpersHash);

        pluginState.blockNumber = block.number;
        pluginState.currentAppliedSetupId = appliedSetupId;

        PluginRepo.Version memory version = _params.pluginSetupRef.pluginSetupRepo.getVersion(
            _params.pluginSetupRef.versionTag
        );

        address currentImplementation = PluginUUPSUpgradeable(_params.plugin).implementation();
        address newImplementation = PluginSetup(version.pluginSetup).implementation();

        if (currentImplementation != newImplementation) {
            _upgradeProxy(_params.plugin, newImplementation, _params.initData);
        }

        // If the list of requested permission changes is not empty, process them.
        // Note, that this requires the `PluginSetupProcessor` to have the `ROOT_PERMISSION_ID` permission on the
        // updating DAO. Make sure this permission is only granted TEMPORARILY.
        if (_params.permissions.length > 0) {
            DAO(payable(_dao)).applyMultiTargetPermissions(_params.permissions);
        }

        emit UpdateApplied({
            dao: _dao,
            plugin: _params.plugin,
            preparedSetupId: preparedSetupId,
            appliedSetupId: appliedSetupId
        });
    }

    /// @notice Prepares the uninstallation of a plugin.
    /// @param _dao The address of the uninstalling DAO.
    /// @param _params The struct containing the parameters for the `prepareUninstallation` function.
    /// @return permissions The list of multi-targeted permission operations to be applied to the uninstalling DAO.
    /// @dev The list of `_params.setupPayload.currentHelpers` has to be specified in the same order as they were returned from previous setups preparation steps (the latest `prepareInstallation` or `prepareUpdate` step that has happened) on which the uninstallation was prepared for.
    function prepareUninstallation(
        address _dao,
        PrepareUninstallationParams calldata _params
    ) external returns (PermissionLib.MultiTargetPermission[] memory permissions) {
        bytes32 pluginInstallationId = _getPluginInstallationId(_dao, _params.setupPayload.plugin);

        PluginState storage pluginState = states[pluginInstallationId];

        bytes32 appliedSetupId = _getAppliedSetupId(
            _params.pluginSetupRef,
            hashHelpers(_params.setupPayload.currentHelpers)
        );

        if (pluginState.currentAppliedSetupId != appliedSetupId) {
            revert InvalidAppliedSetupId({
                currentAppliedSetupId: pluginState.currentAppliedSetupId,
                appliedSetupId: appliedSetupId
            });
        }

        PluginRepo.Version memory version = _params.pluginSetupRef.pluginSetupRepo.getVersion(
            _params.pluginSetupRef.versionTag
        );

        permissions = PluginSetup(version.pluginSetup).prepareUninstallation(
            _dao,
            _params.setupPayload
        );

        bytes32 preparedSetupId = _getPreparedSetupId(
            _params.pluginSetupRef,
            hashPermissions(permissions),
            ZERO_BYTES_HASH,
            bytes(""),
            PreparationType.Uninstallation
        );

        // Check if this setup has already been prepared before and is pending.
        if (pluginState.blockNumber < pluginState.preparedSetupIdToBlockNumber[preparedSetupId]) {
            revert SetupAlreadyPrepared({preparedSetupId: preparedSetupId});
        }

        pluginState.preparedSetupIdToBlockNumber[preparedSetupId] = block.number;

        emit UninstallationPrepared({
            sender: msg.sender,
            dao: _dao,
            preparedSetupId: preparedSetupId,
            pluginSetupRepo: _params.pluginSetupRef.pluginSetupRepo,
            versionTag: _params.pluginSetupRef.versionTag,
            setupPayload: _params.setupPayload,
            permissions: permissions
        });
    }

    /// @notice Applies the permissions of a prepared uninstallation to a DAO.
    /// @param _dao The address of the DAO.
    /// @param _dao The address of the uninstalling DAO.
    /// @param _params The struct containing the parameters for the `applyUninstallation` function.
    /// @dev The list of `_params.setupPayload.currentHelpers` has to be specified in the same order as they were returned from previous setups preparation steps (the latest `prepareInstallation` or `prepareUpdate` step that has happened) on which the uninstallation was prepared for.
    function applyUninstallation(
        address _dao,
        ApplyUninstallationParams calldata _params
    ) external canApply(_dao, APPLY_UNINSTALLATION_PERMISSION_ID) {
        bytes32 pluginInstallationId = _getPluginInstallationId(_dao, _params.plugin);

        PluginState storage pluginState = states[pluginInstallationId];

        bytes32 preparedSetupId = _getPreparedSetupId(
            _params.pluginSetupRef,
            hashPermissions(_params.permissions),
            ZERO_BYTES_HASH,
            bytes(""),
            PreparationType.Uninstallation
        );

        validatePreparedSetupId(pluginInstallationId, preparedSetupId);

        // Since the plugin is uninstalled, only the current block number must be updated.
        pluginState.blockNumber = block.number;
        pluginState.currentAppliedSetupId = bytes32(0);

        // If the list of requested permission changes is not empty, process them.
        // Note, that this requires the `PluginSetupProcessor` to have the `ROOT_PERMISSION_ID` permission on the
        // uninstalling DAO. Make sure this permission is only granted TEMPORARILY.
        if (_params.permissions.length > 0) {
            DAO(payable(_dao)).applyMultiTargetPermissions(_params.permissions);
        }

        emit UninstallationApplied({
            dao: _dao,
            plugin: _params.plugin,
            preparedSetupId: preparedSetupId
        });
    }

    /// @notice Validates that a setup ID can be applied for `applyInstallation`, `applyUpdate`, or `applyUninstallation`.
    /// @param pluginInstallationId The plugin installation ID obtained from the hash of `abi.encode(daoAddress, pluginAddress)`.
    /// @param preparedSetupId The prepared setup ID to be validated.
    /// @dev If the block number stored in `states[pluginInstallationId].blockNumber` exceeds the one stored in `pluginState.preparedSetupIdToBlockNumber[preparedSetupId]`, the prepared setup with `preparedSetupId` is outdated and not applicable anymore.
    function validatePreparedSetupId(
        bytes32 pluginInstallationId,
        bytes32 preparedSetupId
    ) public view {
        PluginState storage pluginState = states[pluginInstallationId];
        if (pluginState.blockNumber >= pluginState.preparedSetupIdToBlockNumber[preparedSetupId]) {
            revert SetupNotApplicable({preparedSetupId: preparedSetupId});
        }
    }

    /// @notice Upgrades a UUPS upgradeable proxy contract (see [ERC-1822](https://eips.ethereum.org/EIPS/eip-1822)).
    /// @param _proxy The address of the proxy.
    /// @param _implementation The address of the implementation contract.
    /// @param _initData The initialization data to be passed to the upgradeable plugin contract via `upgradeToAndCall`.
    function _upgradeProxy(
        address _proxy,
        address _implementation,
        bytes memory _initData
    ) private {
        if (_initData.length > 0) {
            try
                PluginUUPSUpgradeable(_proxy).upgradeToAndCall(_implementation, _initData)
            {} catch Error(string memory reason) {
                revert(reason);
            } catch (bytes memory /*lowLevelData*/) {
                revert PluginProxyUpgradeFailed({
                    proxy: _proxy,
                    implementation: _implementation,
                    initData: _initData
                });
            }
        } else {
            try PluginUUPSUpgradeable(_proxy).upgradeTo(_implementation) {} catch Error(
                string memory reason
            ) {
                revert(reason);
            } catch (bytes memory /*lowLevelData*/) {
                revert PluginProxyUpgradeFailed({
                    proxy: _proxy,
                    implementation: _implementation,
                    initData: _initData
                });
            }
        }
    }

    /// @notice Checks if a caller can apply a setup. The caller can be either the DAO to which the plugin setup is applied to or another account to which the DAO has granted the respective permission.
    /// @param _dao The address of the applying DAO.
    /// @param _permissionId The permission ID.
    function _canApply(address _dao, bytes32 _permissionId) private view {
        if (
            msg.sender != _dao &&
            !DAO(payable(_dao)).hasPermission(address(this), msg.sender, _permissionId, bytes(""))
        ) {
            revert SetupApplicationUnauthorized({
                dao: _dao,
                caller: msg.sender,
                permissionId: _permissionId
            });
        }
    }

    /// @notice A helper to emit the `UpdatePrepared` event from the supplied, structured data.
    /// @param _dao The address of the updating DAO.
    /// @param _preparedSetupId The prepared setup ID.
    /// @param _params The struct containing the parameters for the `prepareUpdate` function.
    /// @param _preparedSetupData The deployed plugin's relevant data which consists of helpers and permissions.
    /// @param _initData The initialization data to be passed to upgradeable contracts when the update is applied
    /// @dev This functions exists to avoid stack-too-deep errors.
    function emitPrepareUpdateEvent(
        address _dao,
        bytes32 _preparedSetupId,
        PrepareUpdateParams calldata _params,
        IPluginSetup.PreparedSetupData memory _preparedSetupData,
        bytes memory _initData
    ) private {
        emit UpdatePrepared({
            sender: msg.sender,
            dao: _dao,
            preparedSetupId: _preparedSetupId,
            pluginSetupRepo: _params.pluginSetupRepo,
            versionTag: _params.newVersionTag,
            setupPayload: _params.setupPayload,
            preparedSetupData: _preparedSetupData,
            initData: _initData
        });
    }
}

// src/harmony/HIPPluginAllowlist.sol

/// @title HIPPluginAllowlist
/// @notice Registry that controls which DAOs are authorized to install the Harmony HIP Voting Plugin.
/// @dev Only the Management DAO can add or remove DAOs from the allowlist.
contract HIPPluginAllowlist is PluginUUPSUpgradeable {
    /// @notice The permission identifier to manage the allowlist.
    bytes32 public constant MANAGE_ALLOWLIST_PERMISSION_ID =
        keccak256("MANAGE_ALLOWLIST_PERMISSION");

    /// @notice Mapping of DAO addresses to their allowlist status.
    mapping(address => bool) public allowedDAOs;

    /// @notice Emitted when a DAO is added to the allowlist.
    /// @param dao The DAO address that was allowed.
    event DAOAllowed(address indexed dao);

    /// @notice Emitted when a DAO is removed from the allowlist.
    /// @param dao The DAO address that was disallowed.
    event DAODisallowed(address indexed dao);

    /// @notice Thrown when trying to check or modify an invalid DAO address.
    /// @param dao The invalid DAO address provided.
    error InvalidDAOAddress(address dao);

    /// @notice Initializes the allowlist with the Management DAO.
    /// @param _managementDao The Management DAO that controls this allowlist.
    function initialize(IDAO _managementDao) external initializer {
        __PluginUUPSUpgradeable_init(_managementDao);
    }

    /// @notice Checks if a DAO is allowed to install the HIP plugin.
    /// @param _dao The DAO address to check.
    /// @return True if the DAO is allowed, false otherwise.
    function isDAOAllowed(address _dao) external view returns (bool) {
        if (_dao == address(0)) {
            revert InvalidDAOAddress(_dao);
        }
        return allowedDAOs[_dao];
    }

    /// @notice Adds a DAO to the allowlist.
    /// @dev Only callable by addresses with MANAGE_ALLOWLIST_PERMISSION.
    /// @param _dao The DAO address to allow.
    function allowDAO(address _dao) external auth(MANAGE_ALLOWLIST_PERMISSION_ID) {
        if (_dao == address(0)) {
            revert InvalidDAOAddress(_dao);
        }
        allowedDAOs[_dao] = true;
        emit DAOAllowed(_dao);
    }

    /// @notice Removes a DAO from the allowlist.
    /// @dev Only callable by addresses with MANAGE_ALLOWLIST_PERMISSION.
    /// @param _dao The DAO address to disallow.
    function disallowDAO(address _dao) external auth(MANAGE_ALLOWLIST_PERMISSION_ID) {
        if (_dao == address(0)) {
            revert InvalidDAOAddress(_dao);
        }
        allowedDAOs[_dao] = false;
        emit DAODisallowed(_dao);
    }

    /// @notice Adds multiple DAOs to the allowlist in a single transaction.
    /// @dev Only callable by addresses with MANAGE_ALLOWLIST_PERMISSION.
    /// @param _daos Array of DAO addresses to allow.
    function allowDAOsBatch(address[] calldata _daos) external auth(MANAGE_ALLOWLIST_PERMISSION_ID) {
        for (uint256 i = 0; i < _daos.length; i++) {
            if (_daos[i] == address(0)) {
                revert InvalidDAOAddress(_daos[i]);
            }
            allowedDAOs[_daos[i]] = true;
            emit DAOAllowed(_daos[i]);
        }
    }

    /// @notice Removes multiple DAOs from the allowlist in a single transaction.
    /// @dev Only callable by addresses with MANAGE_ALLOWLIST_PERMISSION.
    /// @param _daos Array of DAO addresses to disallow.
    function disallowDAOsBatch(address[] calldata _daos) external auth(MANAGE_ALLOWLIST_PERMISSION_ID) {
        for (uint256 i = 0; i < _daos.length; i++) {
            if (_daos[i] == address(0)) {
                revert InvalidDAOAddress(_daos[i]);
            }
            allowedDAOs[_daos[i]] = false;
            emit DAODisallowed(_daos[i]);
        }
    }

    uint256[49] private __gap;
}

