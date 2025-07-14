# 💎 Premium: Decentralized BTC Savings on Stacks

**Premium** is a decentralized savings application (dApp) built with [Clarinet](https://clarinet.io/) for the [Stacks](https://stacks.co/) blockchain. It empowers users to **lock BTC** for a chosen duration and **earn interest** based on the lock period. Users can also create or join **group savings plans** to achieve collective financial goals.

---

## �� Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Setup & Installation](#setup--installation)
- [Building & Testing Contracts](#building--testing-contracts)
- [Smart Contract Overview](#smart-contract-overview)
- [Interacting with the Contract](#interacting-with-the-contract)
- [Troubleshooting & Linter Errors](#troubleshooting--linter-errors)
- [Contributing](#contributing)
- [Support](#support)

---

## 🚀 Features

- **Time-Locked BTC Savings**: Deposit BTC for a set period and earn interest.
- **Group Savings**: Create or join savings groups with shared targets and lock periods.
- **Interest Accrual**: Algorithmic interest based on duration and pool size, paid on withdrawal.
- **Admin Functions**: Contract owner can transfer ownership and perform emergency withdrawals.
- **Events**: Emits events for deposits, withdrawals, group actions for better tracking.

---

## 🗂 Project Structure

```
premium/
├── contracts/           # Clarity smart contracts & Clarinet config
│   ├── contracts/       # .clar contract files
│   ├── tests/           # Contract unit tests
│   ├── settings/        # Network settings (Devnet, etc.)
│   ├── Clarinet.toml    # Clarinet project config
│   └── ...
├── frontend/            # (Optional) Frontend dApp (React, etc.)
└── readme.md            # Project documentation
```

---

## 🛠 Prerequisites

- [Clarinet](https://docs.hiro.so/clarinet/get-started/installation) (for Clarity contract development)
- [Node.js](https://nodejs.org/) (for frontend, if used)
- [Stacks Blockchain](https://stacks.co/) (for deploying contracts)

---

## ⚡️ Setup & Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/premium.git
cd premium
```

### 2. Install Clarinet (if not already installed)

```bash
curl -sSfL https://get.clarinet.io | sh
```

### 3. (Optional) Install Frontend Dependencies

```bash
cd frontend
npm install
```

---

## 🧪 Building & Testing Contracts

### 1. Build Contracts

```bash
cd contracts
clarinet check
```

### 2. Run Unit Tests

```bash
clarinet test
```

### 3. Deploy to Devnet/Testnet

- Update `settings/Devnet.toml` as needed.
- Deploy using:

```bash
clarinet integrate
```

---

## 📄 Smart Contract Overview

### Main Contract: `premiumv2.clar`

| Function                                         | Description                                                                |
| ------------------------------------------------ | -------------------------------------------------------------------------- |
| `deposit(amount, lock-period)`                   | Locks user BTC for a set period and starts interest accrual                |
| `withdraw(deposit-id)`                           | Enables users to withdraw principal + interest after lock period           |
| `create-group(goal, lock-period)`                | Initializes a new savings group with members and a target goal             |
| `contribute-to-group(group-id, amount)`          | Allows group members to contribute towards the group goal                  |
| `withdraw-group(group-id)`                       | Enables group members to withdraw their share + interest after lock period |
| `set-contract-owner(new-owner)`                  | Admin: Transfer contract ownership                                         |
| `emergency-withdraw(user, amount)`               | Admin: Emergency transfer of funds                                         |
| `get-user-deposit-count(user)`                   | Returns number of deposits for a user                                      |
| `get-deposit(user, deposit-id)`                  | Returns details of a specific deposit                                      |
| `get-group(group-id)`                            | Returns group details                                                      |
| `get-user-group-contribution(group-id, user)`    | Returns a user's contribution to a group                                   |
| `calculate-potential-interest(user, deposit-id)` | Read-only: Calculates potential interest for a deposit                     |

- **Interest Calculation:** Interest is calculated at withdrawal based on the amount and lock period.
- **Group Logic:** Groups are only closed when the last member withdraws.
- **Admin Functions:** Only the contract owner can call admin functions.
- **Events:** Events are emitted for deposits, withdrawals, group creation, and group withdrawals.

---

## 🤝 Interacting with the Contract

You can interact with the contract using Clarinet console or deploy to a Stacks testnet/devnet:

### 1. Open Clarinet Console

```bash
clarinet console
```

### 2. Call Contract Functions

Example (replace with actual contract address):

```lisp
(contract-call? .premiumv2 deposit u100000 u30)
(contract-call? .premiumv2 withdraw u1)
(contract-call? .premiumv2 create-group u1000000 u30)
(contract-call? .premiumv2 contribute-to-group u1 u50000)
(contract-call? .premiumv2 withdraw-group u1)
```

- See contract source for full function signatures and usage.

---

## 🛠️ Troubleshooting & Linter Errors

### Common Clarity Linter Issues

- **Let Bindings:** Only use `(name value)` in let bindings. Do not use `=` as a let value.
- **Equality Checks:** Use `(= a b)` only in expressions, not as a let value.
- **Variable Scope:** Ensure all variables are defined in the current let or function scope.
- **Function Names:** Use only valid Clarity primitives (e.g., `is-eq?` in Clarity 2.1+, otherwise use `=` in expressions).
- **Events:** Make sure all event functions are defined at the top of your contract.

### Example Error Fixes

- **Unknown symbol, '=':** Move the equality check into an `if` expression, not a let binding.
- **Unresolved function:** Ensure the function is defined or imported.
- **Variable not in scope:** Define the variable in the current let or function.

### Tips

- Run `clarinet check` often to catch syntax issues early.
- Consult the [Clarity Reference](https://docs.stacks.co/write-smart-contracts/reference) for up-to-date syntax and best practices.

---

## 🧑‍💻 Contributing

Contributions are welcome! To contribute:

1. Fork the repo
2. Create a feature branch
3. Commit your changes
4. Open a pull request

---

## 🆘 Support

- For issues, open a [GitHub Issue](https://github.com/yourusername/premium/issues)
- For questions, reach out via [Stacks Discord](https://discord.com/invite/Stacks)

---

**Premium** — Built with ❤️ for the Stacks & Bitcoin community.
