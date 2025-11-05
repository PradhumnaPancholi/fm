# Pausable
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/599e5f65db21026d1a2cf81c2b31c737c15f6bc3/src/Pausable.sol)

**Inherits:**
[Ownable](/src/Ownable.sol/abstract.Ownable.md)


## State Variables
### _paused

```solidity
bool internal _paused = false;
```


### _pauser

```solidity
address internal _pauser;
```


## Functions
### constructor


```solidity
constructor();
```

### pauser


```solidity
function pauser() public view returns (address);
```

### onlyPauser


```solidity
modifier onlyPauser();
```

### whenPaused


```solidity
modifier whenPaused();
```

### whenNotPaused


```solidity
modifier whenNotPaused();
```

### pause


```solidity
function pause() public onlyPauser;
```

### unpause


```solidity
function unpause() public onlyPauser;
```

### setPauser


```solidity
function setPauser(address newPauser) public onlyOwner;
```

## Events
### Paused

```solidity
event Paused(address indexed pauser);
```

### UnPaused

```solidity
event UnPaused(address indexed pauser);
```

### PauserUpdated

```solidity
event PauserUpdated(address indexed oldPauser, address indexed newPauser);
```

