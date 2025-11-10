//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;


contract MockPriceFeed {
  uint256 public price = 10000 * 10**18;

  function setPrice(uint256 newPrice) external {
    price = newPrice;
  } 
}

import "@fm/IMintableERC20.sol";

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
  
  IMintableERC20 public immutable fai;

  struct Position {
    uint256 collateral;
    uint256 debt;
  }

  event FAIMinted(address indexed account, uint256 indexed amount);
  event FAIBurned(address indexed account, uint256 indexed amount);
  event FAIPositionLiquidated(address indexed account, uint256 indexed ethAmount, uint256 indexed faiAmount);
  
  uint256 public totalCollateral;
  uint256 public debt;
  uint256 public constant LIQUIDATION_RATIO = 1.5e18;
  uint256 public constant LIQUIDATION_PENALTY = 1e16;
  
  mapping(address => Position) positions;

  constructor(address faiAddress) {
    fai = IMintableERC20(faiAddress);
    priceFeed = new MockPriceFeed();
  }

  function depositCollateralAndMint(uint256 amount) payable public returns (bool){
    require(amount > 0, "FAIVault: can not mint zero tokens");
    require(msg.value > 0, "FAIVault: can not mint with zero ETH");
    
    uint256 providedCollateral = (msg.value * priceFeed.price()) / 1e18;
    uint256 minCollateralRequired = amount * LIQUIDATION_RATIO / 1e18;
    require(providedCollateral >= minCollateralRequired, "FAIVault: not enough collateral");
   
    positions[msg.sender].collateral += msg.value;
    positions[msg.sender].debt += amount; 
    totalCollateral += msg.value;
    debt += amount;

    fai.mint(msg.sender, amount);
    emit FAIMinted(msg.sender, amount);
    return true;
  }

  function burnAndWithdrawCollateral(uint256 faiToBurn, uint256 ethToWithdraw) public returns (bool){
    require(faiToBurn > 0, "FAIVault: can not burn zero tokens");
    
    uint256 ethValueForFai = (faiToBurn * priceFeed.price()) / 1e18;
    //uint256 collateralToWithdraw = amount * LIQUIDATION_RATIO / 1e18;
    require(ethValueForFai >= ethToWithdraw, "FAIVault: ETH withdrawal amount too high");
    positions[msg.sender].collateral -= ethToWithdraw;
    positions[msg.sender].debt -= faiToBurn;
    totalCollateral -= ethToWithdraw;
    debt -= faiToBurn;

    emit FAIBurned(msg.sender, faiToBurn);
    fai.burn(msg.sender, faiToBurn);
    payable(msg.sender).transfer(ethToWithdraw);
    return true;
  }

  function _getCollateralRatio(address user) internal view returns (uint256) {
    Position memory position = positions[user];
    
    if(position.debt == 0) return type(uint256).max;

    uint256 collateralValue = (position.collateral * 1e18 )/ priceFeed.price();
    return (collateralValue * 1e18) / position.debt;
  }

  function _calculateMaxLiquidation(address user) internal view returns (uint256){
    Position memory position = positions[user];
    return position.debt / 2;
  }
 
  function liquidate(address user) public{
    require(LIQUIDATION_RATIO > _getCollateralRatio(user) , "FAIVault: position is safe");

    uint256 faiToLiquidate = _calculateMaxLiquidation(user);
    fai.transferFrom(msg.sender, address(this), faiToLiquidate);

    uint256 ethForLiquidation = (faiToLiquidate * 1e18) / priceFeed.price();
    uint256 discountedETH = ethForLiquidation * (1e18 - LIQUIDATION_PENALTY) / 1e18;

    positions[user].collateral -= discountedETH;
    positions[user].debt -= faiToLiquidate;
    totalCollateral -= discountedETH;
    debt -= faiToLiquidate;

    payable(msg.sender).transfer(discountedETH);

    fai.burn(address(this), faiToLiquidate);

    emit FAIPositionLiquidated(user, discountedETH, faiToLiquidate);
  }
}
