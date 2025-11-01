//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

/*
* @title IERC20
* @author Pradhumna Pancholi
* @notice An interface implementation of ERC-20 including the metadata
*/

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    


    function name() external view returns (string memory); 

    function symbol() external view returns (string memory); 

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256); 

    function allowance(address owner, address spender) external view returns (uint256); 

    function balanceOf(address account) external  view returns (uint256); 

    function transfer(address to, uint256 amount) external returns (bool); 
    
    function approve(address spender, uint256 amount) external returns (bool); 

    function transferFrom(address from, address to, uint256 amount) external returns (bool); 


}
