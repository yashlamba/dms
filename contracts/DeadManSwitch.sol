// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DeadManSwitch {
    using SafeMath for uint256;

    address payable transfer_to =
        payable(0x7BC7dBCdaddE5aE1bfa690BbEa410dE815789822);

    uint256 public lastBeat;
    address public owner;

    constructor() {
        owner = msg.sender;
        lastBeat = block.number;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    receive() external payable {}

    function transferEth() public payable onlyOwner {
        uint256 _balance = address(this).balance;
        require(_balance > 0);
        transfer_to.transfer(_balance);
    }

    function heatbeat() external onlyOwner {
        require(block.number - lastBeat <= 10);
        lastBeat = block.number;
    }

    function declareDead() external {
        require(block.number - lastBeat > 10);
        uint256 ethBalance = address(this).balance;
        transfer_to.transfer(ethBalance);
    }
}
