# TransferHelper
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/bb79473fc09077a5423e611f7bf814ed6f8047f7/src/TransferHelper.sol)


## Functions
### safeTransfer


```solidity
function safeTransfer(address token, address to, uint256 amount) internal;
```

### safeTransferFrom


```solidity
function safeTransferFrom(address token, address from, address to, uint256 amount) internal;
```

### safeApprove


```solidity
function safeApprove(address token, address spender, uint256 amount) internal;
```

### safeTransferETH


```solidity
function safeTransferETH(address to, uint256 amount) internal;
```

### getBalance


```solidity
function getBalance(address token, address account) internal returns (uint256);
```

## Errors
### TransferFailed

```solidity
error TransferFailed();
```

### TransferFromFailed

```solidity
error TransferFromFailed();
```

### ApprovalFailed

```solidity
error ApprovalFailed();
```

### ETHTransferFailed

```solidity
error ETHTransferFailed();
```

