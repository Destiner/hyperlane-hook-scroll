// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.21 <0.9.0;

import { Mailbox } from "hyperlane-monorepo/solidity/contracts/Mailbox.sol";
import { TypeCasts } from "hyperlane-monorepo/solidity/contracts/libs/TypeCasts.sol";
import { IPostDispatchHook } from "hyperlane-monorepo/solidity/contracts/interfaces/hooks/IPostDispatchHook.sol";

import { BaseScript } from "./Base.s.sol";

contract Bridge is BaseScript {
    address MAILBOX_ADDRESS = 0xfFAEF09B3cd11D9b20d1a19bECca54EEC2884766;
    uint32 DESTINATION_DOMAIN = 11_155_111;
    IPostDispatchHook SCROLL_HOOK = IPostDispatchHook(0x5248130913109c347695f3beA0682eeE42c2436F);

    uint256 amount = 0.0001 ether;
    uint256 L1_FEE = 0;
    uint256 L2_FEE = 0.0002218 ether;

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
        uint256 value = amount + L1_FEE + L2_FEE;
        uint256 gasLimit = 168_000;
        address refundAddress = 0x429b1c760DCEAe09D0967870C33abfd43aE8E2d1;
        bytes memory hookMetadata = abi.encodePacked(variant, value, gasLimit, refundAddress, amount);
        Mailbox mailbox = Mailbox(MAILBOX_ADDRESS);
        uint256 quoteFee = mailbox.quoteDispatch(DESTINATION_DOMAIN, recipientBytes, message, hookMetadata, SCROLL_HOOK);
        mailbox.dispatch{ value: amount + L1_FEE + L2_FEE + quoteFee }(
            DESTINATION_DOMAIN, recipientBytes, message, hookMetadata, SCROLL_HOOK
        );
    }
}

// async function main() {
//   const accounts = await ethers.getSigners();
//   const account = accounts[0];
//   // Bridge 0.0001 ETH to Scroll Sepolia via Hyperlane Mailbox
//   const amount = ethers.utils.parseEther('0.0001');
//   const l1Fee = ethers.utils.parseEther(L1_FEE);
//   const l2Fee = ethers.utils.parseEther(L2_FEE);
//   const fee = l1Fee.add(l2Fee);

//   // const from = account.address;
//   const from = SCROLL_HOOK;
//   const to = account.address;
//   const message = ethers.utils.concat([
//     ethers.utils.hexZeroPad(0, 1),
//     ethers.utils.hexZeroPad(0, 4),
//     ethers.utils.hexZeroPad('0x', 4),
//     ethers.utils.hexZeroPad(from, 32),
//     ethers.utils.hexZeroPad(DESTINATION_DOMAIN, 4),
//     ethers.utils.hexZeroPad(to, 32),
//     ethers.utils.hexZeroPad('0x', 32),
//   ]);
//   const recipient = account.address;
//   const recipientBytes = ethers.utils.hexlify(
//     ethers.utils.hexZeroPad(recipient, 32),
//   );
//   const variant = 1;
//   const value = amount.add(fee);
//   const gasLimit = 168000;
//   const refundAddress = recipient;
//   const hookMetadata = ethers.utils.concat([
//     ethers.utils.hexZeroPad(variant, 2),
//     ethers.utils.hexZeroPad(value, 32),
//     ethers.utils.hexZeroPad(gasLimit, 32),
//     ethers.utils.hexZeroPad(refundAddress, 20),
//     ethers.utils.hexZeroPad(amount, 32),
//   ]);
//   const mailbox = await ethers.getContractAt(
//     'Mailbox',
//     MAILBOX_ADDRESS,
//     account,
//   );
//   const quoteCall = await mailbox.functions[
//     'quoteDispatch(uint32,bytes32,bytes,bytes,address)'
//   ](DESTINATION_DOMAIN, recipientBytes, message, hookMetadata, SCROLL_HOOK);
//   console.log(quoteCall);
//   const dispatchTx = await mailbox.functions[
//     'dispatch(uint32,bytes32,bytes,bytes,address)'
//   ](DESTINATION_DOMAIN, recipientBytes, message, hookMetadata, SCROLL_HOOK, {
//     value: amount.add(l1Fee).add(l2Fee).add(quoteCall[0]),
//   });
//   console.log(dispatchTx.hash);
// }

// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });
