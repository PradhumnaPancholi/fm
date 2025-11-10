//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "@fm/IERC20.sol";

interface IMintableERC20 is IERC20 {
  function mint(address to, uint256 amount) external ;
  function burn(address from, uint256 amount) external;
}
