pragma solidity ^0.7.0;

import '../node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol';
import '../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol';
import './CodeZ.sol';

contract CrowdSale {
    using SafeMath for uint;
    struct Sale {
        address investor;
        uint amount;
        bool tokensWithdrawn;
    }
    mapping(address => Sale) public sales;
    address public admin;
    CodeZ public token;
    uint256 burntPercentage = 2;
    uint256 public maxToken = 10e18;
    constructor(
        address tokenAddress) {
        token = CodeZ(tokenAddress);
        admin = msg.sender;
    }   
    function buy(uint ethAmount, address payable CrowdSaleAddress)
        external payable {
        require(ethAmount<=5e17,'Amount is High');
        require(maxToken>=address(this).balance.add(ethAmount));
        uint256 tokenAmount = ethAmount.mul(100e18).div(1e17);
        uint256 burnAmount = burntPercentage.mul(100).div(tokenAmount);
        //address payable CrowdSaleAddress = address(this);
        CrowdSaleAddress.transfer(ethAmount);  //default method to send ether
        token.mint(address(this), tokenAmount);
        token.burn(address(this), burnAmount);
        sales[msg.sender] = Sale(
            msg.sender,
            tokenAmount.sub(burnAmount),
            false
        );
    }
    
    function withdrawTokens()
        external {
        Sale storage sale = sales[msg.sender];
        require(sale.amount > 0, 'only investors');
        require(sale.tokensWithdrawn == false, 'tokens were already withdrawn');
        sale.tokensWithdrawn = true;
        token.transfer(sale.investor, sale.amount);
    }   
    modifier onlyAdmin() {
        require(msg.sender == admin, 'only admin');
        _;
    }
}