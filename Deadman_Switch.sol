// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeadmansSwitch {
    address public owner;
    address public beneficiary;
    uint256 public lastCheckedBlock;
    uint256 public contractBalance;
    constructor(address _beneficiary) {
        owner = msg.sender;
        beneficiary = _beneficiary;
        lastCheckedBlock = block.number;
    }
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    function stillAlive() external onlyOwner {
        lastCheckedBlock = block.number;
    }
    function checkStatus() external {
        require(block.number - lastCheckedBlock <= 10, "Owner has not checked in for last 10 blocks");
        withdraw();
    }
    function withdraw() public onlyOwner {
        uint256 balanceToSend = contractBalance;
        contractBalance = 0;
        payable(beneficiary).transfer(balanceToSend);
    }
    receive() external payable {
        contractBalance += msg.value;
    }
}