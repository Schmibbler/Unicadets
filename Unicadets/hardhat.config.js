require("@nomiclabs/hardhat-waffle");
require('solidity-coverage');
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");
require('dotenv');

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

module.exports = {
  solidity: "0.8.5",
  defaultNetwork: "localhost",
  gasReporter: {
    currency: 'USD',
    gasPrice: 40
  },
  networks: {
    hardhat: {},
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/aAbSGN-ZOS_0rFHQR3cqSiItIoqbV6-W",
      accounts: [`e81b7f82dcf6b43ebd851ad6c41c8cda6b965cb53f8a6672c696b823f649cbf8`]
    }
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "GMF7YJTUBISAP6GM6ZY2R4S59611CI1FB7"
  }
};
