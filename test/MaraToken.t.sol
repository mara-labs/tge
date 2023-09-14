// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import "../src/MaraToken.sol";
import "forge-std/console2.sol";

contract MaraTokenTest is Test, Context {
    MaraToken public token;
    uint newSupply = 1000 * 10 ** 18;

    function setUp() public {
        token = new MaraToken();

        // Mint tokens
        token.mint(address(this), newSupply);
    }

    function testName() public {
        assertEq(token.name(), "MaraToken");
    }

    function testInitialState() public {
        // Check initial supply is amount minted in setUp()
        assertEq(token.totalSupply(), newSupply);

        // Check initial balances
        assertEq(token.balanceOf(address(this)), newSupply);

        // Check initial roles
        assertTrue(token.hasRole(token.DEFAULT_ADMIN_ROLE(), address(this)));
        assertTrue(token.hasRole(token.PAUSER_ROLE(), address(this)));
        assertTrue(token.hasRole(token.MINTER_ROLE(), address(this)));
    }

    function testMint() public {
        // Mint same amount of tokens again
        token.mint(address(this), newSupply);

        // Check new total supply
        assertEq(token.totalSupply(), 2 * newSupply);

        // Check recipient balance
        assertEq(token.balanceOf(address(this)), 2 * newSupply);
    }

    function testBurn() public {
        // Burn tokens
        token.burn(newSupply / 2);

        // Check new total supply
        assertEq(token.totalSupply(), newSupply / 2);

        // Check new balance
        assertEq(token.balanceOf(address(this)), newSupply / 2);
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
