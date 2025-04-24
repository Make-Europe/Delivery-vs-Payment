const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DeliveryVsPaymentEscrowSafeTimeout", function () {
  let seller, buyer, dvpContract;
  let stablecoin, securities;

  beforeEach(async () => {
    [seller, buyer] = await ethers.getSigners();

    // 🔍 Lade ERC20Mock Factory
    const ERC20 = await ethers.getContractFactory("ERC20Mock");
    console.log("Factory Loaded:", ERC20 !== undefined); // Muss true sein

    // ✅ Deploy Dummy Tokens
    stablecoin = await ERC20.deploy("USDC", "USDC", buyer.address, 1000000);
    securities = await ERC20.deploy("SEC", "SEC", seller.address, 500);

    // 🔍 Logs mit Ethers v6 - nutze .target
    console.log("Stablecoin address:", stablecoin.target);
    console.log("Securities address:", securities.target);
    console.log("Seller address:", seller.address);
    console.log("Buyer address:", buyer.address);

    // 🛑 Fehler werfen, wenn Tokens nicht deployed
    if (!stablecoin?.target) throw new Error("Stablecoin not deployed!");
    if (!securities?.target) throw new Error("Securities not deployed!");

    // Deploy DvP Contract – nutze .target
    const DvP = await ethers.getContractFactory("DeliveryVsPaymentEscrowSafeTimeout");
    dvpContract = await DvP.deploy(
      seller.address,
      buyer.address,
      securities.target,
      stablecoin.target,
      500,
      1000,
      86400 // 1 Tag
    );
    console.log("DvP Contract deployed at:", dvpContract.target);
  });

  it("should deploy the contract", async () => {
    expect(dvpContract.target).to.not.be.undefined;
    expect(await dvpContract.seller()).to.equal(seller.address);
    expect(await dvpContract.buyer()).to.equal(buyer.address);
    expect(await dvpContract.securitiesToken()).to.equal(securities.target);
    expect(await dvpContract.stablecoinToken()).to.equal(stablecoin.target);
  });
});
