// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import "../src/MaraToken.sol";
import "forge-std/console2.sol";

contract MaraTokenTest is Test, Context {
    MaraToken public token;
    uint amount = 1000 * 10 ** 18;

    function setUp() public {
        token = new MaraToken();

        // Mint tokens
        token.mint(address(this), amount);
    }

    function testName() public {
        assertEq(token.name(), "MaraToken");
    }

    function testInitialState() public {
        // Check initial supply is amount minted in setUp()
        assertEq(token.totalSupply(), amount);

        // Check initial balances
        assertEq(token.balanceOf(address(this)), amount);

        // Check initial roles
        assertTrue(token.hasRole(token.DEFAULT_ADMIN_ROLE(), address(this)));
        assertTrue(token.hasRole(token.PAUSER_ROLE(), address(this)));
        assertTrue(token.hasRole(token.MINTER_ROLE(), address(this)));
    }

    function testMint() public {
        // Mint same amount of tokens again
        token.mint(address(this), amount);

        // Check new total supply
        assertEq(token.totalSupply(), 2*amount);

        // Check recipient balance
        assertEq(token.balanceOf(address(this)), 2*amount);
    }

    function testBurn() public {
        // Burn tokens
        token.burn(amount / 2);

        // Check new total supply
        assertEq(token.totalSupply(), amount / 2);

        // Check new balance
        assertEq(token.balanceOf(address(this)), amount / 2);
    }

    function testPause() public {
        token.pause();
        assertTrue(token.paused());

        vm.expectRevert(bytes("Pausable: paused"));
        token.transfer(address(1), 100);
    }

    function testUnpause() public {
        token.pause();
        assertTrue(token.paused());

        token.unpause();
        assertFalse(token.paused());

        // Transfer should now succeed
        token.transfer(address(1), 100);
    }

}
