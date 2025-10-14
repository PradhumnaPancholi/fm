//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "@fm/token/ERC20.sol";

// @notice Mock Implementation of ERC-20 for tesing//
contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol, uint8 decimals)
        ERC20(name, symbol, decimals)
    {}

    //@dev Exposes internal function "_mint" for testing
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    ////@dev Exposes internal function "_burn" for testing
    //function burn(uint256 amount) public {
    //    _burn(msg.sender, amount);
    //}
}

/**
 * @title ERC20Test
 * @notice Test suite for base ERC-20 implementation
 * @author Pradhumna Pancholi
 * @dev Tests cover all of the core ERC-20 functionalities with edge cases
*/
contract ERC20Test is Test {
    MockERC20 public token;

    /*///////////////////////////////
                SETUP
    //////////////////////////////*/
    address public owner;
    address public alice;
    address public bob;
    address public charlie;

    function setUp() public {
        owner = address(this);
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        charlie = makeAddr("charlie");
        //Deploys an instance of MockERC20 to perform tests on it
        token = new MockERC20("Test Token", "TST", 18);
    }

    /*////////////////////////////////////
                Metadata Test
    ///////////////////////////////////*/
    function test_MetaData() public view {
        assertEq(token.name(), "Test Token");
        assertEq(token.symbol(), "TST");
        assertEq(token.decimals(), 18);
    }

    /*///////////////////////////////////
                Mint Tests
    //////////////////////////////////*/
    function test_Mint() public {
        token.mint(alice, 100);

        assertEq(token.totalSupply(), 100);
        assertEq(token.balanceOf(alice), 100);
    }

    function test_MintRevertsWhen_ToAddrIsZero() public {
        vm.expectRevert("ERC-20: Mint To Zero Address");
        token.mint(address(0), 10);
    }

    function test_MintEmitsTransfer() public {
        vm.expectEmit();

        emit Transfer(address(0), alice, 100);
        token.mint(alice, 100);
    }

    /*////////////////////////////////////////
                    Burn Tests
    ///////////////////////////////////////*/
    function test_Burn() public {
        token.mint(alice, 100);

        assertEq(token.totalSupply(), 100);
        assertEq(token.balanceOf(alice), 100);

        vm.prank(alice);
        token.burn(10);
        
        assertEq(token.totalSupply(), 90);
        assertEq(token.balanceOf(alice), 90);
    }

    function test_BurnEmitsTransfer() public {
        token.mint(alice, 20);
        assertEq(token.balanceOf(alice), 20);
        
        vm.expectEmit(true, true, false, true);
        emit Transfer(alice, address(0), 10);
        vm.prank(alice);
        token.burn(10);
    }

    function test_BurnRevertsWhen_BalanceIsInsufficient() public {
        token.mint(alice, 10);
        assertEq(token.balanceOf(alice), 10);

        vm.expectRevert("ERC-20: Amount Exceeds Account Balance");
        token.burn(11);
    }

    function test_BurnFrom() public {
        token.mint(alice, 10);
        assertEq(token.balanceOf(alice), 10);

        vm.prank(alice);
        token.approve(bob, 1);

        vm.prank(bob);
        token.burnFrom(alice, 1);
        assertEq(token.balanceOf(alice), 9);
    }

    function test_BurnFromEmitsEvent() public {
        token.mint(alice, 10);
        assertEq(token.balanceOf(alice), 10);

        vm.prank(alice);
        token.approve(bob, 1);

        vm.expectEmit();
        emit Transfer(alice, address(0), 1);
        vm.prank(bob);
        token.burnFrom(alice, 1);
    }

    function test_BurnFromUpdatesAllowance() public {
        token.mint(alice, 10);
        assertEq(token.balanceOf(alice), 10);

        vm.prank(alice);
        token.approve(bob, 1);

        vm.prank(bob);
        token.burnFrom(alice, 1);
        assertEq(token.allowance(alice, bob), 0);

    }
    function test_BurnFromRevertsWhen_AllowanceIsInsufficient() public {
        token.mint(alice, 10);
        assertEq(token.balanceOf(alice), 10);

        vm.prank(alice);
        token.approve(bob, 1);

        vm.expectRevert("ERC-20: Insufficient Allowance");
        vm.prank(bob);
        token.burnFrom(alice, 2);
    }

    function test_BurnRevertsWhen_NoAllowance() public {
        token.mint(alice, 10);
        assertEq(token.balanceOf(alice), 10);

        vm.expectRevert("ERC-20: Insufficient Allowance");
        vm.prank(bob);
        token.burnFrom(alice, 2);
    }


    /*///////////////////////////////
            Transfer Tests
    //////////////////////////////*/
    function test_Transfer() public {
        token.mint(alice, 10);
        assertEq(token.balanceOf(alice), 10);
        assertEq(token.balanceOf(bob), 0); 

        vm.prank(alice);
        token.transfer(bob, 5);

        assertEq(token.balanceOf(alice), 5);
        assertEq(token.balanceOf(bob), 5); 
    }

    function test_TransferEmitsEvent() public {
        token.mint(alice, 5);

        vm.expectEmit();
        emit Transfer(alice, bob, 1);


        vm.prank(alice);
        token.transfer(bob, 1);

    }

    function test_TransferRevertsWhen_ToAddrIsZero() public {
        token.mint(alice, 1);

        vm.prank(alice);
        vm.expectRevert("ERC-20: Transfer To Zero Address"); 
        token.transfer(address(0), 1);
    }

    function test_TransferFullAmount() public {
        token.mint(alice, 1);
        
        vm.prank(alice);
        token.transfer(bob, 1);

        assertEq(token.balanceOf(alice), 0);
        assertEq(token.balanceOf(bob), 1);
    }

    function test_TransferChangesBalance() public {
        token.mint(alice, 10);
        assertEq(token.balanceOf(alice), 10);
        assertEq(token.balanceOf(bob), 0); 

        vm.prank(alice);
        token.transfer(bob, 1);

        assertEq(token.balanceOf(alice), 9);
        assertEq(token.balanceOf(bob), 1); 
    }

    function test_TransferRevertsWhen_AmountExceedsBalance() public {
        token.mint(alice, 1);

        vm.prank(alice);
        vm.expectRevert("ERC-20: Amount Exceeds Balance");
        token.transfer(bob, 2);
    }


    /*//////////////////////////////////////////////
                    Approve Tests
    /////////////////////////////////////////////*/
    function test_ApproveUpdatesAllowance() public {
        token.mint(alice, 10);
        vm.prank(alice);
        token.approve(bob, 2);
        vm.prank(bob);
        token.transferFrom(alice, charlie, 1);
        assertEq(token.allowance(alice, bob), 1);
    }
    function test_ApproveCanSpendAllowance() public {
        token.mint(alice, 10);
        vm.prank(alice);
        token.approve(bob, 1);
        vm.prank(bob);
        vm.expectEmit();
        emit Transfer(alice, charlie, 1);
        token.transferFrom(alice, charlie, 1);
    }
    function test_ApproveAddsAllowance() public {
        token.mint(alice, 10);
        vm.prank(alice);

        token.approve(bob, 1);
        assertEq(token.allowance(alice, bob), 1);
    }

    function test_ApproveRevertsWhen_AllowanceIsInsufficient() public {
        token.mint(alice, 10);
        vm.prank(alice);
        token.approve(bob, 1);
        vm.prank(bob);
        vm.expectRevert("ERC-20: Insufficient Allowance");
        token.transferFrom(alice, charlie, 2);
    }
    function test_ApproveRevertsWhen_FromAddrIsZero() public {
        vm.prank(address(0));
        vm.expectRevert("ERC-20: Approve From Zero Address");
        token.approve(bob, 1);
    }

    function test_ApproveRevertsWhen_ToAddrIsZero() public {
        token.mint(alice, 10);
        vm.prank(alice);
        vm.expectRevert("ERC-20: Approve To Zero Address");
        token.approve(address(0), 1);

    }
    function test_ApproveEmitsEvent() public {
        token.mint(alice, 10);

        vm.expectEmit();
        emit Approval(alice, bob, 1);
        vm.prank(alice);
        token.approve(bob, 1);
    }

    /*/////////////////////////////////////////////////////////////////////////////
                                     Events
    ////////////////////////////////////////////////////////////////////////////*/
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
}
