// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Dealer.sol";

contract Deal {
    struct DealInfo {
        address dealerAddress;
        string dealerName;
        string dealName;
        uint256 amount;
        uint256 needFinancialCapabilities;
        uint256 needTechCapabilities;
        uint256 needExperience;
        uint256 needPerformance;
        uint256 needHealthAndSafety;
        uint256 dealOpeningTime;
        uint256 dealClosingTime;
    }

    DealInfo[] public deals;
    mapping(address => uint[]) public dealerDeals;
    Dealer public dealerContract;

    event DetailsAdded(
        address indexed dealerAddress,
        string dealerName,
        string dealName,
        uint256 amount,
        uint256 needFinancialCapabilities,
        uint256 needTechCapabilities,
        uint256 needExperience,
        uint256 needPerformance,
        uint256 needHealthAndSafety,
        uint256 dealOpeningTime,
        uint256 dealClosingTime
    );

    constructor(address _dealerContractAddress) {
        dealerContract = Dealer(_dealerContractAddress);
    }

    function addDetails(
        string memory _dealName,
        uint256 _needFinancialCapabilities,
        uint256 _needTechCapabilities,
        uint256 _needExperience,
        uint256 _needPerformance,
        uint256 _needHealthAndSafety,
        uint256 _dealClosingTime
    ) public payable {
        string memory _dealerName = dealerContract.getDealerName(msg.sender);
        require(bytes(_dealerName).length > 0, "Dealer not registered.");

        deals.push(DealInfo({
            dealerAddress: msg.sender,
            dealerName: _dealerName,
            dealName: _dealName,
            amount: msg.value,
            needFinancialCapabilities: _needFinancialCapabilities,
            needTechCapabilities: _needTechCapabilities,
            needExperience: _needExperience,
            needPerformance: _needPerformance,
            needHealthAndSafety: _needHealthAndSafety,
            dealOpeningTime: block.timestamp,
            dealClosingTime: _dealClosingTime
        }));

        uint dealId = deals.length - 1;
        dealerDeals[msg.sender].push(dealId);

        emit DetailsAdded(
            msg.sender,
            _dealerName,
            _dealName,
            msg.value,
            _needFinancialCapabilities,
            _needTechCapabilities,
            _needExperience,
            _needPerformance,
            _needHealthAndSafety,
            block.timestamp,
            _dealClosingTime
        );
    }

    function getDealDetails(uint256 index) public view returns (
        address dealerAddress,
        string memory dealerName,
        string memory dealName,
        uint256 amount,
        uint256 needFinancialCapabilities,
        uint256 needTechCapabilities,
        uint256 needExperience,
        uint256 needPerformance,
        uint256 needHealthAndSafety,
        uint256 dealOpeningTime,
        uint256 dealClosingTime
    ) {
        DealInfo storage deal = deals[index];
        return (
            deal.dealerAddress,
            deal.dealerName,
            deal.dealName,
            deal.amount,
            deal.needFinancialCapabilities,
            deal.needTechCapabilities,
            deal.needExperience,
            deal.needPerformance,
            deal.needHealthAndSafety,
            deal.dealOpeningTime,
            deal.dealClosingTime
        );
    }

    function dealCount() public view returns (uint256) {
        return deals.length;
    }

    function getDealsByDealer(address _dealerAddress) public view returns (
        DealInfo[] memory
    ) {
        uint[] storage dealIds = dealerDeals[_dealerAddress];
        DealInfo[] memory dealerSpecificDeals = new DealInfo[](dealIds.length);

        for (uint256 i = 0; i < dealIds.length; i++) {
            dealerSpecificDeals[i] = deals[dealIds[i]];
        }

        return dealerSpecificDeals;
    }

    function getDealIdsByDealer(address _dealerAddress) public view returns (uint256[] memory) {
        return dealerDeals[_dealerAddress];
    }

    function transferFunds(uint256 _dealId, address _contractor, uint256 _amount) external {
        DealInfo storage deal = deals[_dealId];
        require(deal.dealClosingTime < block.timestamp, "Deal is still open");
        require(_amount <= deal.amount, "Insufficient deal amount");

        payable(_contractor).transfer(_amount);
    }
}
