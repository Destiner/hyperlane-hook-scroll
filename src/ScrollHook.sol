// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.8.0;

/*@@@@@@@       @@@@@@@@@
 @@@@@@@@@       @@@@@@@@@
  @@@@@@@@@       @@@@@@@@@
   @@@@@@@@@       @@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@
     @@@@@  HYPERLANE  @@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@
   @@@@@@@@@       @@@@@@@@@
  @@@@@@@@@       @@@@@@@@@
 @@@@@@@@@       @@@@@@@@@
@@@@@@@@@       @@@@@@@@*/

// ============ Internal Imports ============
import { IScrollMessenger } from "./vendor/IScrollMessenger.sol";

// ============ External Imports ============
import { AbstractMessageIdAuthHook } from
    "hyperlane-monorepo/solidity/contracts/hooks/libs/AbstractMessageIdAuthHook.sol";
import { StandardHookMetadata } from "hyperlane-monorepo/solidity/contracts/hooks/libs/StandardHookMetadata.sol";
import { TypeCasts } from "hyperlane-monorepo/solidity/contracts/libs/TypeCasts.sol";
import { Message } from "hyperlane-monorepo/solidity/contracts/libs/Message.sol";
import { IPostDispatchHook } from "hyperlane-monorepo/solidity/contracts/interfaces/hooks/IPostDispatchHook.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title ScrollHook
 * @notice Message hook to inform the ScrollIsm of messages published through
 * the native Scroll bridge.
 * @notice This works only for L1 -> L2 messages.
 */
contract ScrollHook is AbstractMessageIdAuthHook {
    using StandardHookMetadata for bytes;

    // ============ Constants ============

    /// @notice messenger contract specified by the rollup
    IScrollMessenger public immutable l1Messenger;

    // Gas limit for sending messages to L2
    uint32 internal constant DEFAULT_GAS_LIMIT = 168_000;

    // ============ Constructor ============

    constructor(
        address _mailbox,
        uint32 _destinationDomain,
        bytes32 _ism,
        address _l1Messenger
    )
        AbstractMessageIdAuthHook(_mailbox, _destinationDomain, _ism)
    {
        require(Address.isContract(_l1Messenger), "ScrollHook: invalid messenger");
        l1Messenger = IScrollMessenger(_l1Messenger);
    }

    // ============ Internal functions ============
    function _quoteDispatch(bytes calldata, bytes calldata) internal pure override returns (uint256) {
        return 0; // gas subsidized by the L2
    }

    /// @inheritdoc AbstractMessageIdAuthHook
    function _sendMessageId(bytes calldata metadata, bytes memory payload) internal override {
        require(metadata.msgValue(0) < 2 ** 255, "ScrollHook: msgValue must be less than 2 ** 255");
        bytes calldata customMetadata = metadata.getCustomMetadata();
        uint256 amount = uint256(bytes32(customMetadata[0:32]));
        l1Messenger.sendMessage{ value: metadata.msgValue(0) }(
            TypeCasts.bytes32ToAddress(ism),
            amount,
            payload,
            metadata.gasLimit(DEFAULT_GAS_LIMIT),
            metadata.refundAddress(address(0))
        );
    }
}
