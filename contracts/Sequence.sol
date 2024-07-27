// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Deal.sol";
import "./Request.sol";
import "./VerifiedContractor.sol";

contract Sequence {
    struct Point {
        address contractor;
        string name;
        uint256 points;
    }

    Deal public deal;
    Request public request;
    VerifiedContractor public verifiedContractor;

    constructor(address _Deal, address _Request, address _VerifiedContractor) {
        deal = Deal(_Deal);
        request = Request(_Request);
        verifiedContractor = VerifiedContractor(_VerifiedContractor);
    }

    function calculatePoints(
        uint256 needFinancialCapabilities,
        uint256 needTechCapabilities,
        uint256 needExperience,
        uint256 needPerformance,
        uint256 needHealthAndSafety,
        uint256 rateFinancialCapabilities,
        uint256 rateTechCapabilities,
        uint256 rateExperience,
        uint256 ratePerformance,
        uint256 rateHealthAndSafety
    ) internal pure returns (uint256) {
        return needFinancialCapabilities * rateFinancialCapabilities +
               needTechCapabilities * rateTechCapabilities +
               needExperience * rateExperience +
               needPerformance * ratePerformance +
               needHealthAndSafety * rateHealthAndSafety;
    }

    function getContractorPoints(
        address contractor,
        uint256 needFinancialCapabilities,
        uint256 needTechCapabilities,
        uint256 needExperience,
        uint256 needPerformance,
        uint256 needHealthAndSafety
    ) public view returns (Point memory) {
        (
            ,
            string memory name,
            uint256 rateFinancialCapabilities,
            uint256 rateTechCapabilities,
            uint256 rateExperience,
            uint256 ratePerformance,
            uint256 rateHealthAndSafety
        ) = verifiedContractor.getVerifiedContractor(contractor);

        uint256 points = calculatePoints(
            needFinancialCapabilities,
            needTechCapabilities,
            needExperience,
            needPerformance,
            needHealthAndSafety,
            rateFinancialCapabilities,
            rateTechCapabilities,
            rateExperience,
            ratePerformance,
            rateHealthAndSafety
        );

        return Point({
            contractor: contractor,
            name: name,
            points: points
        });
    }

    function getSequence(uint256 _dealId) public view returns (Point[] memory) {
        require(_dealId < deal.dealCount(), "Invalid deal ID");

        (
            ,
            ,
            ,
            uint256 dealAmount,
            uint256 needFinancialCapabilities,
            uint256 needTechCapabilities,
            uint256 needExperience,
            uint256 needPerformance,
            uint256 needHealthAndSafety,
            ,
        ) = deal.getDealDetails(_dealId);

        uint256 count = request.getNumberByDeal(_dealId);
        address[] memory requesters = request.getContractorsByDeal(_dealId);

        Point[] memory validContractors = new Point[](count);
        uint256 validCount = 0;

        for (uint256 i = 0; i < count; i++) {
            Request.Interest[] memory interests = request.getInterests(requesters[i]);
            for (uint256 j = 0; j < interests.length; j++) {
                if (interests[j].dealId == _dealId && interests[j].suggestAmount <= dealAmount) {
                    validContractors[validCount] = getContractorPoints(
                        requesters[i],
                        needFinancialCapabilities,
                        needTechCapabilities,
                        needExperience,
                        needPerformance,
                        needHealthAndSafety
                    );
                    validCount++;
                }
            }
        }

        Point[] memory sortedValidContractors = new Point[](validCount);
        for (uint256 i = 0; i < validCount; i++) {
            sortedValidContractors[i] = validContractors[i];
        }

        for (uint256 i = 0; i < validCount - 1; i++) {
            for (uint256 j = 0; j < validCount - i - 1; j++) {
                if (sortedValidContractors[j].points < sortedValidContractors[j + 1].points) {
                    Point memory temp = sortedValidContractors[j];
                    sortedValidContractors[j] = sortedValidContractors[j + 1];
                    sortedValidContractors[j + 1] = temp;
                }
            }
        }

        return sortedValidContractors;
    }

    function getSequenceCount(uint256 _dealId) public view returns (uint256) {
        require(_dealId < deal.dealCount(), "Invalid deal ID");

        (
            ,
            ,
            ,
            uint256 dealAmount,
            ,
            ,
            ,
            ,
            ,
            ,
        ) = deal.getDealDetails(_dealId);

        uint256 count = request.getNumberByDeal(_dealId);
        address[] memory requesters = request.getContractorsByDeal(_dealId);

        uint256 validCount = 0;

        for (uint256 i = 0; i < count; i++) {
            Request.Interest[] memory interests = request.getInterests(requesters[i]);
            for (uint256 j = 0; j < interests.length; j++) {
                if (interests[j].dealId == _dealId && interests[j].suggestAmount <= dealAmount) {
                    validCount++;
                    break; // Break inner loop once valid contractor is found
                }
            }
        }

        return validCount;
    }
}
