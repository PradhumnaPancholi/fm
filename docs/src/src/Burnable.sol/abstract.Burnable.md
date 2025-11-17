# Burnable
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/45f598020bcf465d88cc4d54367f89ee9613baad/src/Burnable.sol)

**Inherits:**
[Ownable](/src/Ownable.sol/abstract.Ownable.md)


## State Variables
### _burner

```solidity
address private _burner;
```


## Functions
### constructor


```solidity
constructor();
```

### onlyBurner


```solidity
modifier onlyBurner();
```

### burner


```solidity
function burner() public view returns (address);
```

### setBurner


```solidity
function setBurner(address newBurner) public onlyOwner;
```

### _burn


```solidity
function _burn(address from, uint256 amount) internal virtual;
```

### burn


```solidity
function burn(address from, uint256 amount) public onlyBurner;
```

## Events
### TokensBurned

```solidity
event TokensBurned(address indexed burner, address indexed account, uint256 amount);
```

### BurnerUpdated

```solidity
event BurnerUpdated(address indexed oldBurner, address indexed newBurner);
```

