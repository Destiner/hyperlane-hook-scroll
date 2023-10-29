// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { Mailbox } from "hyperlane-monorepo/solidity/contracts/Mailbox.sol";
import { TypeCasts } from "hyperlane-monorepo/solidity/contracts/libs/TypeCasts.sol";
import { IPostDispatchHook } from "hyperlane-monorepo/solidity/contracts/interfaces/hooks/IPostDispatchHook.sol";

import { IL2GasPriceOracle } from "../src/vendor/IL2GasPriceOracle.sol";

import { BaseScript } from "./Base.s.sol";

contract Bridge is BaseScript {
    address MAILBOX_ADDRESS = 0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766;
    uint32 DESTINATION_DOMAIN = 11_155_111;
    IPostDispatchHook SCROLL_HOOK = IPostDispatchHook(0x5248130913109c347695f3beA0682eeE42c2436F);
    IL2GasPriceOracle l2GasPriceOracle = IL2GasPriceOracle(0x247969F4fad93a33d4826046bc3eAE0D36BdE548);
    uint256 GAS_LIMIT = 120_000;

    uint256 amount = 0.000123 ether;

    function run() public broadcast {
        address from = address(SCROLL_HOOK);
        address to = msg.sender;
        bytes memory message = abi.encodePacked(
            uint8(0),
            uint32(0),
            uint32(0),
            TypeCasts.addressToBytes32(from),
            DESTINATION_DOMAIN,
            TypeCasts.addressToBytes32(to),
            bytes("0x")
        );
        address recipient = msg.sender;
        bytes32 recipientBytes = TypeCasts.addressToBytes32(recipient);
        uint16 variant = 1;
        uint256 fee = l2GasPriceOracle.estimateCrossDomainMessageFee(GAS_LIMIT);
        uint256 value = amount + fee;
        address refundAddress = 0x429b1c760DCEAe09D0967870C33abfd43aE8E2d1;
        bytes memory hookMetadata = abi.encodePacked(variant, value, GAS_LIMIT, refundAddress, amount);
        Mailbox mailbox = Mailbox(MAILBOX_ADDRESS);
        uint256 quote = mailbox.quoteDispatch(DESTINATION_DOMAIN, recipientBytes, message, hookMetadata, SCROLL_HOOK);
        mailbox.dispatch{ value: amount + fee + quote }(
            DESTINATION_DOMAIN, recipientBytes, message, hookMetadata, SCROLL_HOOK
        );
    }
}
