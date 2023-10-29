// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity >=0.8.21;

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
import { IL2ScrollMessenger } from "./vendor/IL2ScrollMessenger.sol";

// ============ External Imports ============
import { IInterchainSecurityModule } from
    "hyperlane-monorepo/solidity/contracts/interfaces/IInterchainSecurityModule.sol";
import { Message } from "hyperlane-monorepo/solidity/contracts/libs/Message.sol";
import { TypeCasts } from "hyperlane-monorepo/solidity/contracts/libs/TypeCasts.sol";
import { AbstractMessageIdAuthorizedIsm } from
    "hyperlane-monorepo/solidity/contracts/isms/hook/AbstractMessageIdAuthorizedIsm.sol";
import { Address } from "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title ScrollIsm
 * @notice Uses the native Scroll bridge to verify interchain messages.
 */
contract ScrollIsm is AbstractMessageIdAuthorizedIsm {
    // ============ Errors ============

    error NotCrossChainCall();

    // ============ Constants ============

    uint8 public constant moduleType = uint8(IInterchainSecurityModule.Types.NULL);

    /// @notice messenger contract specified by the rollup
    IL2ScrollMessenger public immutable l2Messenger;

    // ============ Constructor ============

    constructor(address _l2Messenger) {
        require(Address.isContract(_l2Messenger), "ScrollIsm: invalid L2Messenger");
        l2Messenger = IL2ScrollMessenger(_l2Messenger);
    }

    // ============ Internal function ============

    /**
     * @notice Check if sender is authorized to message `verifyMessageId`.
     */
    function _isAuthorized() internal view override returns (bool) {
        return _crossChainSender() == TypeCasts.bytes32ToAddress(authorizedHook);
    }

    function _crossChainSender() internal view returns (address) {
        if (!_isCrossChain(address(l2Messenger))) revert NotCrossChainCall();

        return IL2ScrollMessenger(l2Messenger).xDomainMessageSender();
    }

    function _isCrossChain(address messenger) internal view returns (bool) {
        return msg.sender == messenger;
    }
}
