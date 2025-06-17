# 💎 Premium

**Premium** is a decentralized savings application (dApp) built on [Clarinet](https://clarinet.io/) that empowers users to **save their BTC** for a chosen duration and **earn interest** based on the length of time locked. Users can also create or join **group savings plans** with shared targets to achieve collective financial goals.

---

## 🚀 Features

- 🔒 **Time-Locked BTC Savings**  
  Deposit BTC for any period of time and earn interest based on the duration of your lock-up.

- 👥 **Group Savings**  
  Create or join savings groups where users contribute collectively to reach a target goal.

- 💰 **Interest Accrual**  
  Interest is algorithmically calculated based on duration and total savings pool.

- 🎯 **Target-Based Goals**  
  Set savings goals and track progress, either individually or with a group.

---

## 🛠 Built With

- **Clarinet** — Smart contract development framework for the Stacks blockchain
- **Clarity** — Smart contract language optimized for predictable smart contracts on Bitcoin
- **Stacks Blockchain** — A Bitcoin layer for smart contracts
- **React / Next.js** *(optional front end stack if you use it)*
- **TailwindCSS** *(for responsive UI if applicable)*



<!-- ## 📦 Project Structure
premium/
├── contracts/          # Clarity smart contracts
├── frontend/           # Frontend code (if any)
├── tests/              # Clarinet unit tests
├── README.md           # Project documentation
└── Clarinet.toml       # Clarinet project configuration

--- -->

## 📄 Smart Contract Overview

### `premium-savings.clar`

| Function | Description |
|---------|-------------|
| `deposit(amount, duration)` | Locks user BTC for a set period and starts interest accrual |
| `create-group(name, goal, members)` | Initializes a new savings group with a set of members and a goal |
| `contribute(group-id, amount)` | Allows members to contribute towards their group’s target |
| `withdraw()` | Enables users to withdraw principal + interest after lock period |
| `claim-group-reward(group-id)` | Distributes rewards if group goal is achieved |

---
<!-- 
## 🧪 Running Locally

### 1. Clone the Repo

```bash
git clone https://github.com/yourusername/premium.git
cd premium -->