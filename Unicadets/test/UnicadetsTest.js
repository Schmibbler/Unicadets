const { expect } = require("chai");
const { BigNumber } = require("ethers");
const { ethers } = require("hardhat")

prov = ethers.getDefaultProvider();


describe("Unicadets", async function () {

  beforeEach( async () => {
  
  })
  
  it("Mints token to the owner", async function () {

    let accounts = await ethers.getSigners()
    const owner = accounts[0]
    accounts.shift()
    let ERC721 = await ethers.getContractFactory("Unicadets");
    let Unicadets = await ERC721.deploy();
    let quantity = 1
    let tokenId = await Unicadets.totalSupply()
    expect(await Unicadets.mintCadet(quantity, {
        value: batchPrice(quantity, tokenId)
    })
    )
    .to.emit(Unicadets, "Transfer")
    .withArgs(      
      ethers.constants.AddressZero,
      owner.address,
      tokenId
      );
  });

  

  it("Mints one token to one EOA", async function () {

    let accounts = await ethers.getSigners()
    const owner = accounts[0]
    const EOA = accounts[1]
    accounts.shift()
    let ERC721 = await ethers.getContractFactory("Unicadets");
    let Unicadets = await ERC721.deploy();

    let tokenId = await Unicadets.totalSupply()
    let quantity = 1
    expect(await Unicadets.connect(EOA).mintCadet(quantity, {
        value: await Unicadets.getBatchPrice(quantity)
    })
    )
    .to.emit(Unicadets, "Transfer")
    .withArgs(      
      ethers.constants.AddressZero,
      EOA.address,
      tokenId
      );
  });

  
  it("Mints 5 tokens to one EOA", async function () {

    let accounts = await ethers.getSigners()
    const owner = accounts[0]
    const EOA = accounts[1]
    accounts.shift()
    let ERC721 = await ethers.getContractFactory("Unicadets");
    let Unicadets = await ERC721.deploy();

    let tokenId = await Unicadets.totalSupply()
    let quantity = 5
    expect(await Unicadets.connect(EOA).mintCadet(quantity, {
        value: await Unicadets.getBatchPrice(quantity)
    })
    )
    .to.emit(Unicadets, "Transfer")
    .withArgs(      
      ethers.constants.AddressZero,
      EOA.address,
      tokenId
      );
  });
  
  
  it("Mints 5 tokens to 3 EOAs", async function () {

    let accounts = await ethers.getSigners()
    const owner = accounts[0]
    accounts.shift()
    let [acc1, acc2, acc3] = accounts
    let ERC721 = await ethers.getContractFactory("Unicadets");
    let Unicadets = await ERC721.deploy();
    let quantity = await Unicadets.MAX_MINT_PER()
    let price
    let tokenId
    
    
    tokenId = await Unicadets.totalSupply()
    price = batchPrice(quantity, tokenId)
    await Unicadets.connect(acc1).mintCadet(quantity, {
      value: price
    })

    expect(await Unicadets.ownerOf(tokenId)).to.equal(acc1.address)
    expect(await Unicadets.balanceOf(acc1.address)).to.equal(quantity)

    tokenId = await Unicadets.totalSupply()
    price = batchPrice(quantity, tokenId)
    await Unicadets.connect(acc2).mintCadet(quantity, {
      value: price
    })
    expect(await Unicadets.ownerOf(tokenId)).to.equal(acc2.address)
    expect(await Unicadets.balanceOf(acc2.address)).to.equal(quantity)

    tokenId = await Unicadets.totalSupply()
    price = batchPrice(quantity, tokenId)
    await Unicadets.connect(acc3).mintCadet(quantity, {
      value: price
    })
    expect(await Unicadets.ownerOf(tokenId)).to.equal(acc3.address)
    expect(await Unicadets.balanceOf(acc3.address)).to.equal(quantity)
    
})

it("Sets the renderer address correctly", async function () {

  let accounts = await ethers.getSigners()
  const owner = accounts[0]
  accounts.shift()
  let [acc1, acc2, acc3] = accounts

  let renderer = await ethers.getContractFactory("UnicadetsRenderer")
  let UnicadetsRenderer = await renderer.deploy()

  let ERC721 = await ethers.getContractFactory("Unicadets");
  let Unicadets = await ERC721.deploy();
  await Unicadets.setRendererContract(UnicadetsRenderer.address)
  expect(await Unicadets.UnicadetsRenderer()).to.equal(UnicadetsRenderer.address)
})

it("Mints with unique seeds assigned to tokenIdToSeed mapping", async function () {

  let accounts = await ethers.getSigners()
  const owner = accounts[0]
  accounts.shift()
  let [acc1, acc2, acc3] = accounts
  let ERC721 = await ethers.getContractFactory("Unicadets");
  let Unicadets = await ERC721.deploy();
  let quantity = await Unicadets.MAX_MINT_PER()
  let price
  let tokenId
  
  tokenId = await Unicadets.totalSupply()
  price = await Unicadets.getBatchPrice(quantity)
  await Unicadets.connect(acc1).mintCadet(quantity, {
    value: price
  })

  expect(await Unicadets.ownerOf(tokenId)).to.equal(acc1.address)
  expect(await Unicadets.balanceOf(acc1.address)).to.equal(quantity)

  tokenId = await Unicadets.totalSupply()
  price = await Unicadets.getBatchPrice(quantity)
  await Unicadets.connect(acc2).mintCadet(quantity, {
    value: price
  })
  expect(await Unicadets.ownerOf(tokenId)).to.equal(acc2.address)
  expect(await Unicadets.balanceOf(acc2.address)).to.equal(quantity)

  tokenId = await Unicadets.totalSupply()
  price = await Unicadets.getBatchPrice(quantity)
  await Unicadets.connect(acc3).mintCadet(quantity, {
    value: price
  })
  expect(await Unicadets.ownerOf(tokenId)).to.equal(acc3.address)
  expect(await Unicadets.balanceOf(acc3.address)).to.equal(quantity)

  let supply = await Unicadets.totalSupply()
  for (let i = 0; i < supply; i++) {
    let seed = await Unicadets.tokenIdToSeed(ethers.utils.parseUnits(i.toString()))
    expect(seed.gt(ethers.utils.parseUnits("0")))
  }

})

it("Assigns ownership from minting correctly", async function () {
    let accounts = await ethers.getSigners()
    const owner = accounts[0]
    accounts.shift()
    let [acc1, acc2, acc3] = accounts
    let ERC721 = await ethers.getContractFactory("Unicadets");
    let Unicadets = await ERC721.deploy();
    let quantity = await Unicadets.MAX_MINT_PER()
    let price
    let tokenId
    
    tokenId = await Unicadets.totalSupply()
    price = await Unicadets.getBatchPrice(quantity)
    await Unicadets.connect(acc1).mintCadet(quantity, {
      value: price
    })

    for (let i = 0; i < quantity; i++) {
      expect(await Unicadets.ownerOf(tokenId + i)).to.equal(acc1.address)
    }
    expect(await Unicadets.balanceOf(acc1.address)).to.equal(quantity)    
})

it("Stores the tokenIDs correctly", async function () {

  let accounts = await ethers.getSigners()
  const owner = accounts[0]
  accounts.shift()
  let [acc1, acc2, acc3] = accounts
  let ERC721 = await ethers.getContractFactory("Unicadets");
  let Unicadets = await ERC721.deploy();
  let quantity = await Unicadets.MAX_MINT_PER();
  let price
  let tokenId
  
  tokenId = await Unicadets.totalSupply()
  price = await Unicadets.getBatchPrice(quantity)
  await Unicadets.connect(acc1).mintCadet(quantity, {
    value: price
  })

  expect(await Unicadets.ownerOf(tokenId)).to.equal(acc1.address)
  expect(await Unicadets.balanceOf(acc1.address)).to.equal(quantity)

  tokenId = await Unicadets.totalSupply()
  price = await Unicadets.getBatchPrice(quantity)
  await Unicadets.connect(acc2).mintCadet(quantity, {
    value: price
  })
  expect(await Unicadets.ownerOf(tokenId)).to.equal(acc2.address)
  expect(await Unicadets.balanceOf(acc2.address)).to.equal(quantity)

  tokenId = await Unicadets.totalSupply()
  price = await Unicadets.getBatchPrice(quantity)
  await Unicadets.connect(acc3).mintCadet(quantity, {
    value: price
  })
  expect(await Unicadets.ownerOf(tokenId)).to.equal(acc3.address)
  expect(await Unicadets.balanceOf(acc3.address)).to.equal(quantity)

  let supply = await Unicadets.totalSupply()
  supply = supply.toNumber()

  for (let i = 0; i < supply; i ++)
    expect(await Unicadets.ownerOf(i)).to.not.equal(ethers.constants.AddressZero)
  
})

});

