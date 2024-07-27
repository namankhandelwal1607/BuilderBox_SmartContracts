// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Dealer {

    struct Info {
        address addressDealer;
        string name;
    }

    Info[] public infos;
    mapping(address => bool) public hasAddedDealer;
    mapping(address => string) public dealerNames;

    event DealerAdded(
        address addressDealer,
        string name
    );

    function addDealer(
        string memory _name
    ) public {
        require(!hasAddedDealer[msg.sender], "You can only add one Dealer.");

        infos.push(Info({
            addressDealer: msg.sender,
            name: _name
        }));

        hasAddedDealer[msg.sender] = true;
        dealerNames[msg.sender] = _name;

        emit DealerAdded(
            msg.sender,
            _name
        );
    }

    function getDealerName(address _dealerAddress) public view returns (string memory) {
        return dealerNames[_dealerAddress];
    }

    function getDealers(uint index) public view returns (
        address addressDealer,
        string memory name
    ) {
        Info storage dealer = infos[index];
        return (
            dealer.addressDealer,
            dealer.name
        );
    }

    function getDealerLength() public view returns (uint) {
        return infos.length;
    }
}
