import os
from brownie import Token, accounts
from scripts.deploy_token import deploy_sc_token
import pytest
from web3 import Web3

# deploy contract tokens
@pytest.fixture
def test_setup_token():
    
    # set addresses
    dply_tk1 = accounts[0]

    # deploy 1 token
    tk1 = deploy_sc_token('Token 1', 'TK1', 1000000, dply_tk1)

    return (tk1)

# get basic info
def test_basic_info(test_setup_token):

    # fetch token objects
    tk1 = test_setup_token

    print("\n## TESTING BASIC INFO ##")

    # tokens have a name
    tk1_name = tk1.name()
    assert tk1_name == 'Token 1'

    # tokens have a symbol
    tk1_symbol = tk1.symbol()
    assert tk1_symbol == 'TK1'

    # tokens have supply
    tk1_supply = tk1.totalSupply()
    assert tk1_supply == Web3.toWei('1000000', 'ether')

# test transfer
def test_transfer(test_setup_token):

    # fetch objects
    tk1 = test_setup_token

    # send 100 tokens to user 1 
    amount_token1 = Web3.toWei('100', 'ether')
    tx_tk1 = tk1.transfer(accounts[1], amount_token1, {'from': accounts[0]})
    tx_tk1.wait(1)

    # check balance user
    tx_balance = tk1.balanceOf(accounts[1])
    assert tx_balance == amount_token1

# test transfer from
def test_transferfrom(test_setup_token):
    
    # fetch objects
    tk1 = test_setup_token

    amount = Web3.toWei('28', 'Ether')

    # allow tokens to user 1
    tx_allow = tk1.approve(accounts[1], amount, {'from':accounts[0]})
    tx_allow.wait(1)

    assert tk1.allowance(accounts[0], accounts[1]) == amount

    # transfer from accounts[1] to accounts[2]
    amount2 = Web3.toWei('12', 'Ether')
    tx_transfer = tk1.transferFrom(accounts[0], accounts[2], amount2, {'from':accounts[1]})
    tx_transfer.wait(1)
    
    assert tk1.balanceOf(accounts[2]) == amount2
    assert tk1.allowance(accounts[0], accounts[1]) == (amount-amount2)
    