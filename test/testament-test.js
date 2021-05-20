const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Testament", function () {
  it("Should have something from testament to deployment", async function () {
    const Testament = await ethers.getContractFactory("Testament");
    const testament = await Testament.deploy();
    await testament.deployed();
  });
});
