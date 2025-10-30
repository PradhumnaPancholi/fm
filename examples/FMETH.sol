//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "forge-std/console.sol";
import "@fm/ERC20.sol";
import "@fm/Pausable.sol";
/*
* @title fmETH
* @author Pradhumna Pancholi
* @notice And rETH like implementation of staked ether using fm library
* @dev This is an example contract to demonstrate how one can implement a staked ether using fm library
* Extends base ERC-20 contract for making and defi compabitable token.
* Extends Pausable for incident management 
* Implements shares system like rETH token
*/

contract FMETH is ERC20, Pausable{

  uint256 public totalPooledETH = 0; 
  //uint256 public totalShares = 0;
  uint256 public lastUpdatedTimestamp;
  uint256 public immutable aprBPS = 400;
  
  /*
  * @dev Emitted when ether is deposited to mint rETH
  * @param account Account that minted the depositted eth
  * @param amount Amount of ether deposited 
  * @param shares Shares of the pool the caller gets upon minting, essentially amount of fmETH minted
  */
  event Deposited(address indexed account, uint256 indexed amount, uint256 indexed shares);
  /*
  * @notice Emitted when a user withdraws deposited ether with yield, essentially burn fmETH
  * @param account Account that triggerd the withdraw function
  * @param ethAmount Amount of ether thats withdrawn from the pool
  * @param shares Amount of share (a.k.a fmETH tokens ) that were burned to withdraw ether.
  */
  event Withdrawn(address indexed account, uint256 indexed ethAmount, uint256 indexed shares);

  /*
  * @notice Emitted whenever a transaction is performed that needs to check rewards. This event is track yield earned whenever deposit or withdraw was performed for tracking protocl accuracy.
  * @param rewards Rewards earned so far
  * @param totalPooledETH Amount of ether in pool with earned rewards
  */
  event RewardsCompounded(uint256 indexed rewards, uint256 indexed totalPooledETH);

  /*
  * @notice Initialized the contract and sets lastUpdatedTimestamo for tracking rewards
  */

  constructor()
  ERC20("Freakishly Mesmerising Ether", "fmETH", 18){
    lastUpdatedTimestamp = block.timestamp;
  }

  //function balanceOf(address account) public view override returns (uint256) {
  //  bytes32 slot = keccak256(abi.encode(account, uint256(4)));
  //  uint256 accountBalance;
  //  
  //  assembly {
  //    accountBalance := sload(slot)
  //  }
  //  return accountBalance;
  //}

  function _burn(address account, uint256 amount) internal override { 
    require(account != address(0), "fmETH: zero address");
    require(_balances[account] >= amount, "fmETH: insufficient balance");
    
    _balances[account] -= amount;
    _totalSupply -= amount;
     
    emit Transfer(account, address(0), amount);  
  }
  /*
  * @notice Gets triggered when a user deposits ether to mint fmETH
  * @dev Checks if:
  * 1. min value is 0.1 ether to avoid dust transaction
  * 2. adds eth to pool
  * Emits "Deposited" event upon successfull transaction
  * mints fmETH 
  */ 
  function deposit() public payable whenNotPaused {
    require(msg.value >= 0.1 ether,  "fmETH: Need minimum deposit of 0.1 ether");
    _updateRewards(); // ← UPDATE REWARDS FIRST
    uint256 newShares = getSharesByPooledETH(msg.value);
    totalPooledETH += msg.value;
   // totalShares += newShares;

    _mint(msg.sender, newShares);

    emit Deposited(msg.sender, msg.value, newShares);
  }

  /*
  * @notice Withdraws requested amount of ethers and burns fmETH accordingly to handle positions
  * Emits "Withdrwan" event upon successfull transaction 
  * @custom:security Makes sure the contract is not paused to handle incident management 
  */

  function withdraw(uint256 shares, uint256 minETHAmount) public whenNotPaused() {
    //console.log("withdraw start");
    _updateRewards();
    uint256 ethAmount = getPooledETHByShares(shares);
    require(ethAmount >= minETHAmount, "fmETH: slippage too high");
    require(totalPooledETH >= ethAmount, "fmETH: amount too high");
    totalPooledETH -= ethAmount;
    //totalShares -= shares;

    _burn(msg.sender, shares);
    payable(msg.sender).transfer(ethAmount);

    emit Withdrawn(msg.sender, ethAmount, shares);
  }

  /*
  * @notice Updates rewards accured so far to account for shares 
  * @notice Used interally whenever "deposit" and "withdraw" are called for accurate account keeping
  * Emits RewardsCompounded to monitor rewards alongside necessary trnasaction
  * @custom:security Uses order of operation to keep contract safe from overflow 
  */
  function _updateRewards() internal {
    uint256 timeElasped = block.timestamp - lastUpdatedTimestamp;
    if(timeElasped > 0) {
      uint256 rewards = (timeElasped * totalPooledETH * aprBPS) / (10000 * 365 days) ;
      totalPooledETH += rewards;
      lastUpdatedTimestamp = block.timestamp;
      emit RewardsCompounded(rewards, totalPooledETH);
    }
  }

  function timeDebug() public view returns (uint256, uint256, uint256) {
    return (block.timestamp, lastUpdatedTimestamp, totalPooledETH);
  }
  /*
  * @notice Checks how much shares does a user get upon deposit and withdrawal //
  * @dev Calculates shares for amount of ether deposited in pool. Catches edge case for initial stage when its zero.
  */
  function getSharesByPooledETH(uint256 ethAmount) public view returns(uint256) {
    if(totalSupply() == 0) {
      return ethAmount;
    }
    uint256 shares = ethAmount * totalSupply() / totalPooledETH ;
    return shares; 
  }

  /*
  * @notice Calculates how much ether is an user entitled to based on their shares
  */
  function getPooledETHByShares(uint256 shares) public view returns(uint256) {
    if(totalPooledETH == 0) {
      return shares;
    }
    uint256 pooledETH = shares * totalPooledETH / totalSupply();
    return pooledETH;
  }

  receive() external payable {
    deposit();
  }

}
