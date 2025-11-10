//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "@fm/ERC20.sol";
import "@fm/Mintable.sol";

/*
* @title FAI
* @author Pradhumna Pancholi
* @notice A DAI like implementation of collateralized stablecoin using fm-library
*/

contract FAI is ERC20, Mintable{

  constructor() ERC20("FAI Stablecoin", "FAI", 18){}

  function mint(address to, uint256 amount) external onlyMinter {
    _mint(to,amount);
  }

  function burn(address from, uint256 amount) public onlyMinter {
    _burn(from, amount);
  }
}
