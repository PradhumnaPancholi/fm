//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {ERC20} "@fm/token";

// @author Pradhumna Pancholi
// @notice Implementation of fmETH that can be minted upon depositting WETH
contract fmETH is ERC20{

    // @dev This can never be changed. This address/contract controls the supply and flow of this fmETH token
    address public immutable stakingContract; 

    constructor() ERC20("Flawless Mesmerising ETH", "fmETH", 18) {
    }

    function mint(address account, uint256 amount) external {
    }

    function burn(address account, uint256 amount) external {
    }
    
}
