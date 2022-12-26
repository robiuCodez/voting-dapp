// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

/// @title A title that should describe the contract/interface
/// @author The name of the author
/// @notice Explain to an end user what this does
/// @dev Explain to a developer any extra details

// implements a token that can be transferred
// used to exchange / store value.
contract Token {
    string public tokenName = "";
    string public tokenSymbol = "";

    // total supply
    uint public totalSupply = 1000000000;

    // owner
    address public owner;

    // store each user's account balance
    mapping(address => uint) public balances;

    // Events help off-chain applications understand what happened
    // within the contract.
    event Transfer(address indexed _from, address indexed _to, uint _value);

    /**
     * Contract Initialisation
     */
    constructor() {
        // assign all tokens to contract owner.
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    /**
     * transfer token function
     *
     * 'external' makes it 'only' callable outside of the contract.
     */
    function transferToken(address _to, uint _amount) external {
        // check if the sender has more than enough balance
        require(balances[msg.sender] >= _amount, "Insufficient Token");

        // debit the sender
        balances[msg.sender] -= _amount;

        // credit the receiver
        balances[_to] += _amount;

        // notify off-chain applications of the Transfer.
        emit Transfer(msg.sender, _to, _amount);
    }

    /**
     * Readonly function -- to retrieve the a user's account balance.
     *
     * 'view' indicates that, it doesn't modify the contract's state.
     * ie. it can be called without executing a txn.
     */
    function getAccountBalance(
        address _accountNo
    ) external view returns (uint) {
        return balances[_accountNo];
    }
}
