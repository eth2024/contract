// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Picademy is ERC20, ERC20Burnable, Ownable {
    constructor()
        ERC20("Picademy", "PICA")
        Ownable()
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}