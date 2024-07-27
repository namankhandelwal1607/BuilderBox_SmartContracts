// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Contractor.sol";
contract VerifiedContractor{
     
    struct modifiedContractor{
        address addressContractor;
        string name;
        uint256 rateFinancialCapabilities;
        uint256 rateTechCapabilities;
        uint256 rateExperience;
        uint256 ratePerformance;
        uint256 rateHealthAndSafety;
    }

    mapping(address => modifiedContractor) public verifiedContractors;
    Contractor public contractor;

    event contractorUpdated(
        address indexed addressContractor,
        string name,
        uint256 rateFinancialCapabilities,
        uint256 rateTechCapabilities,
        uint256 rateExperience,
        uint256 ratePerformance,
        uint256 rateHealthAndSafety
    );

    constructor(address _contractorAddress){
        contractor = Contractor(_contractorAddress);
    }

    function updateContract(
        uint index,
        uint256 rateFinancialCapabilities,
        uint256 rateTechCapabilities,
        uint256 rateExperience,
        uint256 ratePerformance,
        uint256 rateHealthAndSafety
    ) public {

        require(index < contractor.getContractorLength(), "Invalid contractor index");
         (
            address contractorAddress,
            string memory name,
        ) = contractor.getContractors(index);

        verifiedContractors[contractorAddress] = modifiedContractor({
            addressContractor: contractorAddress,
            name: name,
            rateFinancialCapabilities: rateFinancialCapabilities,
            rateTechCapabilities: rateTechCapabilities,
            rateExperience: rateExperience,
            ratePerformance: ratePerformance,
            rateHealthAndSafety: rateHealthAndSafety
        });

        emit contractorUpdated(
            contractorAddress,
            name,
            rateFinancialCapabilities,
            rateTechCapabilities,
            rateExperience,
            ratePerformance,
            rateHealthAndSafety
        );
    }

    function getVerifiedContractor(address _contractorAddress) public view returns(
        address contractorAddress,
        string memory name,
        uint256 rateFinancialCapabilities,
        uint256 rateTechCapabilities,
        uint256 rateExperience,
        uint256 ratePerformance,
        uint256 rateHealthAndSafety
    ){
        require(verifiedContractors[_contractorAddress].addressContractor == _contractorAddress, "Contractor not found");

    modifiedContractor storage contractors = verifiedContractors[_contractorAddress];

    contractorAddress = contractors.addressContractor;
    name = contractors.name;
    rateFinancialCapabilities = contractors.rateFinancialCapabilities;
    rateTechCapabilities = contractors.rateTechCapabilities;
    rateExperience = contractors.rateExperience;
    ratePerformance = contractors.ratePerformance;
    rateHealthAndSafety = contractors.rateHealthAndSafety; 
    }
}

    


        
    


