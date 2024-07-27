// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./VerifiedContractor.sol";
import "./Deal.sol";

contract Request {
    struct Interest {
        address contractorAddress;
        uint256 dealId;
        uint256 suggestAmount; 
        uint256 contractCompleteDate;
    }

    mapping(address => Interest[]) public interests;
    mapping(uint256 => address[]) public dealRequests;
    mapping(uint256 => mapping(address => bool)) public hasRequested; 

    VerifiedContractor public verifiedContractor;
    Deal public deal;

    event InterestAdded(
        address indexed contractorAddress,
        uint256 dealId,
        uint256 suggestAmount
    );

    constructor(address _verifiedContractor, address _deal) {
        verifiedContractor = VerifiedContractor(_verifiedContractor);
        deal = Deal(_deal);
    }

    function addInterest(uint256 _dealId, uint256 _suggestAmount, uint256 _contractCompleteDate) public {
        // Ensure contractor is verified
        (
            address contractorAddress,
            ,
            ,
            ,
            ,
            ,
            
        ) = verifiedContractor.getVerifiedContractor(msg.sender);
        
        require(contractorAddress == msg.sender, "Contractor not verified");
        require(_dealId < deal.dealCount(), "Deal does not exist");
        require(!hasRequested[_dealId][msg.sender], "Interest already added for this deal");

        interests[msg.sender].push(Interest({
            contractorAddress: msg.sender,
            dealId: _dealId,
            suggestAmount: _suggestAmount,
            contractCompleteDate: _contractCompleteDate
        }));

        dealRequests[_dealId].push(msg.sender);
        hasRequested[_dealId][msg.sender] = true; // Mark that this user has made a request

        emit InterestAdded(msg.sender, _dealId, _suggestAmount);
    }

    function getInterests(address _contractor) public view returns (Interest[] memory) {
        return interests[_contractor];
    }

    function getContractorsByDeal(uint256 _dealId) public view returns (address[] memory) {
        require(_dealId < deal.dealCount(), "Deal does not exist");
        return dealRequests[_dealId];
    }

    function getNumberByDeal(uint256 _dealId) public view returns (uint256) {
        require(_dealId < deal.dealCount(), "Deal does not exist");
        address[] memory requesters = getContractorsByDeal(_dealId);

        return requesters.length;
    }
}
