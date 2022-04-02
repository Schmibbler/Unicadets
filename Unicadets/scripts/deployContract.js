const { Contract } = require("ethers");
const fs = require('fs');
async function main() {
    const MyContract = await ethers.getContractFactory("Unicadets");
    const myContract = await MyContract.deploy();
  
    console.log("My Contract deployed to:", myContract.address);
    for (let i = 0; i < 30; i++)
    {
      svg_text = await myContract._renderSVG(Math.ceil(Math.random() * 10000))
      fs.writeFileSync(`./svgs/${i}.svg`, svg_text)
    }
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
  });
  