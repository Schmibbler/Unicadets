async function main() {
    const MyContract = await ethers.getContractFactory("Unicadets");
    const myContract = await MyContract.deploy();
  
    console.log("My Contract deployed to:", myContract.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
  });
  