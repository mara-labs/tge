// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";
import "../src/MaraToken.sol";

contract MaraTokenScript is Script {
  function setUp() public {}

  function run() public {
    vm.startBroadcast();
    MaraToken instance = new MaraToken();
    console.log("Contract deployed to %s", address(instance));
    vm.stopBroadcast();
  }
}
