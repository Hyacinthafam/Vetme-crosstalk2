// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
import { ethers } from "hardhat";
import { task } from "hardhat/config";
import {
    TASK_APPROVE_FEES,
    TASK_DEPLOY,
    TASK_SET_FEES_TOKEN,
    TASK_SET_LINKER,
    TASK_STORE_DEPLOYMENTS,
  } from "./task-names";

async function main() {
  const Vetmets = await ethers.getContractFactory("Vetmets");
  const vetmets = await Vetmets.deploy(100000000, 50);

  await vetmets.deployed();

  console.log("Vetmets Token deployed: ", vetmets.address);
}
task(TASK_DEPLOY, "Deploys the project").setAction(
    async (taskArgs, hre): Promise<null> => {
      const deployment = require("../deployments/deployments.json");
  
      const network = await hre.ethers.provider.getNetwork();
      const chainId = network.chainId;
  
      const handler = deployment[chainId].handler;
      const feeToken = deployment[chainId].feeToken;
      const linker = deployment[chainId].linker;
  
      const contract = await hre.ethers.getContractFactory("Vetmets");
  
      const vetmets = await contract.deploy(handler);
      await vetmets.deployed();
      console.log(`Vetmets deployed to: `, vetmets.address);
  
      await hre.run(TASK_STORE_DEPLOYMENTS, {
        contractName: "vetmets",
        contractAddress: vetmets.address,
      });
  
      await hre.run(TASK_SET_LINKER, {
        contractAdd: vetmets.address,
        linkerAdd: linker,
      });
  
      await hre.run(TASK_SET_FEES_TOKEN, {
        contractAdd: vetmets.address,
        feeToken: feeToken,
      });
  
      await hre.run(TASK_APPROVE_FEES, {
        contractAdd: vetmets.address,
        feeToken: feeToken,
      });
  
      return null;
    }
  );
  

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});



 /* import { ethers } from "hardhat";

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  const lockedAmount = ethers.utils.parseEther("1");

  const Lock = await ethers.getContractFactory("Lock");
  const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

  await lock.deployed();

  console.log(`Lock with 1 ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});*/


  