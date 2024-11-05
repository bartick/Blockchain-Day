// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Escrow {
    address public buyer;
    address payable public seller;
    address public arbiter;
    uint256 public depositAmount;
    bool public isFunded;

    event DepositMade(address indexed buyer, uint256 amount);
    event ReleasedToSeller(address indexed seller, uint256 amount);
    event RefundedToBuyer(address indexed buyer, uint256 amount);

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can call this function.");
        _;
    }

    modifier onlyArbiter() {
        require(msg.sender == arbiter, "Only the arbiter can call this function.");
        _;
    }

    constructor(address _buyer, address payable _seller, address _arbiter) {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
        isFunded = false;
    }

    // Buyer deposits funds into the escrow
    function deposit() external payable onlyBuyer {
        require(!isFunded, "Funds have already been deposited.");
        require(msg.value > 0, "Deposit amount must be greater than zero.");

        depositAmount = msg.value;
        isFunded = true;

        emit DepositMade(buyer, depositAmount);
    }

    // Release funds to the seller, callable by the buyer or the arbiter
    function releaseToSeller() external {
        require(isFunded, "No funds in escrow.");
        require(msg.sender == buyer || msg.sender == arbiter, "Only the buyer or arbiter can release funds to seller.");

        isFunded = false;
        seller.transfer(depositAmount);

        emit ReleasedToSeller(seller, depositAmount);
    }

    // Refund funds to the buyer, callable only by the arbiter
    function refundToBuyer() external onlyArbiter {
        require(isFunded, "No funds in escrow.");

        isFunded = false;
        payable(buyer).transfer(depositAmount);

        emit RefundedToBuyer(buyer, depositAmount);
    }
}
