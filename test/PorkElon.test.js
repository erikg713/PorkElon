const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("PorkElon Token", function () {
  let token, owner, addr1, addr2, marketing;

  beforeEach(async function () {
    [owner, addr1, addr2, marketing] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("PorkElon");
    token = await Token.deploy(marketing.address);
    await token.deployed();
  });

  it("Should have correct total supply", async () => {
    const supply = await token.totalSupply();
    expect(await token.balanceOf(owner.address)).to.equal(supply);
  });

  it("Should enforce max tx", async () => {
    const maxTx = await token.maxTxAmount();
    await expect(token.transfer(addr1.address, maxTx.add(1))).to.be.revertedWith("Exceeds max tx limit");
  });

  it("Should enforce max wallet size", async () => {
    await token.transfer(addr1.address, await token.maxWalletSize());
    await expect(token.transfer(addr1.address, 1)).to.be.revertedWith("Exceeds max wallet size");
  });

  it("Should enforce cooldown", async () => {
    const maxTx = await token.maxTxAmount();
    await token.transfer(addr1.address, maxTx);
    await token.connect(addr1).transfer(addr2.address, maxTx.div(2));
    await expect(token.connect(addr1).transfer(addr2.address, 1)).to.be.revertedWith("Cooldown: wait");
  });

  it("Should take fee and send to marketing wallet", async () => {
    const amount = await token.maxTxAmount();
    await token.transfer(addr1.address, amount);
    await token.connect(addr1).transfer(addr2.address, amount.div(2));
    const fee = amount.div(2).mul(await token.marketingFee()).div(100);
    expect(await token.balanceOf(marketing.address)).to.equal(fee);
  });

  it("Owner can update limits and fees", async () => {
    await token.updateLimits(2, 4, 60);
    await token.setMarketingFee(5);
    expect(await token.cooldownTime()).to.equal(60);
    expect(await token.marketingFee()).to.equal(5);
  });

  it("Should allow fee exclusion", async () => {
    await token.excludeFromFees(addr1.address, true);
    await token.transfer(addr1.address, await token.maxTxAmount());
    await token.connect(addr1).transfer(addr2.address, 1000); // no cooldown or fee
  });
});