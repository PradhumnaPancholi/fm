//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Ownable.sol";
import "../src/ERC20.sol";

//@author Pradhumna Pancholi
//@notice MockOwnableERC20Token - A mock implementation of ERC20 token with ownable access control
contract MockOwnableERC20Token is ERC20, Ownable {
    //@dev This deploys a mock ERC-20 token, and makes the deploying address its "owner"
    constructor(string memory name, string memory symbol, uint8 decimals)
        ERC20(name, symbol, decimals)
//        Ownable()
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}

// @author Pradhumna Pancholi
// @title OwnableTest
// @dev OwnableTest - A complete test suite for core functionalities of Ownable.sol
contract OwnableTest is Test {
    MockOwnableERC20Token public token;

    address public owner;
    address public alice;
    address public bob;
    address public charlie;
    /*////////////////////////////////
                SETUP
    ///////////////////////////////*/

    function setUp() public {
        owner = address(this);
        alice = makeAddr("alice");
        bob = makeAddr("bob");

        token = new MockOwnableERC20Token("Ownable ERC-20 Token", "OTK", 18);
    }

    function test_OwnerAddress() public {
        assertEq(token.owner(), owner);
    }

    function test_TransferOwnershipEmitsEvent() public {
        vm.expectEmit();
        emit OwnershipTransferred(owner, alice);
        vm.prank(owner);
        token.transferOwnership(alice);
    }

    function test_OwnerCanSetNewOwner() public {
        vm.prank(owner);
        token.transferOwnership(alice);
        assertEq(token.owner(), alice);
    }

    function test_RevertsWhen_NewOwnerIsZero() public {
        vm.expectRevert("Ownable: Zero address can not be an owner");
        vm.prank(owner);
        token.transferOwnership(address(0));
    }

    function test_RevertsWhen_NonOwnerCallsMint() public {
        vm.expectRevert("Ownable: Only owner can perform this action");
        vm.prank(alice);
        token.mint(alice, 5);
    }

    /*///////////////////////////////////////////////////
                        Events
    //////////////////////////////////////////////////*/
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
}
