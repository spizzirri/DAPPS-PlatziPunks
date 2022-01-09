const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('PlatziPunks', () => {
    it('Should init contract with name and symbol', async () =>{

        const contractFactory = await ethers.getContractFactory('PlatziPunks');
        const platziPunks = await contractFactory.deploy();

        const contractName = await platziPunks.name();
        const contractSymbol = await platziPunks.symbol();

        expect(contractName).to.equal('PlatziPunks');
        expect(contractSymbol).to.equal('PLPKS');
    });

})