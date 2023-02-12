import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();
const MATIC_RPC = process.env.MATIC_RPC
// const PRIVATE_KEY = "613f43018dde154aefd5fa4e034c73f91c9481aac07a797052289534b1b45a87";
const PRIVATE_KEY = process.env.PRIVATE_KEY

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.0",
      },
      {
        version: "0.8.17",
      },
    ],
    settings: {
      evmVersion: "berlin",
      metadata: {
        // Not including the metadata hash
        // https://github.com/paulrberg/solidity-template/issues/31
        bytecodeHash: "none",
      },
      // You should disable the optimizer when debugging
      // https://hardhat.org/hardhat-network/#solidity-optimizer-support
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  //  defaultNetwork: "kovan",
  networks: {
    polygon: {
      url: MATIC_RPC,
      accounts: [`0x${PRIVATE_KEY}`],
      // accounts: [mnemonic],
    },
   /* bsc: {
      url: process.env.BSC_RPC || "",
      accounts: [mnemonic],
    },
    ftm: {
      url: process.env.FTM_RPC || "",
      accounts: [mnemonic],
    }, */
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: {
      polygon: process.env.POLYGONSCAN_API_KEY,
      // polygonMumbai: process.env.POLYGON_KEY,
      // bsc: process.env.BSC_KEY,
      // opera: process.env.FTMSCAN_KEY,
    },
  },
};

export default config;

