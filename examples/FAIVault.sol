//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

contract MockPriceFeed {
  uint256 public price = 10000 * 10**18;

  function setPrice(uint256 newPrice) external {
    price = newPrice;
  } 
}
/*
* @author Pradhumna Pancholi
* @title FAIVault
* @dev A vault implementation for FAI (DAI like stablecoin) that contains core logic to : 
* 1. Mint
* 2. Burn
* 3. Liquidate
*/
contract FAIVault {
  struct Position {
    uint256 collateral;
    uint256 debt;
  }

  uint256 public totalCollateral;
  uint256 public debt;
  uint256 public constant immutable LIQUIDATION_RATIO = 150 * 10**16;
  uint256 public constant immutable LIQUIDATION_PENALTY = 10 * 10**16;
  mapping(address => Position) positions;

  function depositCollateralAndMint() public{}
  function burnAndWithdrawCollateral() public {}
  function liquidate() public{}
}
