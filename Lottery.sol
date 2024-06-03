// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager;
    address[] public players;

    event PlayerEntered(address indexed player);
    event WinnerSelected(address indexed winner);

    constructor() {
        manager = msg.sender;
    }

    function enter() external payable {
        require(msg.value == 0.1 ether, "Incorrect ticket price");
        players.push(msg.sender);
        emit PlayerEntered(msg.sender);
    }

    function pickWinner() external {
        require(msg.sender == manager, "Only manager can pick winner");
        require(players.length > 0, "No players entered");

        uint256 index = random() % players.length;
        address winner = players[index];
        payable(winner).transfer(address(this).balance);
        players = new address ;

        emit WinnerSelected(winner);
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }

    function getPlayers() external view returns (address[] memory) {
        return players;
    }
}
