//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "@fm/token/ERC20.sol";

//mock
contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol, uint8 decimals)
        ERC20(name, symbol, decimals)
    {}

    //Exposes internal function "_mint" for testing
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    //Exposes internal function "_burn" for testing
    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }
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

    function test_MintToZeroAddr() public {
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

        token.burn(alice, 10);
        
        assertEq(token.totalSupply(), 90);
        assertEq(token.balanceOf(alice), 90);
    }

    function test_BurnEmitsTransfer() public {
        token.mint(alice, 20);
        assertEq(token.balanceOf(alice), 20);
        vm.expectEmit(true, true, false, true);
        emit Transfer(alice, address(0), 10);

        token.burn(alice, 10);
    }

    function test_BurnRevertsWhen_BalanceIsInsufficient() public {
        token.mint(alice, 10);
        assertEq(token.balanceOf(alice), 10);

        vm.expectRevert("ERC-20: Amount Exceeds Account Balance");
        token.burn(alice, 11);
    }

    function test_BurnFromZeroAddress() public {
        vm.expectRevert("ERC-20: Account Is An Zero Address");
        token.burn(address(0), 1);
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

    function test_TransferToZeroAddress() public {
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

    function test_TransferChangeBalance() public {
        token.mint(alice, 10);
        assertEq(token.balanceOf(alice), 10); // Alice's balance should be 10
        assertEq(token.balanceOf(bob), 0); // Bob's balance should be 0

        vm.prank(alice);
        token.transfer(bob, 1);

        assertEq(token.balanceOf(alice), 9); // Alice's balance should be 9
        assertEq(token.balanceOf(bob), 1); // Bob's balance should be 1
    }

    function test_TransferAmount() public {
        token.mint(alice, 1);

        vm.prank(alice);
        vm.expectRevert("ERC-20: Amount Exceeds Balance");
        token.transfer(bob, 2);
    }

    // Approval
    // 1. Approval adds allowance
    // 2. Approval reduces allowance after spending
    //3. Can spend as much as allowed
    // 4. can not spend more than allowance
    //5. from zero
    //6. to zero
    // 7. emits event
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

    function test_ApproveCanNotSpendMoreThanAllowed() public {
        token.mint(alice, 10);
        vm.prank(alice);
        token.approve(bob, 1);
        vm.prank(bob);
        vm.expectRevert("ERC-20: Insufficient Allowance");
        token.transferFrom(alice, charlie, 2);
    }
    function testApproveFromZeroAddress() public {
        vm.prank(address(0));
        vm.expectRevert("ERC-20: Approve From Zero Address");
        token.approve(bob, 1);
    }

    function test_ApproveToZeroAddress() public {
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

    //Burn
    // 1. Burn reduces balance
    // 2. burn reduces totalsupply//
    // 3. Burn amount //
    // 4. burn emits event
    function test_BurnTwo() public {
        token.mint(alice, 10);
        vm.prank(bob);
        token.burn(alice, 1);
        assertEq(token.balanceOf(alice), 9 ); 
    } 
    // Events

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
}
