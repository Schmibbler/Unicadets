
const { Contract } = require("ethers");
const fs = require('fs');
const { BigNumber } = require("ethers");
const { ethers } = require("hardhat")
const { fetch } = require("node-fetch")
globalThis.fetch = fetch


async function main() {

  
  let accounts = await ethers.getSigners()
  const owner = accounts[0]
  accounts.shift()
  let [acc1, acc2, acc3] = accounts
  let renderer = await ethers.getContractFactory("UnicadetsRenderer")
  let UnicadetsRenderer = await renderer.deploy()

  let ERC721 = await ethers.getContractFactory("Unicadets");
  let Unicadets = await ERC721.deploy();
  await Unicadets.setRendererContract(UnicadetsRenderer.address)

  let quantity = 10
  let price
  let tokenId
  
  tokenId = await Unicadets.totalSupply()
  price = batchPrice(quantity, tokenId)
  await Unicadets.connect(acc1).mint(quantity, {
    value: price
  })

  tokenId = await Unicadets.totalSupply()
  price = batchPrice(quantity, tokenId)
  await Unicadets.connect(acc2).mint(quantity, {
    value: price
  })

  tokenId = await Unicadets.totalSupply()
  price = batchPrice(quantity, tokenId)
  await Unicadets.connect(acc3).mint(quantity, {
    value: price
  })

  let current_supply = await Unicadets.totalSupply()
  current_supply = current_supply.toNumber()
  
  let encoded
  for (let i = 0; i < current_supply; i++) {
    // seed = await Unicadets.tokenIdToSeed(ethers.utils.parseUnits(i.toString()))
    encoded = await Unicadets.tokenURI(i)
    fs.writeFileSync(`./encoded_svgs/${i}.txt`, encoded)
  }

  for (let i = 0; i < current_supply; i++) {
    fetch(`./encoded_svgs/${i}.txt`)
      .then(response => response.text())
      .then(data => {
        let obj = JSON.parse(atob(data))
        let svg = atob(obj['image'])
        fs.writeFileSync(`./svgs_from_encoded/${i}.svg`)
    });
  }


}

  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
  });


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
