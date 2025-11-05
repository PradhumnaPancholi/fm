# Ownable
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/bb79473fc09077a5423e611f7bf814ed6f8047f7/src/Ownable.sol)


## State Variables
### _owner

```solidity
address private _owner;
```


## Functions
### constructor


```solidity
constructor();
```

### onlyOwner


```solidity
modifier onlyOwner();
```

### owner


```solidity
function owner() public view returns (address);
```

### transferOwnership


```solidity
function transferOwnership(address newOwner) public onlyOwner;
```

## Events
### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
```

