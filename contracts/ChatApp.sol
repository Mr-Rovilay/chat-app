// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract ChatApp {
    struct friend {
        string name;
        address pubkey;
    }

    //user struct
    struct User {
        string name;
        friend[] friendList;
    }

    struct Message {
        address sender;
        string msg;
        uint256 timestamp;
    }

    mapping(address => User) public userList;
    mapping(bytes32 => Message[]) allMessages;

    // check user exists
    function checkUserExists(address pubkey) public view returns (bool) {
        return bytes(userList[pubkey].name).length > 0;
    }

    // create account
    function createAccount(string calldata name) external {
        require(!checkUserExists(msg.sender), "User already exists");
        require(bytes(name).length > 0, "Name cannot be empty");
        userList[msg.sender].name = name;
    }

    //get username
    function getUsername(address pubkey) external view returns (string memory) {
        require(checkUserExists(pubkey), "User does not exist");
        return userList[pubkey].name;
    }

    //add friend
    function addFriend(
        address friend_key,
        string calldata name
    ) external {
        require(
            checkUserExists(msg.sender),
            "You must create an account first"
        );
        require(checkUserExists(friend_key), "User does not exist");
        require(
            msg.sender != friend_key,
            "You cannot add yourself as a friend"
        );
        require(bytes(name).length > 0, "Friend name cannot be empty");
        require(
            !isFriend(msg.sender, friend_key),
            "This user is already your friend"
        );

        _addFriend(msg.sender, friend_key, name);
        _addFriend(friend_key, msg.sender, userList[msg.sender].name);
    }

    // check is Friend
    function isFriend(
        address pubkey1,
        address pubkey2
    ) internal view returns (bool) {
        if (
            userList[pubkey1].friendList.length >
            userList[pubkey2].friendList.length
        ) {
            address tmp = pubkey1;
            pubkey1 = pubkey2;
            pubkey2 = tmp;
        }
        for (uint256 i = 0; i < userList[pubkey1].friendList.length; i++) {
            if (userList[pubkey1].friendList[i].pubkey == pubkey2) return true;
        }
        return false;
    }
    function _addFriend(
        address me,
        address friend_key,
        string memory name
    ) internal {
        friend memory newFriend = friend(name, friend_key);
        userList[me].friendList.push(newFriend);
    }

    //get my friends
    function getMyFriendsList() external view returns (friend[] memory) {
        require(checkUserExists(msg.sender), "You must create an account first");
        return userList[msg.sender].friendList;
    }
    // get chat code
    function _getChatCode(
        address pubkey1,
        address pubkey2
    ) internal pure returns (bytes32) {
        if(pubkey1 < pubkey2) {
            return keccak256(abi.encodePacked(pubkey1, pubkey2));
        } else {
            return keccak256(abi.encodePacked(pubkey2, pubkey1));
        }
    }

    //send message
    
}
