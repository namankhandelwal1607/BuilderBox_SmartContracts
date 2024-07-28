# BuilderBox_SmartContracts

## Problem Statement
Recent increases in structural failures, such as collapsing walls, bridges, and airport ceilings, are often due to contractors using substandard materials to maximize profits. The lack of transparency and accountability in the current system results in unsafe structures, increased accidents, and difficulty in holding contractors accountable. To address this, we propose a decentralized application (DApp) using blockchain technology to ensure transparent and quality-driven construction contract management. The DApp will feature a transparent bidding process, immutable records, a reputation system for contractors, and automated compliance with construction standards. This solution aims to reduce structural failures, enhance accountability, restore public trust, and streamline contract management processes in the construction industry.

# Contract Explanation

## Contractor.sol
### It is login process for contractors and has contractor has to do following things
- Connect MetaMask Wallet
- Add name and resume
- Ask for verification

## VerifiedContractor.sol
### Here verification process , of contract occurs
- Verfier checks Contractor Resume
- See all proofs of his work.
- Rate him  on basis of 5 parameter:  Financial Capabilities,Tech Capabilities, Experience, Performance, Health and Safety

## Dealer.sol
#### It is login page for dealers.
- Connect MetaMask Wallet
- Enter name of dealer
- Simply submit

## Deal.sol
### Through this, all registered dealers can make their deals to be live so that contractors can bid over them.
- Enter deal name
- Pass all other requirements for 5 parameters on the basis of 10.
- Send budget of your deal in the form  of funds.

## Request.sol
### Due to this contract, all contractors can bid on the deals 
- Select Deal
- Pass your budget for that deal.
- Add your estimate deal

## Sequence.sol
### It is basically a helper contract for other contracts.
- It gives sequence of contractors.
- They are in decending order on basis of points calculated.
- Out of budget contractors are not there here.

## DealFinal.sol
### It finalizes the deal, and send funds to contractors and return the remaing to dealer
- If within budget, send funds to contractor and remaining to dealer.
- If all contractors out of budget, send all funds to dealer
- If no one applied for that deal, then send all funds to dealer

## Review.sol
### Coming soon feature
- After deal completed, dealers can give review to contractor.
- This will enhance their rating in all 5 parameter


