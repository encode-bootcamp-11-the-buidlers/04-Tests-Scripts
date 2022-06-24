import { ethers } from "ethers";
import "dotenv/config";
import * as ballotJson from "../../artifacts/contracts/Ballot.sol/Ballot.json";

// This key is already public on Herong's Tutorial Examples - v1.03, by Dr. Herong Yang
// Do never expose your keys like this
const EXPOSED_KEY =
  "8da4ef21b864d2cc526dbdb2a120bd2874c36c9d0a1fb7f8c63d7f7a8b41de8f";

async function main() {
  const contractAddress = process.argv[2];
  const network = process.argv[3];

  const wallet =
    process.env.MNEMONIC && process.env.MNEMONIC.length > 0
      ? ethers.Wallet.fromMnemonic(process.env.MNEMONIC)
      : new ethers.Wallet(process.env.PRIVATE_KEY ?? EXPOSED_KEY);
  console.log(`Using address ${wallet.address}`);

  let provider:
    | ethers.providers.JsonRpcProvider
    | ethers.providers.BaseProvider;
  if (network === "localhost") {
    provider = new ethers.providers.JsonRpcProvider();
  } else {
    provider = ethers.providers.getDefaultProvider(network);
  }
  const signer = wallet.connect(provider);

  const ballotContract = new ethers.Contract(
    contractAddress,
    ballotJson.abi,
    signer
  );

  let index = 0;
  let hasProposal = true;
  while (hasProposal) {
    try {
      const proposal = await ballotContract.proposals(index);

      const proposalString = ethers.utils.parseBytes32String(proposal.name);
      const proposalVoteCount = proposal.voteCount;

      console.log(
        `Proposal ${index}: ${proposalString}, vote count  ${proposalVoteCount}`
      );
      index++;
    } catch (e) {
      hasProposal = false;
    }
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
