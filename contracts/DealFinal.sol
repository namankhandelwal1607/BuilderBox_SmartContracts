// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Deal.sol";
import "./Sequence.sol";
import "./Request.sol";
import "./DealNFT.sol"; // Import the NFT contract

contract DealFinal {
    struct DealFinalised {
        uint256 dealId;
        bool finalised;
        string comment;
    }

    mapping(uint256 => DealFinalised) public dealFinalised;
    mapping(address => uint256[]) public contractorDeals; // Mapping to track all deals by contractor
    Deal public deal;
    Sequence public sequence;
    Request public request;
    DealNFT public nftContract; // NFT contract

    constructor(
        address _deal,
        address _sequence,
        address _request,
        address _nftContract
    ) {
        deal = Deal(_deal);
        sequence = Sequence(_sequence);
        request = Request(_request);
        nftContract = DealNFT(_nftContract); // Initialize NFT contract
    }

    function findSuggestAmount(address contractorAddress, uint256 dealId) public view returns (uint256) {
        Request.Interest[] memory interests = request.getInterests(contractorAddress);
        uint256 suggestAmount = 0;
        bool found = false;

        for (uint256 i = 0; i < interests.length; i++) {
            if (interests[i].dealId == dealId) {
                suggestAmount = interests[i].suggestAmount;
                found = true;
                break;
            }
        }

        require(found, "No interest with dealId found");
        return suggestAmount;
    }

    event DealDone(uint256 dealId);

    function doingDeal(uint256 _dealId) public {
        (
            address dealerAddress,
            string memory dealerName,
            string memory dealName,
            uint256 amount,
            ,
            ,
            ,
            ,
            ,
            ,
        ) = deal.getDealDetails(_dealId);

        if (sequence.getSequenceCount(_dealId) == 0) {
            if (request.getContractorsByDeal(_dealId).length == 0) {
                dealFinalised[_dealId] = DealFinalised({
                    dealId: _dealId,
                    finalised: true,
                    comment: "No Contractors Applied"
                });
            } else {
                dealFinalised[_dealId] = DealFinalised({
                    dealId: _dealId,
                    finalised: true,
                    comment: "All contractors out of budget!!"
                });
            }

            deal.transferFunds(_dealId, dealerAddress, amount - 100);
        } else {
            address contractorAddress = sequence.getSequence(_dealId)[0].contractor;

            uint256 finalAmount = findSuggestAmount(contractorAddress, _dealId);
            require(finalAmount <= amount, "Final amount exceeds deal amount");

            uint256 transferAmountContractor = finalAmount;
            uint256 transferAmountDealer = amount - finalAmount;

            deal.transferFunds(_dealId, contractorAddress, transferAmountContractor);
            deal.transferFunds(_dealId, dealerAddress, transferAmountDealer);

            // Create the NFT metadata JSON
            string memory metadata = string(
                abi.encodePacked(
                    '{"name":"', dealName,
                    '", "description":"Deal between ', dealerName,
                    ' and contractor", "amount":', Strings.toString(amount), 
                    '}'
                )
            );

            // Mint NFT to the contractor with the metadata
            uint256 nftTokenId = nftContract.mintNFT(contractorAddress, metadata);

            // Record deal finalization
            dealFinalised[_dealId] = DealFinalised({
                dealId: _dealId,
                finalised: true,
                comment: "Deal Done"
            });

            // Add deal ID to contractor's deal list
            if (contractorAddress != address(0)) {
                contractorDeals[contractorAddress].push(_dealId);
            }

            emit DealDone(_dealId);
        }
    }

    function isDealFinalised(uint256 _dealId) public view returns (bool, string memory) {
        return (
            dealFinalised[_dealId].finalised,
            dealFinalised[_dealId].comment
        );
    }

    // Function to get all deal IDs for a specific contractor
    function getContractorDeals(address contractorAddress) public view returns (uint256[] memory) {
        return contractorDeals[contractorAddress];
    }

    // Function to get both contractor address and dealer address by deal ID
    function getAddressesByDealId(uint256 _dealId) public view returns (address contractorAddress, address dealerAddress) {
        (
            dealerAddress,
            ,
            ,
            ,
            ,
            ,
            ,
            ,
            ,
            ,
        ) = deal.getDealDetails(_dealId);

        if (sequence.getSequenceCount(_dealId) > 0) {
            contractorAddress = sequence.getSequence(_dealId)[0].contractor;
        } else {
            contractorAddress = address(0);
        }

        return (contractorAddress, dealerAddress);
    }
}
