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
        bool result = myToken.registerUser(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            true,
            true,
            true,
            true,
            true,
            true
        );
        assertEq(result, true);
    }

    function testFail_registerUser() public {
        vm.startPrank(address(0));
        myToken = new MyNFTToken();

        bool result = myToken.registerUser(
            msg.sender,
            true,
            false,
            true,
            true,
            false,
            false
        );
        assertEq(true, result);
        vm.stopPrank();
    }

    function test_viewAddedUserToList() public {
        myToken = new MyNFTToken();
        test_registerUser();
        bool result = myToken.viewAddedUserInTheList(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8
        );
        assertEq(result, true);
    }

    function testFail_viewAddedUserToList() public {
        myToken = new MyNFTToken();
        test_registerUser();
        bool result = myToken.viewAddedUserInTheList(
            0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
        );
        assertEq(result, true);
    }

    function test_whitelisting() public {
        vm.startPrank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        myToken = new MyNFTToken();
        test_registerUser();
        assertEq(
            myToken.viewAddedUserInTheList(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            true
        );
        assertEq(
            myToken.viewWhitelistedUsersInTheList(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            false
        );
        myToken.whiteListing(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        assertEq(
            myToken.viewWhitelistedUsersInTheList(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            true
        );
        assertEq(
            myToken.viewAddedUserInTheList(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            true
        );

        vm.stopPrank();
    }

    function testFail_whitelisting() public {
        vm.startPrank(address(0));
        myToken = new MyNFTToken();
        test_registerUser();
        assertEq(myToken.viewAddedUserInTheList(address(0)), true);
        assertEq(myToken.viewWhitelistedUsersInTheList(address(0)), true);
        myToken.whiteListing(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        assertEq(myToken.viewAddedUserInTheList(address(0)), true);
        assertEq(myToken.viewWhitelistedUsersInTheList(address(0)), true);
        vm.stopPrank();
    }

    function test_viewWhitelistedUsersInTheList() public {
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        bool result = myToken.viewWhitelistedUsersInTheList(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8
        );
        assertEq(result, true);
    }

    function testFail_viewWhitelistedUsersInTheList() public {
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        bool result = myToken.viewWhitelistedUsersInTheList(
            0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
        );
        assertEq(result, true);
    }

    function test_buyAndRedeemTimeFrame() public payable {
        address a1 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        vm.prank(address(a1));
        vm.deal(address(a1), 100 ether);
        assertEq(address(a1).balance, 100 ether);
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        assertEq(
            myToken.viewWhitelistedUsersInTheList(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            true
        );
        vm.warp(10);
        myToken.buyAndRedeemTimeFrame{value: 3 ether}(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            1,
            1
        );

        uint256 result1 = myToken.getNumberOfNfts(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8
        );
        bool resultBool1;
        if (result1 >= 0 || result1 <= 5) {
            resultBool1 = true;
        } else {
            resultBool1 = false;
        }
        assertEq(resultBool1, true);
        vm.warp(1991);
        myToken.buyAndRedeemTimeFrame{value: 3 ether}(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            1,
            1
        );
        uint256 result2 = myToken.getNumberOfNfts(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8
        );
        bool resultBool2;
        if (result2 >= 0 || result2 <= 8) {
            resultBool2 = true;
        } else {
            resultBool2 = false;
        }
        assertEq(resultBool2, true);

        vm.warp(3800);
        myToken.buyAndRedeemTimeFrame(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            3,
            0
        );
        assertEq(
            myToken.getOwnerTokenValue(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            200
        );
        vm.warp(5600);
        myToken.buyAndRedeemTimeFrame(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            2,
            1
        );
        assertEq(
            myToken.getOwnerTokenValue(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            240
        );

        vm.warp(7400);
        myToken.buyAndRedeemTimeFrame(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            2,
            4
        );
        assertEq(
            myToken.getOwnerTokenValue(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            400
        );
        vm.stopPrank();
    }

    function testFail_buyAndRedeemTimeFrame() public {
        vm.startPrank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        assertEq(
            myToken.viewWhitelistedUsersInTheList(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            true
        );
        vm.warp(10);
        assertEq(
            myToken.viewWhitelistedUsersInTheList(
                0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
            ),
            true
        );
        myToken.buyAndRedeemTimeFrame{value: 3 ether}(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            2,
            5
        );
        vm.warp(1991);
        myToken.buyAndRedeemTimeFrame{value: 3 ether}(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            2,
            7
        );
    }

    function testFail_buyAndRedeemTimeFrame2() public {
        vm.startPrank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        myToken = new MyNFTToken();
        test_registerUser();
        test_whitelisting();
        assertEq(
            myToken.viewWhitelistedUsersInTheList(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            true
        );
        vm.warp(10);
        assertEq(
            myToken.viewWhitelistedUsersInTheList(
                0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
            ),
            true
        );
        myToken.buyAndRedeemTimeFrame{value: 3 ether}(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            2,
            0
        );
        vm.warp(1991);
        myToken.buyAndRedeemTimeFrame{value: 3 ether}(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            2,
            0
        );
        vm.warp(3800);
        myToken.buyAndRedeemTimeFrame(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            2,
            0
        );
        assertEq(
            myToken.getOwnerTokenValue(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            200
        );

        vm.warp(5600);
        myToken.buyAndRedeemTimeFrame(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            2,
            0
        );
        assertEq(
            myToken.getOwnerTokenValue(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            200
        );

        vm.warp(7400);
        myToken.buyAndRedeemTimeFrame(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            2,
            0
        );
        assertEq(
            myToken.getOwnerTokenValue(
                0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            ),
            200
        );

        vm.stopPrank();
    }

    // function test_sample(

    // )
}
