// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.30;

import "forge-std/Test.sol";
import "../src/ERC20.sol";
import "../src/Ownable.sol";
import "../src/Mintable.sol";

// @author Pradhumna Pancholi
// @title MockERC20Test: A complete test suite to test core functionalities of an ERC-20 Token extended with Mintable//

contract MockERC20Mintable is ERC20, Ownable, Mintable{
  constructor(string memory name, string memory symbol, uint8 decimals) 
  ERC20(name, symbol, decimals)
  Ownable()
  Mintable(){}
}


contract ERC20MintableTest is Test{
  /*//////////////////////////////
          ` SETUP
  //////////////////////////////*/
  
}
