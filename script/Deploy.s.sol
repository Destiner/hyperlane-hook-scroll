// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { TypeCasts } from "hyperlane-monorepo/solidity/contracts/libs/TypeCasts.sol";
import { MailboxClient } from "hyperlane-monorepo/solidity/contracts/client/MailboxClient.sol";

import { ScrollHook } from "../src/ScrollHook.sol";
import { ScrollIsm } from "../src/ScrollIsm.sol";
import { IL2ScrollMessenger } from "../src/vendor/IL2ScrollMessenger.sol";
import { IScrollMessenger } from "../src/vendor/IScrollMessenger.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployIsm is BaseScript {
    address l2Messenger = 0xBa50f5340FB9F3Bd074bD638c9BE13eCB36E603d;

    function run() public broadcast returns (ScrollIsm ism) {
        ism = new ScrollIsm(address(l2Messenger));
    }
}

contract DeployHook is BaseScript {
    address l1Messenger = 0x50c7d3e7f7c656493D1D76aaa1a836CedfCBB16A;
    address MAILBOX_ADDRESS = 0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766;
    uint32 DESTINATION_DOMAIN = 534_351;

    address scrollIsm = 0x51AE1324100aC700323d0E0Bc307F3a2E410D68e;

    function run() public broadcast returns (ScrollHook hook) {
        hook = new ScrollHook(
            MAILBOX_ADDRESS,
            DESTINATION_DOMAIN,
            TypeCasts.addressToBytes32(scrollIsm),
            l1Messenger
        );
    }
}

contract SetAuthorizedHook is BaseScript {
    ScrollIsm ism = ScrollIsm(0x51AE1324100aC700323d0E0Bc307F3a2E410D68e);
    address hook = 0x3b00426e8e0c8B582e303B083Fd7a0da7eceE386;

    function run() public broadcast {
        ism.setAuthorizedHook(TypeCasts.addressToBytes32(hook));
    }
}

contract DeployL2Hook is BaseScript {
    address MAILBOX_ADDRESS = 0x3C5154a193D6e2955650f9305c8d80c18C814A68;
    uint32 DESTINATION_DOMAIN = 534_351;
    address ism = 0x51AE1324100aC700323d0E0Bc307F3a2E410D68e;
    // We don't actually need this, but it's required to pass the "is contract" check
    address messenger = 0xBa50f5340FB9F3Bd074bD638c9BE13eCB36E603d;

    function run() public broadcast returns (ScrollHook hook) {
        hook = new ScrollHook(
            MAILBOX_ADDRESS,
            DESTINATION_DOMAIN,
            TypeCasts.addressToBytes32(ism),
            messenger
        );

        hook.setInterchainSecurityModule(ism);
    }
}
