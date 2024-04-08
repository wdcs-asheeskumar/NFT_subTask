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

    address internal initialOwner;
    address payable addr = payable(address(this));
    /// @dev declaring the variables for the different time frames
    uint256 public timeFrame1;
    uint256 public timeFrame2;
    uint256 public timeFrame3;
    uint256 public timeFrame4;
    uint256 public timeFrame5;
    uint256 public timeFrame6;
    uint256 public num;

    event Timeframes(
        uint256 timeFrame1,
        uint256 timeFrame2,
        uint256 timeFrame3,
        uint256 timeFrame4,
        uint256 timeFrame5,
        uint256 timeFrame6
    );

    /// @dev constructor to initialize the oqner, uri, token's name and setting up the timeframes
    constructor()
        ERC1155("ipfs://QmZQmq7m2E9AeAh2sPLJmt8jL8MRrTMLqdTsX59V6wj1Wu/")
        ERC20("MyToken", "MTK")
        Ownable(msg.sender)
    {
        initialOwner = msg.sender;
    }

    /// @dev function for updating the uri
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /// @dev function for minting NFTs and it's only accessible to the owner
    function mintNFT(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        _mint(account, id, amount, data);
    }

    /// @dev function to mint a batch of NFTS. It is only accessible to the owner.
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    /// @dev Function to mint the ERC 20 tokens
    function mintToken(uint256 _amount) public {
        _mint(address(this), _amount * (10 ** decimals()));
    }

    /// @dev Function to check total token balance
    function totalTokens() public view returns (uint256) {
        return balanceOf(address(this));
    }

    /// @dev Function to set timeframes
    function setTimeFrames(
        uint256 _timeFrame1,
        uint256 _timeFrame2,
        uint256 _timeFrame3,
        uint256 _timeFrame4,
        uint256 _timeFrame5,
        uint256 _timeFrame6
    ) public {
        timeFrame1 = _timeFrame1;
        timeFrame2 = _timeFrame2;
        timeFrame3 = _timeFrame3;
        timeFrame4 = _timeFrame4;
        timeFrame5 = _timeFrame5;
        timeFrame6 = _timeFrame6;

        emit Timeframes(
            _timeFrame1,
            _timeFrame2,
            _timeFrame3,
            _timeFrame4,
            _timeFrame5,
            _timeFrame6
        );
    }

    /// @dev Funtion to register user in the pool. It is accessible to the users.
    function registerUser(
        address _accountAddress,
        bool _isPartOfTier1,
        bool _isPartOfTier2,
        bool _isBlackNft,
        bool _isGoldNft
    ) public {
        require(_accountAddress != address(0), "Invalid address");
        require(
            userList[_accountAddress] == false,
            "User is already registered"
        );
        userList[_accountAddress] = true;
        if (_isPartOfTier1 == true) {
            userData[_accountAddress].partOfTier1 = true;
            if (_isBlackNft == true) {
                userData[_accountAddress].blackNftT1 = true;
            }
            if (_isGoldNft == true) {
                userData[_accountAddress].goldNFTT1 = true;
            }
        }
        if (_isPartOfTier2 == true) {
            userData[_accountAddress].partOfTier2 = true;
            if (_isBlackNft == true) {
                userData[_accountAddress].blackNftT2 = true;
            }
            if (_isGoldNft == true) {
                userData[_accountAddress].goldNFTT2 = true;
            }
        }
    }

    /// @dev Function to view the users added in the user list
    function viewAddedUserInTheList(
        address _accountAddress
    ) public view returns (bool) {
        return userList[_accountAddress];
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
        if (userData[_accountAddress].blackNftT1 == true) {
            whiteListTier1Record[_accountAddress].blackNftWT1 = true;
        }
        if (userData[_accountAddress].goldNFTT1 == true) {
            whiteListTier1Record[_accountAddress].goldNFTWT1 = true;
        }

        if (userData[_accountAddress].blackNftT2 == true) {
            whiteListTier2Record[_accountAddress].blackNftWT2 = true;
        }
        if (userData[_accountAddress].goldNFTT2 == true) {
            whiteListTier2Record[_accountAddress].goldNFTWT2 = true;
        }
        whiteListedUsers[_accountAddress] = true;
    }

    /// @dev Function to view the users addred in the whitelist
    function viewWhitelistedUsersInTheList(
        address _accountAddress
    ) public view returns (bool) {
        return whiteListedUsers[_accountAddress];
    }

    /// @dev function for the whitelisted users to buy NFT's between time frame 1 and time frame 2.
    function userGetsNFTTF1(
        address _to,
        uint256 _id,
        uint256 _valueBlackNft,
        uint256 _valueGoldNft
    ) public payable returns (uint256) {
        // require(
        //     block.timestamp >= timeFrame1 && block.timestamp < timeFrame2,
        //     "The time frame is over."
        // );
        require(
            whiteListedUsers[_to] == true,
            "Address is not whitlisted and hence it can't buy NFT"
        );
        require(
            (_valueBlackNft + _valueGoldNft) <= 5,
            "User can't buy more than 5 NFTs in this time frame."
        );
        if (_id == 1) {
            safeTransferFrom(address(this), _to, _id, _valueBlackNft, "0x0");
            addr.transfer(10000000000000000 wei);
        }
        if (_id == 2) {
            safeTransferFrom(address(this), _to, _id, _valueGoldNft, "0x0");
            addr.transfer(20000000000000000 wei);
        }

        return (_valueBlackNft + _valueGoldNft);
    }

    /// @dev function for the whitelisted users to buy NFT's between time frame 2 and time frame 3.
    function userGetsNFTTF2(
        address _to,
        uint256 _id,
        uint256 _valueBlackNft,
        uint256 _valueGoldNft
    ) public payable returns (uint256) {
        require(
            block.timestamp >= timeFrame2 && block.timestamp < timeFrame3,
            "This time frame is over"
        );
        require(
            whiteListedUsers[_to] == true,
            "Address is not whitlisted and hence it can't buy NFT"
        );
        require(
            (_valueBlackNft + _valueGoldNft) <= 3,
            "User can't buy more than 3 NFTs in this timeframe."
        );

        if (_id == 1) {
            safeTransferFrom(address(this), _to, _id, _valueBlackNft, "0x0");
            addr.transfer(10000000000000000 wei);
        }
        if (_id == 2) {
            safeTransferFrom(address(this), _to, _id, _valueGoldNft, "0x0");
            addr.transfer(20000000000000000 wei);
        }

        return (_valueBlackNft + _valueGoldNft);
    }

    /// @dev function for the whitelisted users to buy NFT's between time frame 3 and time frame 4.
    function userGetsNFTTF3(
        address _to,
        uint256 _id,
        uint256 _valueBlackNft,
        uint256 _valueGoldNft
    ) public {
        require(
            block.timestamp >= timeFrame3 && block.timestamp < timeFrame4,
            "This time frame is over"
        );
        require(
            whiteListedUsers[_to] == true,
            "Address is not whitlisted and hence it can't buy NFT"
        );
        uint256 tokenBlack = 20 * _valueBlackNft;
        uint256 tokenGold = 40 * _valueGoldNft;
        if (_id == 1) {
            safeTransferFrom(_to, address(this), 1, _valueBlackNft, "0x0");
            transferFrom(address(this), _to, tokenBlack);
        }
        if (_id == 2) {
            safeTransferFrom(_to, address(this), 2, _valueBlackNft, "0x0");
            transferFrom(address(this), _to, tokenGold);
        }
    }

    /// @dev function for the whitelisted users to buy NFT's between time frame 4 and time frame 5.
    function userGetsNFTTF4(
        address _to,
        uint256 _id,
        uint256 _valueBlackNft,
        uint256 _valueGoldNft
    ) public {
        require(
            block.timestamp >= timeFrame4 && block.timestamp < timeFrame5,
            "This time frame is over"
        );
        require(
            whiteListedUsers[_to] == true,
            "Address is not whitlisted and hence it can't buy NFT"
        );
        uint256 tokenBlack = 25 * _valueBlackNft;
        uint256 tokenGold = 50 * _valueGoldNft;
        if (_id == 1) {
            safeTransferFrom(_to, address(this), 1, _valueBlackNft, "0x0");
            transferFrom(address(this), _to, tokenBlack);
        }
        if (_id == 2) {
            safeTransferFrom(_to, address(this), 1, _valueBlackNft, "0x0");
            transferFrom(address(this), _to, tokenGold);
        }
    }

    /// @dev function for the whitelisted users to buy NFT's between time frame 5 and time frame 6.
    function userGetsNFTTF5(
        address _to,
        uint256 _id,
        uint256 _valueBlackNft,
        uint256 _valueGoldNft
    ) public {
        require(
            block.timestamp >= timeFrame5 && block.timestamp < timeFrame6,
            "This time frame is over"
        );
        require(
            whiteListedUsers[_to] == true,
            "Address is not whitlisted and hence it can't buy NFT"
        );
        uint256 tokenBlack = 50 * _valueBlackNft;
        uint256 tokenGold = 100 * _valueGoldNft;
        if (_id == 1) {
            safeTransferFrom(_to, address(this), 1, _valueBlackNft, "0x0");
            transferFrom(address(this), _to, tokenBlack);
        }
        if (_id == 2) {
            safeTransferFrom(_to, address(this), 1, _valueBlackNft, "0x0");
            transferFrom(address(this), _to, tokenGold);
        }
    }
}
