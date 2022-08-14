from brownie import accounts
from scripts.deploy_token import deploy_token
from scripts.deploy_exchange import deploy_exchange
from web3 import Web3
import pytest

@pytest.fixture
def test_exchange_deploy():
    # deploy exchange contract
    exchange = deploy_exchange(accounts[1], 10, accounts[0])

    # deploy token 1
    token1 = deploy_token('Token 1', 'TK1', 1000000, accounts[0])

    # deploy token 2
    token2 = deploy_token('Token 2', 'TK2', 1000000, accounts[0])

    return(token1, token2, exchange)

def test_exchange_setup(test_exchange_deploy):
    # get object
    exchange = test_exchange_deploy[2]

    # test constructor
    feeAccount = exchange.feeAccount()
    assert feeAccount == accounts[1]

    feePercent = exchange.feePercent()
    assert feePercent == 10

def test_deposit_withdraw(test_exchange_deploy):
    # get objects
    tk1 = test_exchange_deploy[0]
    tk2 = test_exchange_deploy[1]
    exchange = test_exchange_deploy[2]
    usr1 = accounts[5]
    usr2 = accounts[6]
    # define objects
    tk1_amount = Web3.toWei('100', 'ether')
    tk2_amount = Web3.toWei('150', 'ether')

    # TRANSFER
    tk1_transfer = tk1.transfer(usr1, tk1_amount, {'from':accounts[0]})
    tk1_transfer.wait(1)
    
    assert tk1.balanceOf(usr1) == tk1_amount

    # DEPOSIT
    # 1st approve tokens to be moved in behalf of user
    tk1_amount = Web3.toWei('20', 'ether')
    
    tk1_approve = tk1.approve(exchange, tk1_amount, {'from': usr1})
    tk1_approve.wait(1)

    assert tk1.allowance(usr1, exchange) == tk1_amount

    tk1_deposit = exchange.depositToken(tk1.address, tk1_amount, {'from': usr1})
    tk1_deposit.wait(1)

    assert exchange.balanceOf(tk1.address, usr1) == tk1_amount

