require("@nomiclabs/hardhat-waffle");

async function main() {
    let renderer = await ethers.getContractFactory("UnicadetsRenderer")
    let UnicadetsRenderer = await renderer.deploy()

    // Start deployment, returning a promise that resolves to a contract object
    console.log("Renderer contract deployed to address:", UnicadetsRenderer.address);
    //await Unicadets.mint(1)
 }
 
 main()
   .then(() => process.exit(0))
   .catch(error => {
     console.error(error);
     process.exit(1);
   });