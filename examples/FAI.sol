//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "@fm/ERC20.sol";
import "@fm/Mintable.sol";
import "@fm/Burnable.sol";
import "@fm/Pausable.sol";
/*
* @title fmDAI
* @author Pradhumna Pancholi
* @notice A DAI like implementation of collateralized stablecoin using fm library
*/

contract FAI is ERC20, Mintable, Burnable, Pausable{

  constructor() ERC20("FAI Stablecoin", "FAI", 18){}

}
