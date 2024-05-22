// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import "../src/MyNFTToken.sol";

contract TestMyNFTToken is Test {
    MyNFTToken public myToken;

    function setUp() external {
        myToken = new MyNFTToken();
    }

    function test_setURI() public {
        myToken = new MyNFTToken();
        myToken.setURI(
            "ipfs://QmZQmq7m2E9AeAh2sPLJmt8jL8MRrTMLqdTsX59V6wj1Wu/0"
        );
        myToken.setURI(
            "ipfs://QmZQmq7m2E9AeAh2sPLJmt8jL8MRrTMLqdTsX59V6wj1Wu/1"
        );
    }

    function test_totalTokens() public {
        myToken = new MyNFTToken();
        uint256 totalToken = myToken.totalTokens();
        assertEq(totalToken, (10 ** 18));
    }

    function test_registerUser() public {
        myToken = new MyNFTToken();
        myToken.registerUser(
            0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89,
            true,
            true,
            true,
            true,
            true,
            true
        );
    }

    function test_viewAddedUserToList() public {
        myToken = new MyNFTToken();
        test_registerUser();
        bool result = myToken.viewAddedUserInTheList(
            0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89
        );
        assertEq(result, true);
    }

    function test_whitelisting() public {
        vm.startPrank(msg.sender);
        myToken = new MyNFTToken();
        test_registerUser();
        myToken.whiteListing(0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89);
        vm.stopPrank();
    }

    function test_viewWhitelistedUsersInTheList() public {
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        bool result = myToken.viewWhitelistedUsersInTheList(
            0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89
        );
        assertEq(result, true);
    }

    function test_buyAndRedeemTimeFrame() public {
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        myToken.buyAndRedeemTimeFrame(
            0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89,
            2,
            0
        );
    }
}