it("Transfers contract balance to the owner", async function () {
    let accounts = await ethers.getSigners()
    const owner = accounts[0]
    accounts.shift()
    let [acc1, acc2, acc3] = accounts
    let ERC721 = await ethers.getContractFactory("Unicadets");
    let Unicadets = await ERC721.deploy();
    let quantity = await Unicadets.MAX_MINT_PER();
    let price
    let tokenId
    
    tokenId = await Unicadets.totalSupply()
    price = await Unicadets.getBatchPrice(quantity)
    await Unicadets.connect(acc1).mintCadet(quantity, {
      value: price
    })

    expect(await Unicadets.ownerOf(tokenId)).to.equal(acc1.address)
    expect(await Unicadets.balanceOf(acc1.address)).to.equal(quantity)

    tokenId = await Unicadets.totalSupply()
    price = await Unicadets.getBatchPrice(quantity)
    await Unicadets.connect(acc2).mintCadet(quantity, {
      value: price
    })
    expect(await Unicadets.ownerOf(tokenId)).to.equal(acc2.address)
    expect(await Unicadets.balanceOf(acc2.address)).to.equal(quantity)

    tokenId = await Unicadets.totalSupply()
    price = await Unicadets.getBatchPrice(quantity)
    await Unicadets.connect(acc3).mintCadet(quantity, {
      value: price
    })
    expect(await Unicadets.ownerOf(tokenId)).to.equal(acc3.address)
    expect(await Unicadets.balanceOf(acc3.address)).to.equal(quantity)

    
    let ownerBalanceBefore = await prov.getBalance(owner.address);
    await Unicadets.connect(owner).withdraw()
    let ownerBalanceAfter = await prov.getBalance(owner.address);
    expect(ownerBalanceAfter.gt(ownerBalanceBefore))

    
})
/*
it("Mints out the entire collection and transfers balance to the owner", async function () {
    let accounts = await ethers.getSigners()
    const owner = accounts[0]
    accounts.shift()
    let [acc1, acc2, acc3] = accounts
    let ERC721 = await ethers.getContractFactory("Unicadets");
    let Unicadets = await ERC721.deploy();
    let quantity = await Unicadets.MAX_MINT_PER();
    let price
    let tokenId
    let supply = await Unicadets.MAX_SUPPLY()
    let mint_per = await Unicadets.MAX_MINT_PER()
    let iterations = supply / mint_per
    let ownerBalanceBefore = await prov.getBalance(owner.address);

    for (let i = 0; i < iterations; i++) {
        tokenId = await Unicadets.totalSupply()
        price = await Unicadets.getBatchPrice(quantity)
        await Unicadets.connect(acc1).mintCadet(quantity, {
            value: price
        })
        expect(await Unicadets.ownerOf(tokenId)).to.equal(acc1.address)
    }

    let ownerBalanceAfter = await prov.getBalance(owner.address);
    expect(ownerBalanceAfter.gt(ownerBalanceBefore))
    expect(await Unicadets.totalSupply()).to.equal(await Unicadets.MAX_SUPPLY())
    

})
*/

function batchPrice(num_tokens, current_supply) {
    let total_price = BigNumber.from("0")
    for (let i = 0; i < num_tokens; i++)
      total_price.add(currentPrice(current_supply + i))
    return total_price    
}

function currentPrice(current_supply) {
  if (current_supply <= 300)
     return BigNumber.from("0");
  else if (current_supply <= 2000)
    return ethers.utils.parseUnits(".1");
  else if (current_supply <= 3000)
    return ethers.utils.parseUnits(".15");
  else
    return ethers.utils.parseUnits(".1");
}
