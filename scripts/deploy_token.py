import os
from brownie import Token, accounts

def deploy_sc_token(tk_name, tk_symbol, tk_supply, deployer):
    token = Token.deploy(tk_name, tk_symbol, tk_supply, {'from': deployer })
    return token

def main():
    deploy_sc_token("Token 1", "TK1", 1000000, accounts[0])
    
    