// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import './Token.sol';

contract Exchange{
    // Exchange has fee account
    address public feeAccount;
    
    // Exchange has fee percent
    uint256 public feePercent;

    // TRACK FEE ACCOUNTS
    constructor(address _feeAccount, uint256 _feePercent){
         feeAccount = _feeAccount;
         feePercent = _feePercent;
    }

    // Mapping to track the balances of each user
    mapping(address=>mapping(address=>uint256)) public tokens;

    // Mapping of ORDERS
    mapping(address=>_Order) public orders;

    // Mapping cancelled Orders (id=>bool)
    mapping(uint256=>bool) public orderCancelled;

    // Mapping of filled Orders (id=>bool)
    mapping(uint256=>bool) public orderFilled;

    // Counter to generate IDs
    uint256 public orderCount;

    // Sturucture to manage orders
    struct _Order{
        uint256 id; // order id
        address user; // user who makes the order
        address tokenGet;
        uint256 amountGet;
        address tokenGive;
        uint256 amountGive;
        uint256 timeStamp;
    }

    // Events
    event Deposit(
        address token, 
        address user, 
        uint256 amount, 
        uint256 balance);

    event Withdraw(
        address token, 
        address user, 
        uint256 amount, 
        uint256 balance);

    event Order(
        uint256 id, 
        address user, 
        address tokenGet, 
        uint256 amountGet, 
        address tokenGive, 
        uint256 amountGive, 
        uint256 timestamp);

    event Cancel(
        uint256 id, 
        address user, 
        address tokenGet, 
        uint256 amountGet, 
        address tokenGive, 
        uint256 amountGive, 
        uint256 timestamp);
    event Trade(
        uint256 id, 
        address user, 
        address tokenGet, 
        uint256 amountGet, 
        address tokenGive, 
        uint256 amountGive,
        address creator,
        uint256 timestamp);

    // DEPOSIT TOKENS //
    function depositToken(address _token, uint256 _amount) public{
        // Transfer Token to Exchange
        require(Token(_token).transferFrom(msg.sender, address(this), _amount));
        
        // Update user balance
        tokens[_token][msg.sender] = tokens[_token][msg.sender] + _amount;

        // Emit an event
        emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    // WITHDRAW TOKENS
    function withdrawTokens(address _token, uint256 _amount) public{
        // Ensure user has enough tokens to withdraw
        require(tokens[_token][msg.sender] >= _amount);

        // Transfer tokens to user
        Token(_token).transfer(msg.sender, _amount);
        
        // Update user balance
        tokens[_token][msg.sender] = tokens[_token][msg.sender] - _amount;

        // Emit event
        emit Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    // Check Balances
    function balanceOf(address _token, address _user) public view returns (uint256){
        return tokens[_token][_user];
    }

    //
}