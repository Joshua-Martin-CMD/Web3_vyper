# @Version ^0.3.0

"""
   - Storing Eth to Contract
   - Sending Eth from Contract to another address
   - Send
"""

# Eth is transfered from EOA --> Into this Contract --> then to Address

@external
@payable
def sendEther(_addr: address):
    # Calls __default__ When ETH is Sent to Contract
    # Forward Gas Cost
    send (_addr, msg.value)