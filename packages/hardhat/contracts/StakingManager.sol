// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingManager is Ownable {
    IERC20 public stakingToken;

    mapping(address => uint256) public stakes;
    uint256 public slashPercentage = 100; // 슬래싱할 때 소각되는 토큰 비율 (예: 100%)

    event Staked(address indexed validator, uint256 amount);
    event Slashed(address indexed validator, uint256 amount);

    constructor(IERC20 _stakingToken) {
        stakingToken = _stakingToken;
    }

    // 스테이킹
    function stake(uint256 _amount) public {
        require(_amount >= 10e18, "Amount must be greater than 10 tokens");
        stakes[msg.sender] += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        emit Staked(msg.sender, _amount);
    }

    // 슬래싱
    function slash(address _validator) public onlyOwner {
        require(stakes[_validator] > 0, "Validator has no stake");

        uint256 slashAmount = stakes[_validator] * slashPercentage / 100;
        stakes[_validator] -= slashAmount;

        ERC20Burnable(address(stakingToken)).burn(slashAmount);
        emit Slashed(_validator, slashAmount);
    }

    // 스테이킹된 토큰 회수 (슬래싱 없이, 벨리데이터가 자신의 토큰을 회수)
    function unstake(uint256 _amount) public {
        require(_amount > 0 && _amount <= stakes[msg.sender], "Invalid unstake amount");
        stakes[msg.sender] -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    // stake된 수량 조회
    function getStakeAmount(address _validator) public view returns (uint256) {
        return stakes[_validator];
    }
    
    function getTokenAddress() public view returns (address) {
        return address(stakingToken);
    }
}
