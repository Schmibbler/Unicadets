const { expect } = require("chai");
const { ethers } = require("hardhat")


describe("Token contract", async function () {

  beforeEach( async () => {

  })
  
  it("Mints token to the owner", async function () {

    let accounts = await ethers.getSigners()
    const owner = accounts[0]
    accounts.shift()
    let ERC721 = await ethers.getContractFactory("Unicadets");
    let Unicadets = await ERC721.deploy();
    console.log("Address of contract is " + Unicadets.address);

    let tokenId = await Unicadets.totalSupply()
    let price = await Unicadets.currentPrice()
    let quantity = 1
    expect(await Unicadets.mint(quantity, {
        value: price * quantity
    })
    )
    .to.emit(Unicadets, "Transfer")
    .withArgs(      
      ethers.constants.AddressZero,
      owner.address,
      tokenId
      );
  });

  it("Mints tokens to EOAs", async function () {

      let accounts = await ethers.getSigners()
      const owner = accounts[0]
      accounts.shift()
      let ERC721 = await ethers.getContractFactory("Unicadets");
      let Unicadets = await ERC721.deploy();
      let quantity = 100
      let price
      let tokenId
      accounts.forEach( async (EOA) => {
         
          price = await Unicadets.currentPrice() 
          tokenId = await Unicadets.totalSupply()
          expect(await Unicadets.mint(quantity, {
              value: price * quantity
          })
          )
          .to.emit(Unicadets, "Transfer")
          .withArgs(
            ethers.constants.AddressZero,
            owner.address,
            tokenId
          );
      })

  })
  /*
  it("Ascribes unique traits to each cadet", async function () {

    let accounts = await ethers.getSigners()
    const owner = accounts[0]
    accounts.shift()
    let ERC721 = await ethers.getContractFactory("Unicadets");
    let Unicadets = await ERC721.deploy();
    let quantity = 100
    let price
    let tokenId
    accounts.forEach( async (EOA) => {
       
        price = await Unicadets.currentPrice() 
        tokenId = await Unicadets.totalSupply()
        expect(await Unicadets.mint(quantity, {
            value: price * quantity
        })
        )
        .to.emit(Unicadets, "Transfer")
        .withArgs(
          ethers.constants.AddressZero,
          owner.address,
          tokenId
        );
    })

})
*/





});
