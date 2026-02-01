// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Qollabb {
    // Defining collab logic here
    struct CollabRequest {
        address creator;
        address partner;
        uint256 creatorShare; // percentage
        uint256 partnerShare; // percentage
        uint256 fundsLocked; // in wei
        CollabStatus status;
    }

    enum CollabStatus {
        OPEN,
        ACCEPTED,
        COMPLETED
    }
    mapping(uint256 => CollabRequest) public collabs;
    uint256 public collabCount;

    function createCollab(
        address _partner,
        uint256 _creatorShare,
        uint256 _partnerShare
    ) external returns (uint256) {
        require(
            _creatorShare + _partnerShare == 100,
            "Combines shares must equal 100%"
        );

        uint256 collabId = collabCount;

        collabs[collabId] = CollabRequest({
            creator: msg.sender,
            partner: _partner,
            creatorShare: _creatorShare,
            partnerShare: _partnerShare,
            fundsLocked: 0,
            status: CollabStatus.OPEN
        });

        collabCount++;
        return collabId;
    }

    function lockedFunds(uint256 _collabId) external payable {
        CollabRequest storage c = collabs[_collabId];

        require(msg.sender == c.partner, "only partner can lock funds");
        require(c.status == CollabStatus.OPEN, "Collab not open");
        require(msg.value > 0, "Send ETH to lock funds");

        c.fundsLocked = msg.value;
        c.status = CollabStatus.ACCEPTED;
    }
}
