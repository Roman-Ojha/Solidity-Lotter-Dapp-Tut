// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract Lottery {
    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender;
        // because here we are assgning 'msg.sender' address to the manager it means that when we will deoply the contract at that time from which address we are deploying the contract that address will become the manager
    }

    receive() external payable {
        // this function can only use one time on contract
        // because this function is payable after participant transfer ether into our contract, contract will get that much amount of ether
        require(msg.value == 2 ether);
        // here we will use require state so if participant is sending 2 ether only after that they can participant
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint256) {
        require(msg.sender == manager);
        // here we are using require because only manager can call this function
        return address(this).balance;
    }

    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    // this is the algorithm to generate random  number
                    // this reandom method is not much recommended
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        participants.length
                    )
                )
            );
    }

    function selectWinner() public {
        require(msg.sender == manager);
        require(participants.length >= 3);
        uint256 r = random();
        uint256 index = r % participants.length;
        // generating random index
        address payable winner;
        winner = participants[index];
        winner.transfer(getBalance());
        // here we will transfer all the contract balance to winner
        participants = new address payable[](0);
        // reseting participants after selecting winner
    }
}
