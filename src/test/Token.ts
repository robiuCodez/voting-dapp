import { expect } from "chai";
import { ethers } from "hardhat";

describe("Token Contract", () => {
  it("Deployment should assign the total supply of tokens to the owner", async () => {
    const [owner] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("Token");

    const newToken = await Token.deploy();

    const ownerBalance = await newToken.balanceOf(owner.address);

    // make sure owner's balance is equal to the total supply of token.
    
    expect(await newToken.totalSupply().to.equal(ownerBalance));
  });
});
