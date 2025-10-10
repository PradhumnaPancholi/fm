---SCRATCH Token---
Auditing Questions

What happens if someone calls transfer(address(0), 100)?

Answer: Reverts with "Can Not Transfer To Zero Address!" ✅


What happens if Alice approves Bob for 50, then Bob tries transferFrom(alice, charlie, 100)?

Answer: Reverts with "Amount Exceeds Allowance!" ✅


What happens if someone does transfer(to, 0) (zero amount)?
Answer: Goes through! ✅ (Valid per ERC20 standard)
Events emit Transfer(from, to, 0)


Can someone transfer to themselves?
transfer(msg.sender, 100)
Answer: Yes! Balance stays same, but event emits ✅
Not harmful, wastes gas
