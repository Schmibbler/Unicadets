require("@nomiclabs/hardhat-waffle");

async function main() {
   
  
    let uni = await ethers.getContractFactory("Unicadets");
    let Unicadets = await uni.deploy();
    //await Unicadets.setRendererContract(UnicadetsRenderer.address)
    // Renderer address: 0x048DFC061059f60A925FB664659aB656774dB0aF
    // Base address: 0x40ad35478462782EFE267f748081591d49Ccc9C5
    // Start deployment, returning a promise that resolves to a contract object
    console.log("Unicadets deployed to:", Unicadets.address);
 }
 
 main()
   .then(() => process.exit(0))
   .catch(error => {
     console.error(error);
     process.exit(1);
   });