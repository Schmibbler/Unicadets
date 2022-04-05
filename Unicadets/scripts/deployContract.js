
const { Contract } = require("ethers");
const fs = require('fs');
const { BigNumber } = require("ethers");
const { ethers } = require("hardhat")



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
  console.log("Renderer deployed to: " + UnicadetsRenderer.address)
  console.log("Unicadets deployed to " + Unicadets.address)
  let quantity = await Unicadets.MAX_MINT_PER()
  let price
  let tokenId
  
  tokenId = await Unicadets.totalSupply()
  price = await Unicadets.getBatchPrice(quantity)
  await Unicadets.connect(acc1).mint(quantity, {
    value: price
  })

  tokenId = await Unicadets.totalSupply()
  price = await Unicadets.getBatchPrice(quantity)
  await Unicadets.connect(acc2).mint(quantity, {
    value: price
  })

  tokenId = await Unicadets.totalSupply()
  price = await Unicadets.getBatchPrice(quantity)
  await Unicadets.connect(acc3).mint(quantity, {
    value: price
  })

  let current_supply = await Unicadets.totalSupply()
  current_supply = current_supply.toNumber()
  
  let encoded
  for (let i = 0; i < current_supply; i++) {

    encoded = await Unicadets.tokenURI(i)
    fs.writeFileSync(`../encoded_svgs/${i}.txt`, encoded)
  }

  for (let i = 0; i < current_supply; i++) {
      let data = Buffer.from(fs.readFileSync(`../encoded_svgs/${i}.txt`), 'base64').toString()
      data = data.slice(29, data.length)
      data = JSON.parse(Buffer.from(data, 'base64').toString())
      data = data['image']
      data = data.slice(26, data.length)
      data = Buffer.from(data, 'base64').toString()
      fs.writeFileSync(`../decoded_svgs/${i}.svg`, data)
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
  else if (current_supply > 300 && current_supply <= 3000)
    return ethers.utils.parseUnits(".15");
  else
    return ethers.utils.parseUnits(".1");
}
