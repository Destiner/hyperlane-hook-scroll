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
forge script script/Deploy.s.sol:DeployHook --rpc-url sepolia --legacy --broadcast -vvvv
```

3. Set the authorized hook

> Note: you need to set both the ISM address and the hook address in the script

```sh
forge script script/Deploy.s.sol:SetAuthorizedHook --rpc-url scroll_sepolia --legacy --broadcast -vvvv
```

## Example deployment

### ScrollHook

Chain: Sepolia (11155111)

Address:
[0x5248130913109c347695f3beA0682eeE42c2436F](https://sepolia.etherscan.io/address/0x5248130913109c347695f3beA0682eeE42c2436F)

Transaction:
[0x0465249b42536bdb8b69b7e14233313486c050658a6a75bdb50d9d623896ddea](https://sepolia.etherscan.io/tx/0x0465249b42536bdb8b69b7e14233313486c050658a6a75bdb50d9d623896ddea)

### ScrollIsm

Chain: Scroll Sepolia (534351)

Address:
[0x65B7249f2D2b8EE2fCFD19f2ccE2D4522031BFb9](https://sepolia.scrollscan.com/address/0x65B7249f2D2b8EE2fCFD19f2ccE2D4522031BFb9)

Transaction
[0x57ee94a2562fb9aa8c4f6dea619301b766015a6e94529632a0ede42f62ab3947](https://sepolia.scrollscan.com/tx/0x57ee94a2562fb9aa8c4f6dea619301b766015a6e94529632a0ede42f62ab3947)
