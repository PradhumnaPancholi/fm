// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "../src/ERC20.sol";
import "../src/Ownable.sol";
import "../src/Mintable.sol";

// @author Pradhumna Pancholi
// @title MockERC20Test: A complete test suite to test core functionalities of an ERC-20 Token extended with Mintable//

contract MockERC20Mintable is ERC20, Ownable, Mintable {
    constructor(string memory name, string memory symbol, uint8 decimals)
        ERC20(name, symbol, decimals)
        //Ownable() - temporarily comment until diamond pattern , leanearization, and architecture bewttern ownable and mintable is fixed//
  
    {}

    function mint(address to, uint256 amount) public onlyMinter {
      _mint(to, amount);
    }
}

contract ERC20MintableTest is Test {
    /*//////////////////////////////
          ` SETUP
    //////////////////////////////*/
    MockERC20Mintable public token;

    address public owner;
    address public alice;
    address public bob;
    address public charlie;

    function setUp() public {
      owner = address(this);
      alice = makeAddr("alice");
      bob = makeAddr("bob");
      charlie = makeAddr("charlie");

      token = new MockERC20Mintable("Mintable Fungible Token", "MFT", 18);
    }

    function test_OwnerIsMinterByDefault() public {
      assertEq(token.minter(), owner);
    }

    function test_OwnerCanSetMinter() public {
      vm.prank(owner);
      token.setMinter(alice);
      assertEq(token.minter(), alice);
    }

    function test_SetOwnerRevertsWhen_CallerIsNotOwner() public {
      vm.prank(bob);
      vm.expectRevert("Ownable: Only owner can perform this action");
      token.setMinter(bob);
    }

    function test_SetOwnerEmitsEvent() public {
      vm.expectEmit();
      emit MinterUpdated(owner, alice);
      vm.prank(owner);
      token.setMinter(alice);
    }

    function test_MinterCanMint() public {
      vm.prank(owner);
      token.setMinter(alice);
      vm.prank(alice);
      token.mint(alice, 10);
    }

    function test_MintRevertsWhen_CalledByRegularUser() public {
      vm.expectRevert("Mintable: Only minter can perform this action");
      vm.prank(bob);
      token.mint(bob, 1000);
    }
    
    // reverts setminter when zero address//
    // minter can mint to others/
    //minters can not mint to themselves - maybe//
    // owner can mint without minter role//

    //mintable - array update ?
// write testing guideline - happypath, event, ... .... "
 //   look up mixins
 //  work on pausable - implement pausable without mintable
  

    /*///////////////////////////////
                EVENTS
    //////////////////////////////*/
    event MinterUpdated(address indexed oldMinter, address indexed newMinter);

}
