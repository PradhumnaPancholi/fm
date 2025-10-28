//SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

// @title Ownable
// @author Pradhumna Pancholi
// @notice An implementation to provide flexible access control.
abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable: Only owner can perform this action");
        _;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: Zero address can not be an owner");
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
