pragma solidity ^0.7.0;

import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import '../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';

contract CodeZ is ERC20 {
  using SafeMath for uint;
  address public admin;
  uint public maxTotalSupply;

  constructor(
    string memory name, 
    string memory symbol,
    uint _maxTotalSupply
  ) ERC20(name, symbol) {
    admin = msg.sender;
    maxTotalSupply = _maxTotalSupply;
  }

  function updateAdmin(address newAdmin) external {
    require(msg.sender == admin, 'only admin');
    admin = newAdmin;
  }

  function mint(address account, uint256 amount) external {
    require(msg.sender == admin, 'only admin');
    uint totalSupply = totalSupply();
    require(totalSupply.add(amount) <= maxTotalSupply, 'above maxTotalSupply limit');
    _mint(account, amount);
  }
    function burn(address account, uint256 amount) external {
    require(msg.sender == admin, 'only admin');
    _burn(account, amount);
  }
}