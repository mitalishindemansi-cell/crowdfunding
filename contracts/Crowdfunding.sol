// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public totalFunds;
    uint public deadline;
    mapping(address => uint) public contributions;
    bool public goalReached;

    constructor(uint _goal, uint _durationInDays) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + (_durationInDays * 1 days);
    }

    // Function 1: Contribute ETH to the campaign
    function contribute() external payable {
        require(block.timestamp < deadline, "Funding period has ended");
        require(msg.value > 0, "Contribution must be greater than zero");
        contributions[msg.sender] += msg.value;
        totalFunds += msg.value;

        if (totalFunds >= goal) {
            goalReached = true;
        }
    }

    // Function 2: Allow the owner to withdraw funds once the goal is met
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(goalReached, "Goal not reached yet");
        payable(owner).transfer(address(this).balance);
    }

    // Function 3: Refund contributors if the goal was not reached before deadline
    function refund() external {
        require(block.timestamp > deadline, "Campaign still active");
        require(!goalReached, "Goal was reached, refund not available");
        uint amount = contributions[msg.sender];
        require(amount > 0, "No funds to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    // Function 4: Check remaining time for campaign
    function getTimeLeft() external view returns (uint) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }
}
