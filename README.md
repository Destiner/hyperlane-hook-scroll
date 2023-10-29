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
