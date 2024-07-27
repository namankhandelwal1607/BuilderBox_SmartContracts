// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Contractor {

    struct Info {
        address addressContractor;
        string name;
        string resume;
    }

    Info[] public infos;
    mapping(address => bool) public hasAddedContractor;

    event ContractorAdded(
        address addressContractor,
        string name,
        string resume
    );

    function addContractor(
        string memory _name,
        string memory _resume
    ) public {
        require(!hasAddedContractor[msg.sender], "You can only add one contractor.");

        infos.push(Info({
            addressContractor: msg.sender,
            name: _name,
            resume: _resume
        }));

        hasAddedContractor[msg.sender] = true;

        emit ContractorAdded(
            msg.sender,
            _name,
            _resume
        );
    }

    function getContractors(uint index) public view returns (
        address contractorAddress,
        string memory name,
        string memory resume
    ) {
        Info storage contractor = infos[index];
        return (
            contractor.addressContractor,
            contractor.name,
            contractor.resume
        );
    }

    function getContractorLength() public view returns (uint) {
        return infos.length;
    }
}
