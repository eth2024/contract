import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
// import { Contract } from "ethers";

/**
 * @param hre HardhatRuntimeEnvironment object.
 */
const deployAll: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { owner } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const myToken = await deploy("Picademy", {
    from: owner,
    log: true,
    autoMine: true,
  });

  await deploy("StakingManager", {
    from: owner,
    args: [myToken.address],
    log: true,
    autoMine: true,
  });

  // const stakingManager = await hre.ethers.getContract<Contract>("StakingManager", owner);
  // console.log("StakingManager address:", await stakingManager.getTokenAddress());
};

export default deployAll;

// Tags are useful if you have multiple deploy files and only want to run one of them.
// e.g. yarn deploy --tags YourContract
deployAll.tags = ["deployAll"];
