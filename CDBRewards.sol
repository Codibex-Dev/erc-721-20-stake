// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CDBRewards is ERC20, ERC20Burnable, Ownable {

    mapping(address => bool) controllers;

    constructor(address initialOwner)
        ERC20("CDBRewards", "CDBR")
        Ownable(initialOwner)
    {}

    modifier onlyControllers {
        require(controllers[msg.sender], "Only controllers can mint");
        _;
    }

    function mint(address to, uint256 amount) external onlyControllers {
        _mint(to, amount);
    }

    function burnFrom(address account, uint256 amount) public override {
        if (controllers[msg.sender]) {
            _burn(account, amount);
        } else {
            super.burnFrom(account, amount);
        }
    }

    function addController(address controller) external onlyOwner {
        controllers[controller] = true;
    }

    function removeController(address controller) external onlyOwner {
        controllers[controller] = false;
    }
}
