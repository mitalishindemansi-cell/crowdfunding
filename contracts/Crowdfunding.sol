// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfunding {
    address public owner;
    uint public fundingGoal;
    uint public totalFunds;

    constructor(uint _fundingGoal) {
        owner = msg.sender;
        fundingGoal = _fundingGoal;
    }

    // Function 1: Allow users to contribute ETH
    function contribute() external payable {
        require(msg.value > 0, "Contribution must be greater than zero");
        totalFunds += msg.value;
    }

    // Function 2: Allow owner to withdraw once goal is met
    function withdrawFunds() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(totalFunds >= fundingGoal, "Funding goal not reached yet");
        payable(owner).transfer(address(this).balance);
    }
}

