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
    

    /*
    * @notice Gets the name of the token
    */
    function name() external view returns (string memory); 

    /*
    * @notice Gets the symbol of the token
    */
    function symbol() external view returns (string memory); 

    /*
    * @notice Gets the decimals for the given token. Crucial for non standard tokens like USDC
    */
    function decimals() external view returns (uint8);

    /*
    * @notice Gets the total supply for the given token
    */
    function totalSupply() external view returns (uint256); 

    /*
    * @notice Gets allowance given to different address for the given address
    * @param Owner The address that holds the token
    * @param Spender The address thats allowed to spend token on behalf of the "owner"
    * @return The amount of tokens the "spender" is allowed spend on behalf of the "owner"
    */
    function allowance(address owner, address spender) external view returns (uint256); 

    /*
    * @notice Gets the amount of tokens held my the provided account
    * @param The account for which balance you need to know
    * @return The amount of tokens held by the provided account
    */
    function balanceOf(address account) external  view returns (uint256); 

    /*
    * @notice Transfers the amount of token to given address
    * @param The address to which the tokens need to be sent
    * @param The amount of token to send to the given address
    * @return True if successull, False otherwise
    */
    function transfer(address to, uint256 amount) external returns (bool); 
    
    /*
    * @notice Approved an address to spend the token on behalf of another address
    * @param The address that needs permission to spend 
    * @param The amount that the "spender" is allowed spend on behalf of "owner"
    * @return True if the transaction was successfull. False otherwise
    */ 
    function approve(address spender, uint256 amount) external returns (bool); 


    /*
    * @notice Allows to transfer token from a wallet, given you have the "approval"
    * @param The address from which the token needs to be sent
    * @param The address to which the token needs to be sent
    * @param The amount of tokens to transfer
    * @return True if successfull. False otherwise
    */ 
    function transferFrom(address from, address to, uint256 amount) external returns (bool); 


}
