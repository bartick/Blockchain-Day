// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Crowdfund {
    struct Request {
        address payable requester;
        uint256 amountNeeded;
        uint256 amountCollected;
        bool fulfilled;
    }

    mapping(address => Request) public requests;
    mapping(address => bool) public requestActive;

    event RequestCreated(address indexed requester, uint256 amountNeeded);
    event DonationReceived(address indexed donor, address indexed requester, uint256 amount);
    event RequestFulfilled(address indexed requester);

    // Create a new funding request. Each address can have only one active request at a time.
    function createRequest(uint256 _amountNeeded) external {
        require(!requestActive[msg.sender], "You already have an active request.");
        require(_amountNeeded > 0, "Requested amount must be greater than 0.");

        // Initialize a new request
        requests[msg.sender] = Request({
            requester: payable(msg.sender),
            amountNeeded: _amountNeeded,
            amountCollected: 0,
            fulfilled: false
        });
        requestActive[msg.sender] = true;

        emit RequestCreated(msg.sender, _amountNeeded);
    }

    // Function for people to donate to a specific request
    function donate(address _requester) external payable {
        require(requestActive[_requester], "No active request for this address.");
        require(_requester != msg.sender, "You cannot donate to your own request.");
        require(!requests[_requester].fulfilled, "This request has already been fulfilled.");
        require(msg.value > 0, "Donation must be greater than 0.");

        // Update the amount collected
        requests[_requester].amountCollected += msg.value;

        emit DonationReceived(msg.sender, _requester, msg.value);

        // Check if the funding goal is reached
        if (requests[_requester].amountCollected >= requests[_requester].amountNeeded) {
            requests[_requester].fulfilled = true;
            requestActive[_requester] = false;

            // Transfer collected funds to the requester
            requests[_requester].requester.transfer(requests[_requester].amountCollected);

            emit RequestFulfilled(_requester);
        }
    }

    // Get the details of a specific request
    function getRequestDetails(address _requester) external view returns (
        address requester,
        uint256 amountNeeded,
        uint256 amountCollected,
        bool fulfilled
    ) {
        Request memory request = requests[_requester];
        return (
            request.requester,
            request.amountNeeded,
            request.amountCollected,
            request.fulfilled
        );
    }
}
