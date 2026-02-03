// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

interface IERC721 {
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function mint(address to, uint256 quantity) external payable;
}

contract Qollabb is IERC721Receiver {
    // Defining collab logic here
    struct CollabRequest {
        address creator;
        address partner;
        uint256 creatorShare; // percentage
        uint256 partnerShare; // percentage
        uint256 fundsLocked; // in wei
        uint256 nftId; // Minted NFT ID
        address nftContract; // NFT collection address
        uint256 mintPrice; // price per NFT in wei
        uint256 nftQuantity; // number of NFTs to mint
        CollabStatus status;
    }

    enum CollabStatus {
        OPEN, // nft collab request created
        FUNDED, // partner has locked funds
        MINTED, //NFT has been minted in Qollabb contract
        SOLD, //NFT has been sold
        SETTLED // funds have been distributed
    }
    mapping(uint256 => CollabRequest) public collabs;
    uint256 public collabCount;
}
