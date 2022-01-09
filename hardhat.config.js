require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/7b304accbc3c43c3851633d6f7a6e33c",
      accounts:[
        '0x22f7cb13b028cecff987ae20019be797820cffa57f515b273fdb2650e4ac1b21'
      ]
    }
  }
};
