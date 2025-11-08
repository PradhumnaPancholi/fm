//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;


contract MockPriceFeed {
  uint256 public price = 10000 * 10**18;

  function setPrice(uint256 newPrice) external {
    price = newPrice;
  } 
}

import "@fm/IERC20.sol";
/*
* @author Pradhumna Pancholi
* @title FAIVault
* @dev A vault implementation for FAI (DAI like stablecoin) that contains core logic to : 
* 1. Mint
* 2. Burn
* 3. Liquidate
*/
contract FAIVault {

  MockPriceFeed public priceFeed;
  
  IERC20 public immutable fai;

  struct Position {
    uint256 collateral;
    uint256 debt;
  }

  event FAIMinted(address indexed to, uint256 indexed amount);
  uint256 public totalCollateral;
  uint256 public debt;
  uint256 public constant LIQUIDATION_RATIO = 1.5e18;
  uint256 public constant LIQUIDATION_PENALTY = 1e16;
  
  mapping(address => Position) positions;

  constructor(address faiAddress) {
    fai = IERC20(faiAddress);
    priceFeed = new MockPriceFeed();
  }

  function depositCollateralAndMint(uint256 amount) payable public returns (bool){
    require(amount > 0, "FAIVault: can not mint zero tokens");
    require(msg.value > 0, "FAIVault: can not mint with zero ETH");
    uint256 providedCollateral = (msg.value / 1e18) * priceFeed.price();
    uint256 minCollateralRequired = amount * LIQUIDATION_RATIO / 1e18;
    require(providedCollateral >= minCollateralRequired, "FAIVault: not enough collateral");
    //update state
    positions[msg.sender].collateral += msg.value;
    positions[msg.sender].debt += amount; 
    totalCollateral += msg.value;
    debt += amount;

    fai.mint(msg.sender, amount);
    emit FAIMinted(msg.sender, amount);
  }
  function burnAndWithdrawCollateral() public {}
  function liquidate() public{}
}
