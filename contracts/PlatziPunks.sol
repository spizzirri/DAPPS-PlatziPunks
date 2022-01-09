//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";

//https://docs.openzeppelin.com/contracts/4.x/erc721

contract PlatziPunks is ERC721, ERC721Enumerable{

    using Counters for Counters.Counter;

    Counters.Counter private _idCounter;
    uint256 private maxSupply;

    constructor() ERC721("PlatziPunks", "PLPKS"){

    }

    function mint() public{
        require(_idCounter.current() < maxSupply, "No PlatziPunks left");
        uint256 current = _idCounter.current();
        _idCounter.increment();
        _safeMint(msg.sender, current);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory){
        require(_exists(tokenId), "ERC721 Metadata: URI query nonexistent token");

        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{ "name": "PlatziPunks #" }',
                tokenId,
                '", "description": "Platzi Punks are randomized Avataaars stored on chain to teach DApp development on Platzi", "image": "',
                "//TODO: Calculate image URL",
                '"}'
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