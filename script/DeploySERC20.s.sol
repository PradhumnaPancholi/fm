// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

import {Script, console}  from "forge-std/Script.sol";

import {SERC20} from "../examples/SERC20.sol";

contract SERC20Script is Script {
  SERC20 public token;

  function setUp() public {}

  function run() public {
    vm.startBroadcast();
    token = new SERC20(100);
    vm.stopBroadcast();
  }
}
