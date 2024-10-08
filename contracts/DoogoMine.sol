// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract DoogoMine is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    mapping(address => string[]) private userUrls;
    mapping(bytes32 => bool) private minedUrls;

    event UrlSubmitted(address indexed user, string url);

    function getVersion() external pure returns (string memory) {
        return "v1";
    }
    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    function mine(string calldata url) external onlyNotMined(url) {
        require(bytes(url).length > 0, "URL cannot be empty");

        userUrls[msg.sender].push(url);
        minedUrls[keccak256(abi.encodePacked(url))] = true;

        emit UrlSubmitted(msg.sender, url);
    }

    function getUserUrls(address user) external view returns (string[] memory) {
        return userUrls[user];
    }

    modifier onlyNotMined(string calldata url) {
        require(
            !minedUrls[keccak256(abi.encodePacked(url))],
            "URL already mined"
        );
        _;
    }
}
