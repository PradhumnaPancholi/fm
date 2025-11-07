//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "@fm/IERC20.sol";
import "forge-std/console.sol";

library TransferHelper {
 
  error TransferFailed();
  error TransferFromFailed();
  error ApprovalFailed();
  error ETHTransferFailed();

  /*
  * @notice Safely transfer ERC20 tokens
  * @param token The address for token to be transfered
  * @param to The address to which token needs to be transfered
  * @param amount The amount of given token to be transfered
  * @dev Moves forward if there is no return data to accomodate for non-standard token like USDT
  * @custom:security Takes a conservative approach to validate return data. If the there is return data, it needs to be exactly TRUE
  */
  function safeTransfer(address token, address to, uint256 amount) internal {
    (bool success, bytes memory data) = token.call(
      abi.encodeWithSelector(IERC20.transfer.selector, to, amount)
    );
    //first check: if the call succeed at first
    if(!success) revert TransferFailed();

    //second check: if there's any return data and validate it
    if(data.length > 0) {
      // Only accept if the return data is clearly true
      // prevents from accepting non-standard return value
      if(data.length >= 32) {
        if(!abi.decode(data, (bool))) revert TransferFailed();
      }else{
        //revert at non-standard data length, conservative approach
        revert TransferFailed();
      }
    // succeed at no return data. Important for non-standard tokens like USDT
    }
  }

  /*
  * @notice Safely transfer  ERC20 tokens from approved accounts.
  * @param token The address for token to be transfered
  * @param from The address from which the given token needs to be sent
  * @param to The address to which token needs to be transfered
  * @param amount The amount of given token to be transfered
  * @dev Moves forward if there is no return data to accomodate for non-standard token like USDT
  * @custom:security Takes a conservative approach to validate return data. If the there is return data, it needs to be exactly TRUE
  */

  function safeTransferFrom(address token, address from, address to, uint256 amount) internal{
    (bool success, bytes memory data) = token.call(
      abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, amount)
    );
    //first check: if the call succeed at first
    if(!success) revert TransferFailed();
    //second check: if there's any return data and validate it
    if(data.length > 0) {
      // Only accept if the return data is clearly true
      // prevents from accepting non-standard return value
      if(data.length >= 32) {
        if(!abi.decode(data, (bool))) revert TransferFailed();
      }else{
        //revert at non-standard data length, conservative approach
        revert TransferFailed();
      }
    // succeed at no return data. Important for non-standard tokens like USDT
    }
  }


  /*
  * @notice Update "allowance" or the amount a specific address is allowed to spend from another ("owner") address.
  * @param token The address for token to add allowance for
  * @param from The address that is allowed to spend the "amount" of tokens from "owner"
  * @param amount The amount of given token that is allowed to be spend by "spender"
  * @dev Moves forward if there is no return data to accomodate for non-standard token like USDT
  * @custom:security This function resets the allowance to zero at first. And then updates it to given amount. This is to be explicit about allowances as it can lead to loss of funds if not handled properly. It is more secure to perform multiple "approve" transaction than one single "max" approve.
  */ 
  function safeApprove(address token, address spender, uint256 amount) internal{
    (bool success, bytes memory data) = token.call(
      abi.encodeWithSelector(IERC20.approve.selector, spender, amount)
    );

    if(!success) revert ApprovalFailed();
    if(data.length >=32 && !abi.decode(data, (bool))) revert ApprovalFailed();
    // Resets approval to zero
 //   IERC20(token).approve(spender, 0);
    
   // if(amount > 0){
    //  IERC20(token).approve(spender, amount);
    //}
//    if(amount > 0) {
//      (bool success, bytes memory data) = token.call(
//        abi.encodeWithSelector(IERC20.approve.selector, spender, amount)
//      );
//      console.log("second call, set to amount", success);
//      console.log("second data length", data.length);
//      if(!success) revert ApprovalFailed();
//      if(data.length>= 32 ) {
//        bool returnValue = abi.decode(data, (bool));
//        if(!returnValue) {
//          console.log("returnvalue", returnValue);
//          revert ApprovalFailed();
//        }
//      }
//    }
//    console.log("safe approve ends");
  }

  /*
  * @notice Sends ETH to a given account with gas limit for efficiency and security.
  * @param to The address to which ETH is supposed to be sent
  * @param amount The amount of ETH to be sent
  */
  function safeTransferETH(address to, uint256 amount) internal {
    bool success;

    assembly {
      success := call(30000,to,amount, 0,0,0,0)
    }

    if(!success) revert ETHTransferFailed();
  }

  /*
  * @notice To get balance of an token, handy for non-standard tokens
  * @param token The address for the token to get balance for
  * @param account The addres whose balance is needed for the given token
  */
  function getBalance(address token, address account) internal returns (uint256){
    (bool success, bytes memory data) = token.call(
      abi.encodeWithSelector(IERC20.balanceOf.selector, account)
    );
    
    require(success && data.length >=32, "TransferHelper: balance query failed!");
    return abi.decode(data, (uint256));
  }

}
