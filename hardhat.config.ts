import { time } from "@nomicfoundation/hardhat-network-helpers";
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  // defaultNetwork: "localhost",
  // networks: {
  //   localhost: {
  //     url: "http://127.0.0.1:8545",
  //   },
  // },
  paths: {
    sources: "./src/contracts",
    artifacts: "./src/abis",
  },
  mocha: {
    timeout: 40000,
  },
  // settings: {
  //   version: "",
  //   settings: {
  //     optimizer: {
  //       enabled: true,
  //       runs: 200
  //     }
  //   }
  // }
};

export default config;
