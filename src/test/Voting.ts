import { type Contract } from 'hardhat/internal/hardhat-network/stack-traces/model';
import { ethers } from "hardhat";
import { expect } from "chai";

describe("Voting", () => {
  let Contract, contract, director, voter, result;

  // createPoll params
  const id = 0;
  const title = "2023 Presidential Election";
  const newTitle = "2023 Presidential Election";
  const image = "https://images.urls/me.jpg";
  const newImage = "https://images/urls/you.png";
  const description = "Presidential Election";
  // starts in 1day
  const startsAt = Date.now() * 3600 * 1000 * 24;
  // ends in 3days from start date
  const endsAt = Date.now() * 3600 * 1000 * 72;

  // registerUser params
  const image1 = "https//website.com/image.jpg";
  const fullName = "Ridwan Adefemi Odubona";

  // -- second user
  const image2 = "https://website.com/image2.jpg";
  const fullName2 = "Ibrahim Adeyinka Odubona";

  // 1. Deploy Smart Contract before anything.
  beforeEach(async () => {
     Contract = await ethers.getContractFactory("Voting");

    // grab some accounts
    // get some available accounts from the deployed Network.
    [director, voter] = await ethers.getSigners();

    // deploy contract
     contract = await Contract.deploy();
  });

  describe("Poll", () => {
    // create a poll before running each test.
    // all other things are dependent on a "poll"
    it("Should confirm poll creation", async () => {
        // result = await contract.getAllPolls()
    })
  });
});
