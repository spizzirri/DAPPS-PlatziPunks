const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('PlatziPunks', () => {

    const setup = async ({ maxSupply = 10000 }) => {
        const [ owner ] = await ethers.getSigners();
        const PlatziPunks = await ethers.getContractFactory('PlatziPunks');
        const deployed = await PlatziPunks.deploy(maxSupply)

        return { owner, deployed };
    }


    it('Should init contract with name and symbol', async () =>{
        const sampleMaxSupply = 4000;
        const contractFactory = await ethers.getContractFactory('PlatziPunks');
        const platziPunks = await contractFactory.deploy(sampleMaxSupply);

        const contractName = await platziPunks.name();
        const contractSymbol = await platziPunks.symbol();

        expect(contractName).to.equal('PlatziPunks');
        expect(contractSymbol).to.equal('PLPKS');
    });

    describe('MaxSupply', ()=>{
        it('Sets max supply to passed param', async () => {
            const sampleMaxSupply = 4000;
            const { deployed } = await setup({ maxSupply: sampleMaxSupply });
    
            const returnedMaxSupply = await deployed.getMaxSupply();
            expect(sampleMaxSupply).to.equal(returnedMaxSupply);
        })
    })

    describe('Minting', () => {

        it('Mints a new token and assings it to owner', async()=>{
            const sampleMaxSupply = 4000;
            const { owner, deployed } = await setup({maxSupply:sampleMaxSupply});

            await deployed.mint();

            const ownerOfMinted = await deployed.ownerOf(0);
            expect(ownerOfMinted).to.equal(owner.address);
        })

        it('Has a minting limit', async ()=>{
            const maxSupply = 2;
            const { deployed } = await setup({ maxSupply });

            await deployed.mint();
            await deployed.mint();


            await expect(deployed.mint()).to.be.revertedWith('No PlatziPunks left');
        })
    })

    describe('tokenURI', () => {

        it('returns valid metadata', async () => {
            const { deployed } = await setup({});

            await deployed.mint();

            const tokenURI = await deployed.tokenURI(0);
            const stringifiedTokenURI = await tokenURI.toString();
            const [ , base64JSON ] = stringifiedTokenURI.split('data:application/json;base64');

            const stringifiedMetadata = await Buffer.from(base64JSON, 'base64').toString('ascii');

            const metadata = JSON.parse(stringifiedMetadata);

            expect(metadata).to.have.all.keys('name', 'description', 'image');
        })
    })
})