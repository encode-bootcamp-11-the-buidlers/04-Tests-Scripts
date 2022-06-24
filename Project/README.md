# Advanced Sample Hardhat Project

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

## Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/deploy.ts
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:
The constructor args "Pizza" "Lasagna" "Icecream" translates to the array:
[
'0x50697a7a61000000000000000000000000000000000000000000000000000000',
'0x4c617361676e6100000000000000000000000000000000000000000000000000',
'0x496365637265616d000000000000000000000000000000000000000000000000'
]

```shell
yarn hardhat verify --network ropsten --constructor-args scripts/Ballot/constructorArgs.ts DEPLOYED_CONTRACT_ADDRESS
```

## Performance optimizations

For faster runs of your tests and scripts, consider skipping ts-node's type checking by setting the environment variable `TS_NODE_TRANSPILE_ONLY` to `1` in hardhat's environment. For more details see [the documentation](https://hardhat.org/guides/typescript.html#performance-optimizations).

## Deployments

[Etherscan](https://ropsten.etherscan.io/address/0xEf6d29dDFf75C3aC09C7AA37B3ea58aA2Bb24EB5)

Using address 0x4bFC74983D6338D3395A00118546614bB78472c2
Wallet balance 10.000001
Deploying Ballot contract
Proposals:
Proposal N. 1: Pizza
Proposal N. 2: Lasagna
Proposal N. 3: Icecream
Awaiting confirmations
Completed
Contract deployed at 0xEf6d29dDFf75C3aC09C7AA37B3ea58aA2Bb24EB5
✨ Done in 30.60s.

## Local deployment

You can use Hardhat Network in order to have a local Ethereum network node for development.

To do so :

1. Put this in your .env (default mnemonic for hardhat network accounts)
```MNEMONIC=test test test test test test test test test test test junk```
2. Run local node
```yarn hardhat node```