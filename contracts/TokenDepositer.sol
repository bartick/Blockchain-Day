// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Minimal IERC20 interface implementation
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract TokenDepositor {
    IERC20 public tokenA;       // Token that users will deposit
    IERC20 public rewardToken;  // Token given as reward
    address public owner;
    uint256 public requiredDepositAmount = 10 * (10 ** 18);  // 10 tokens with 18 decimals
    uint256 public rewardAmount = 5 * (10 ** 18);            // Reward amount (adjust as needed)

    event Deposited(address indexed user, uint256 amount);
    event Rewarded(address indexed user, uint256 reward);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor(address _tokenA, address _rewardToken) {
        tokenA = IERC20(_tokenA);
        rewardToken = IERC20(_rewardToken);
        owner = msg.sender;
    }

    // Set the reward amount (only owner can adjust it)
    function setRewardAmount(uint256 _rewardAmount) external onlyOwner {
        rewardAmount = _rewardAmount;
    }

    // Users deposit 10 TokenA to receive RewardToken
    function deposit() external {
        require(tokenA.balanceOf(msg.sender) >= requiredDepositAmount, "Insufficient TokenA balance.");
        require(tokenA.allowance(msg.sender, address(this)) >= requiredDepositAmount, "Approve TokenA first.");

        // Transfer 10 TokenA from the user to this contract
        tokenA.transferFrom(msg.sender, address(this), requiredDepositAmount);

        // Transfer reward tokens to the user
        rewardToken.transfer(msg.sender, rewardAmount);

        emit Deposited(msg.sender, requiredDepositAmount);
        emit Rewarded(msg.sender, rewardAmount);
    }

    // Owner can withdraw tokens from the contract
    function withdrawTokens(address _token, uint256 _amount) external onlyOwner {
        IERC20(_token).transfer(owner, _amount);
    }
}
