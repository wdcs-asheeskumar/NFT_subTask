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
    }

    function test_getUri() public {
        myToken = new MyNFTToken();
        test_setURI();
        string memory result = myToken.getUri(0);
        assertEq(
            result,
            "ipfs://QmZQmq7m2E9AeAh2sPLJmt8jL8MRrTMLqdTsX59V6wj1Wu/0"
        );
    }

    function testFail_getUri() public {
        myToken = new MyNFTToken();
        test_setURI();
        string memory result = myToken.getUri(0);
        assertEq(
            result,
            "ipfs://QmZQmq7m2E9AeAh2sPLJmt8jL8MRrTMLqdTsX59V6wj1Wu/1"
        );
    }

    function test_totalTokens() public {
        myToken = new MyNFTToken();
        uint256 totalToken = myToken.totalTokens();
        assertEq(totalToken, (10 ** 18));
    }

    function testFail_totalTokens() public {
        myToken = new MyNFTToken();
        uint256 totalToken = myToken.totalTokens();
        assertEq(totalToken, (1 ** 18));
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

    function testFail_registerUser() public {
        myToken = new MyNFTToken();

        bool result = myToken.registerUser(
            0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89,
            true,
            false,
            true,
            true,
            false,
            false
        );
        assertEq(false, result);
    }

    function test_viewAddedUserToList() public {
        myToken = new MyNFTToken();
        test_registerUser();
        bool result = myToken.viewAddedUserInTheList(
            0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89
        );
        assertEq(result, true);
    }

    function testFail_viewAddedUserToList() public {
        myToken = new MyNFTToken();
        test_registerUser();
        bool result = myToken.viewAddedUserInTheList(
            0xEf4d8352c7C1B8F5C4FDCc90fe02ee97b1dEEde6
        );
        assertEq(result, true);
    }

    function test_whitelisting() public {
        vm.startPrank(msg.sender);
        myToken = new MyNFTToken();
        test_registerUser();
        myToken.whiteListing(0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89);
        vm.warp(10);
    }

    function testFail_whitelisting() public {
        vm.startPrank(msg.sender);
        myToken = new MyNFTToken();
        test_registerUser();
        myToken.whiteListing(0xEf4d8352c7C1B8F5C4FDCc90fe02ee97b1dEEde6);
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

    function testFail_viewWhitelistedUsersInTheList() public {
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        bool result = myToken.viewWhitelistedUsersInTheList(
            0xEf4d8352c7C1B8F5C4FDCc90fe02ee97b1dEEde6
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

    function testFail_buyAndRedeemTimeFrame() public {
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        myToken.buyAndRedeemTimeFrame(
            0xEf4d8352c7C1B8F5C4FDCc90fe02ee97b1dEEde6,
            2,
            0
        );
        myToken.buyAndRedeemTimeFrame(
            0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89,
            2,
            6
        );
    }

    function test_buyAndRedeemTimeFrame2() public {
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        myToken.buyAndRedeemTimeFrame(
            0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89,
            2,
            0
        );
    }

    function testFail_buyAndRedeemTimeFrame2() public {
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        myToken.buyAndRedeemTimeFrame(
            0x4376565e07BD1a2B8BEF3fCeE9d15d09a7f70D89,
            2,
            6
        );
    }
}
