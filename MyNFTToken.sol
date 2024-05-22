// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyNFTToken is ERC1155, Ownable, ERC1155Burnable, ERC20 {
    /// @dev  Struct to store the users record
    struct userRecord {
        bool partOfTier1;
        bool partOfTier2;
        bool blackNftT1;
        bool goldNFTT1;
        bool blackNftT2;
        bool goldNFTT2;
        uint256 blackNftTCount;
        uint256 goldNFTTCount;
    }
    /// @dev  Struct to store NFT's data of the users who are included whitelisted in tier 1
    struct whiteListingTier1 {
        bool blackNftWT1;
        bool goldNFTWT1;
    }
    /// @dev  Struct to store NFT's data of the users who are included whitelisted in tier 2
    struct whiteListingTier2 {
        bool blackNftWT2;
        bool goldNFTWT2;
    }
    /// @dev mapping the user's record
    mapping(address => userRecord) public userData;
    /// @dev mapping the user's list corresponding to there wallet address
    mapping(address => bool) public userList;
    /// @dev mapping the whitelisted users with there corresponding wallet addresses
    mapping(address => bool) internal whiteListedUsers;
    /// @dev mapping the NFT's data of users who are included in tier 1
    mapping(address => whiteListingTier1) public whiteListTier1Record;
    /// @dev mapping the NFT's data of users who are included in tier 2
    mapping(address => whiteListingTier2) public whiteListTier2Record;
    /// @dev mapping for the time at which the user is getting whitelisted
    mapping(address => uint256) public whiteListedUsersTimes;

    address internal initialOwner;
    address payable addr = payable(msg.sender);
    /// @dev declaring the variables for the different time frames
    uint256 private timeFrame1 = 0;
    uint256 private timeFrame2 = 30 minutes;
    uint256 private timeFrame3 = 60 minutes;
    uint256 private timeFrame4 = 90 minutes;
    uint256 private timeFrame5 = 120 minutes;
    uint256 private timeFrame6 = 150 minutes;

    /// @dev constructor to initialize the oqner, uri, token's name and setting up the timeframes
    constructor() ERC1155("") ERC20("MyNFTToken", "MNTK") Ownable(msg.sender) {
        initialOwner = msg.sender;
        _mint(address(this), (10 ** decimals()));
    }

    /// @dev function for updating the uri
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /// @dev Function to check total token balance
    function totalTokens() public view returns (uint256) {
        return balanceOf(address(this));
    }

    /// @dev Funtion to register user in the pool. It is accessible to the users.
    function registerUser(
        address _accountAddress,
        bool _isPartOfTier1,
        bool _isPartOfTier2,
        bool _isBlackNft1,
        bool _isGoldNft1,
        bool _isBlackNft2,
        bool _isGoldNft2
    ) public {
        require(_accountAddress != address(0), "Invalid address");
        require(
            userList[_accountAddress] == false,
            "User is already registered"
        );
        userList[_accountAddress] = true;
        if (_isPartOfTier1 == true) {
            userData[_accountAddress].partOfTier1 = true;
            if (_isBlackNft1 == true) {
                userData[_accountAddress].blackNftT1 = true;
            }
            if (_isGoldNft1 == true) {
                userData[_accountAddress].goldNFTT1 = true;
            }
        }
        if (_isPartOfTier2 == true) {
            userData[_accountAddress].partOfTier2 = true;
            if (_isBlackNft2 == true) {
                userData[_accountAddress].blackNftT2 = true;
            }
            if (_isGoldNft2 == true) {
                userData[_accountAddress].goldNFTT2 = true;
            }
        }
    }

    /// @dev  Function to white list the users.
    function whiteListing(address _accountAddress) public onlyOwner {
        require(
            whiteListedUsers[_accountAddress] == false,
            "User already whitelisted"
        );
        require(
            userList[_accountAddress] == true,
            "Only the users can be included in the whitelist"
        );
        require(
            (userData[_accountAddress].partOfTier1 == true) ||
                (userData[_accountAddress].partOfTier2 == true),
            "The user is not intrested in purchasing any NFT"
        );
        whiteListedUsersTimes[_accountAddress] = block.timestamp;
        if (userData[_accountAddress].partOfTier1 == true) {
            if (userData[_accountAddress].blackNftT1 == true) {
                whiteListTier1Record[_accountAddress].blackNftWT1 = true;
            }
            if (userData[_accountAddress].goldNFTT1 == true) {
                whiteListTier1Record[_accountAddress].goldNFTWT1 = true;
            }
        }
        if (userData[_accountAddress].partOfTier2 == true) {
            if (userData[_accountAddress].blackNftT2 == true) {
                whiteListTier2Record[_accountAddress].blackNftWT2 = true;
            }
            if (userData[_accountAddress].goldNFTT2 == true) {
                whiteListTier2Record[_accountAddress].goldNFTWT2 = true;
            }
        }
        whiteListedUsers[_accountAddress] = true;
    }

    function buyAndRedeemTimeFrame(
        address _accountAddress,
        uint256 _valueOfBlackNft,
        uint256 _valueOfGoldNft
    ) external payable {
        require(
            whiteListedUsers[_accountAddress] == true,
            "Only whitelisted users can access this functionality."
        );

        if (
            block.timestamp - whiteListedUsersTimes[_accountAddress] >
            timeFrame1 &&
            block.timestamp - whiteListedUsersTimes[_accountAddress] <
            timeFrame2
        ) {
            require(
                _valueOfBlackNft + _valueOfGoldNft <= 5,
                "You can't buy more than 5 NFTs"
            );

            _mint(_accountAddress, 0, _valueOfBlackNft, "0x0");
            addr.transfer(_valueOfBlackNft * 10000000000000000 wei);

            _mint(_accountAddress, 1, _valueOfGoldNft, "0x0");
            addr.transfer(_valueOfGoldNft * 20000000000000000 wei);
            userData[_accountAddress].blackNftTCount = _valueOfBlackNft;
            userData[_accountAddress].goldNFTTCount = _valueOfGoldNft;
        } else if (
            block.timestamp - whiteListedUsersTimes[_accountAddress] >
            timeFrame2 &&
            block.timestamp - whiteListedUsersTimes[_accountAddress] <
            timeFrame3
        ) {
            require(
                _valueOfBlackNft + _valueOfGoldNft <= 3,
                "You can't buy more than 3 NFTs"
            );

            _mint(_accountAddress, 0, _valueOfBlackNft, "0x0");
            addr.transfer(_valueOfBlackNft * 10000000000000000 wei);

            _mint(_accountAddress, 1, _valueOfGoldNft, "0x0");
            addr.transfer(_valueOfGoldNft * 20000000000000000 wei);
            userData[_accountAddress].blackNftTCount = _valueOfBlackNft;
            userData[_accountAddress].goldNFTTCount = _valueOfGoldNft;
        } else if (
            block.timestamp - whiteListedUsersTimes[_accountAddress] >
            timeFrame3 &&
            block.timestamp - whiteListedUsersTimes[_accountAddress] <
            timeFrame4
        ) {
            uint256 tokenForBlackandGoldNFT = (25 *
                userData[_accountAddress].blackNftTCount) +
                (75 * userData[_accountAddress].goldNFTTCount);
            transferFrom(
                address(this),
                _accountAddress,
                tokenForBlackandGoldNFT
            );
        } else if (
            block.timestamp - whiteListedUsersTimes[_accountAddress] >
            timeFrame4 &&
            block.timestamp - whiteListedUsersTimes[_accountAddress] <
            timeFrame5
        ) {
            uint256 tokenForBlackandGoldNFT = (30 *
                userData[_accountAddress].blackNftTCount) +
                (90 * userData[_accountAddress].goldNFTTCount);
            transferFrom(
                address(this),
                _accountAddress,
                tokenForBlackandGoldNFT
            );
        } else if (
            block.timestamp - whiteListedUsersTimes[_accountAddress] >
            timeFrame5 &&
            block.timestamp - whiteListedUsersTimes[_accountAddress] <
            timeFrame6
        ) {
            uint256 tokenForBlackandGoldNFT = (50 *
                userData[_accountAddress].blackNftTCount) +
                (150 * userData[_accountAddress].goldNFTTCount);
            transferFrom(
                address(this),
                _accountAddress,
                tokenForBlackandGoldNFT
            );
        }
    }

    /// @dev Function to view the users added in the user list
    function viewAddedUserInTheList(
        address _accountAddress
    ) public view returns (bool) {
        return userList[_accountAddress];
    }

    /// @dev Function to view the users addred in the whitelist
    function viewWhitelistedUsersInTheList(
        address _accountAddress
    ) public view returns (bool) {
        return whiteListedUsers[_accountAddress];
    }
}
