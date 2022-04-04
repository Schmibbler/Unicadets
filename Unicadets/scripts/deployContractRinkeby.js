require("@nomiclabs/hardhat-waffle");

async function main() {
   
  
    let uni = await ethers.getContractFactory("Unicadets");
    let Unicadets = await uni.deploy();
    //await Unicadets.setRendererContract(UnicadetsRenderer.address)
    // Renderer address: 0xF7eC73f797d86de44F75eB7f40c6D7148386499b
    // Base address: 0x904016901D1D7D6C99e21527E6bA7c09B84E81c7
    // Start deployment, returning a promise that resolves to a contract object
    console.log("Unicadets deployed to:", Unicadets.address);
 }
 
 main()
   .then(() => process.exit(0))
   .catch(error => {
     console.error(error);
     process.exit(1);
   });