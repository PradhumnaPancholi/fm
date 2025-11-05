# TransferHelper
[Git Source](https://github.com/PradhumnaPancholi/fm/blob/5e6dc7885d9a949586c1f2015ee2dc3135a1eed6/src/TransferHelper.sol)


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

