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

    function createNFTCollab(
        address _nftContract,
        uint256 _mintPrice,
        uint256 _creatorShare,
        uint256 _partnerShare,
    ) external returns (uint256) {
        require(
            _creatorShare + _partnerShare == 100,
            "Combines shares must equal 100%"
        );

        uint256 collabId = collabCount;

        collabs[collabId] = CollabRequest({
            creator: msg.sender,
            partner: address(0),
            creatorShare: _creatorShare,
            partnerShare: _partnerShare,
            nftId: 0,
            nftContract: _nftContract,
            mintPrice: _mintPrice,
            fundsLocked: 0,
            status: CollabStatus.OPEN
        });

        collabCount++;
        return collabId;
    }

    function fundCollab(uint256 _collabId) external payable {
        CollabRequest storage c = collabs[_collabId];

        require(c.status == CollabStatus.OPEN, "Collab not open");
        require(msg.value == c.mintPrice, "Incorrect funding amount");

        c.partner = msg.sender;
        c.fundsLocked = msg.value;
        c.status = CollabStatus.FUNDED;
    }

    function executeMint(uint256 _collabId) external {
        CollabRequest storage c = collabs[_collabId];

        require(msg.sender == c.creator, "Only creator can execute mint");
        require(c.status == CollabStatus.FUNDED, "Not funded yet");

        (bool success, memory byte data) = c.nftContract.call{value: c.fundsLocked}(abi.encodeWithSignature("mint()"))
        require(success, "mint failed!");

        c.status = Co
        llabStatus.MINTED;
}
    


}
