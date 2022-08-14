from brownie import Exchange, accounts

def deploy_exchange(feeAccount, feePercent, deployer):
    exchange = Exchange.deploy(feeAccount, feePercent, {'from': deployer})
    return exchange
    
def main():
    deploy_exchange(accounts[3], 10, accounts[0])