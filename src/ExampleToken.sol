//SPDX-License-Identifier: GPL.3.0
pragma solidity ^0.8.0;

import "./token/ERC20.sol";
import "./Mintable.sol";

contract ExampleToken is ERC20, Mintable{

  constructor() ERC20("ExampleToken", "EXT", 18){
    // Mints 100 TST tokens for initial supply
    _mint(msg.sender, 100 * 10**18);
  }

  //Mintinging another batch of token.
  //Resolves mint override
  function _mint(address to, uint256 amount) internal override(ERC20, Mintable) {
    ERC20._mint(msg.sender, 100 * 10**18);
  } 


}

