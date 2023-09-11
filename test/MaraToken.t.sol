// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/MaraToken.sol";

contract MaraTokenTest is Test {
  MaraToken public instance;

  function setUp() public {
    instance = new MaraToken();
  }

  function testName() public {
    assertEq(instance.name(), "MaraToken");
  }
}
