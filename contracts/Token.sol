// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Token{

    // STATE VARIABLES
    string public name; 
    string public symbol;
    uint256 public decimals = 18;
    uint256 public totalSupply;
    
    // MAPPINGS
    mapping(address=>uint256) public balanceOf;
    mapping(address=>mapping(address=>uint256)) public allowance;

    // EVENTS
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // CONSTRUCTOR
    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _totalsupp
    ){
        name = _name; 
        symbol = _symbol; 
        totalSupply = _totalsupp * (10 ** decimals); 
        balanceOf[msg.sender] = totalSupply;
    }

    // TRANSFER TOKENS
    function transfer( address _to, uint256 _value )
        public 
        returns( bool success )
    {   
        
        require(balanceOf[msg.sender] >= _value);

        _transfer(msg.sender, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) 
        public
        returns(bool success)
    {   
        require(_spender != address(0));
        
        allowance[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);
        
        return true;
    }

    function _transfer(address _from, address _to, uint256 _value) internal{
        // requires
        require(_to != address(0));

        // Deduct tokens from spender (msg.sender)
        balanceOf[_from] = balanceOf[_from] - _value;
        balanceOf[_to] = balanceOf[_to] + _value;
        
        // emit event
        emit Transfer(_from, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value)
        public
        returns(bool success)
    {
        // CHECK APPROVAL
        require(_value <= balanceOf[_from]); // check that spender has funds
        require(_value <= allowance[_from][msg.sender]); // value spend is less or equal thant the allowed

        // reset allowance
        allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value; // update value allowed to spend
        
        // SPEND TOKEN
        _transfer(_from, _to, _value);

        return true;
    }
}
