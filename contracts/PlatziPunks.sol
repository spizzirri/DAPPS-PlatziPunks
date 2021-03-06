//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";
import "./PlatziPunksDNA.sol";

//https://docs.openzeppelin.com/contracts/4.x/erc721

contract PlatziPunks is ERC721, ERC721Enumerable, PlatziPunksDNA {

    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _idCounter;
    uint256 private maxSupply;
    mapping(uint256 => uint256) public tokenDNA;

    constructor(uint256 _maxSupply) ERC721("PlatziPunks", "PLPKS"){
        maxSupply = _maxSupply;
    }

    function getMaxSupply() public view returns(uint256){
        return maxSupply;
    }

    function mint() public{
        require(_idCounter.current() < maxSupply, "No PlatziPunks left");
        uint256 current = _idCounter.current();
        _idCounter.increment();
        tokenDNA[current] = deterministicPseudoRandomDNA(current, msg.sender);
        _safeMint(msg.sender, current);
    }

    function _baseURI() internal pure override returns (string memory){
        return "https://avataaars.io/";
    }

    function _paramURI(uint256 _dna) internal view returns(string memory){
        string memory params;
        params = string(abi.encodePacked(
            "accessoriesType=",
            getAccessoriesType(uint8(_dna)),
            "&clotheColor=",
            getClotheColor(uint8(_dna)),
            "&clotheType=",
            getClotheType(uint8(_dna)),
            "&eyeType=",
            getEyeType(uint8(_dna)),
            "&eyebrowType=",
            getEyeBrowType(uint8(_dna)),
            "&facialHairColor=",
            getFacialHairColor(uint8(_dna)),
            "&facialHairType=",
            getFacialHairType(uint8(_dna)),
            "&hairColor=",
            getHairColor(uint8(_dna)),
            "&hatColor=",
            getHatColor(uint8(_dna)),
            "&graphicType=",
            getGraphicType(uint8(_dna)),
            "&mouthType=",
            getMouthType(uint8(_dna)),
            "&skinColor=",
            getSkinColor(uint8(_dna))
        ));
        return params;
    }

    function imageByDNA(uint256 _dna) public view returns(string memory){
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramURI(_dna);

        return string(abi.encodePacked(baseURI, "?", paramsURI));
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory){
        require(_exists(tokenId), "ERC721 Metadata: URI query nonexistent token");

        uint256 dna = tokenDNA[tokenId];
        string memory image = imageByDNA(dna);
        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{',
                '"name": "PlatziPunks #', tokenId.toString(), '",', 
                '"description": "Platzi Punks are randomized Avataaars stored on chain to teach DApp development on Platzi",',
                '"image": "', image, '"',
                '}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}