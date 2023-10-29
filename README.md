# Hyperlane Hook: Scroll

A hook for L1 -> L2 transfers on Scroll powered by the native bridge.

## Setup

1. Install the dependencies

```sh
npm install
```

2. Build the contracts

```sh
npm run build
```

## Deployment

1. Deploy the ISM

```sh
forge script script/Deploy.s.sol:DeployIsm --rpc-url scroll_sepolia --legacy --broadcast -vvvv

```

2. Deploy the hook

> Note: you need to set the ISM address in the script

```sh
forge script script/Deploy.s.sol:DeployHook --rpc-url sepolia --broadcast -vvvv
```

3. Set the authorized hook

> Note: you need to set both the ISM address and the hook address in the script

```sh
forge script script/Deploy.s.sol:SetAuthorizedHook --rpc-url scroll_sepolia --legacy --broadcast -vvvv
```

## Example deployment

- ScrollHook
  - Chain: Sepolia (`11155111`)
  - Address:
    [0x5248130913109c347695f3beA0682eeE42c2436F](https://sepolia.etherscan.io/address/0x5248130913109c347695f3beA0682eeE42c2436F)
- ScrollIsm
  - Chain: Scroll Sepolia (`534351`)
  - Address:
    [0x65B7249f2D2b8EE2fCFD19f2ccE2D4522031BFb9](https://sepolia.scrollscan.com/address/0x65B7249f2D2b8EE2fCFD19f2ccE2D4522031BFb9)

## Example transfer

The bridging script:

```sh
forge script script/Bridge.s.sol --rpc-url sepolia --broadcast -vvvv
```

Amount: 0.00042069 ETH

Message ID: `3421af3988efb00eaa3efcb4322fa6c272a28b651d680bdb02752f37ecead7a1`

L1 Transaction:
[0xa8d1e2ee9373d614db46b79c1ed9bc82c886d16ed0f4e90332924c4aa52b2d96](https://sepolia.etherscan.io/tx/0xa8d1e2ee9373d614db46b79c1ed9bc82c886d16ed0f4e90332924c4aa52b2d96)

L2 Transaction:
[0x99e3b4a59b7434ee85561dd5908ee089def64b5f612f7e1cd49480addf6c347c](https://sepolia.scrollscan.com/tx/0x99e3b4a59b7434ee85561dd5908ee089def64b5f612f7e1cd49480addf6c347c)
