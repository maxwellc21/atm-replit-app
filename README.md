# 🏦 PHP Online Banking App

A simple **online banking-style web app** built with **PHP**, **HTML**, **CSS**, and **JavaScript**. It is designed to run easily on **Replit** or with PHP's built-in server.

## ✨ Features

- 🔐 Banking-style dashboard UI
- 👤 Account CRUD
  - Create account
  - View account
  - Update account name
  - Delete account
- 💰 ATM actions
  - Check balance
  - Deposit money
  - Withdraw money
- 📜 Transaction history
- 🎨 Modern responsive interface
- 🗂 JSON file storage, so no database setup is required
- ☁️ GitHub-ready and Replit-ready

## 📁 Project Structure

```text
bank-app/
├── .replit
├── replit.nix
├── README.md
├── public/
│   ├── index.php
│   ├── api.php
│   └── assets/
│       ├── css/style.css
│       ├── js/app.js
│       └── images/
│           ├── logo.svg
│           ├── bank-card.svg
│           └── avatar.svg
├── src/
│   ├── DataStore.php
│   ├── AccountService.php
│   └── TransactionService.php
└── storage/
    └── bank.json
```

## ▶️ Run on Replit

1. Upload the project to **GitHub** or import the ZIP into **Replit**.
2. Open the project in Replit.
3. Click **Run**.
4. Replit will start this command:

```bash
php -S 0.0.0.0:3000 -t public
```

5. Open the app in the browser.

## ▶️ Run locally

Make sure PHP is installed, then run:

```bash
php -S 127.0.0.1:3000 -t public
```

Open:

```text
http://127.0.0.1:3000
```

## 🧪 How to Test in the Browser

### 1. Home Dashboard
- Open the app.
- You should see a banking dashboard.
- The default account should already appear.

### 2. Create an Account
- In **Create Account**, enter:
  - account number
  - account name
  - opening balance
- Click **Create Account**.
- The new account should appear in the account list.

### 3. Check Balance
- Select an account from the list.
- The balance card updates automatically.

### 4. Deposit
- Enter an amount in the **Deposit** form.
- Click **Deposit**.
- Balance should increase.
- A transaction should be added.

### 5. Withdraw
- Enter an amount in the **Withdraw** form.
- Click **Withdraw**.
- Balance should decrease if funds are available.

### 6. Update Account Name
- Choose an account.
- In **Edit Selected Account**, change the name.
- Click **Update Account**.

### 7. Delete Account
- Choose an account.
- Click **Delete Account**.
- The account will be removed.

## 🧪 API Testing with cURL

### ✅ Check health

```bash
curl http://127.0.0.1:3000/api.php
```

### ✅ Get all accounts

```bash
curl http://127.0.0.1:3000/api.php/accounts
```

### ✅ Create account

```bash
curl -X POST http://127.0.0.1:3000/api.php/accounts \
  -H "Content-Type: application/json" \
  -d '{"account_number":"2001","account_name":"Sarah James","balance":1000}'
```

### ✅ Update account

```bash
curl -X PUT http://127.0.0.1:3000/api.php/accounts/2001 \
  -H "Content-Type: application/json" \
  -d '{"account_name":"Sarah J."}'
```

### ✅ Delete account

```bash
curl -X DELETE http://127.0.0.1:3000/api.php/accounts/2001
```

### ✅ Deposit

```bash
curl -X POST http://127.0.0.1:3000/api.php/deposit \
  -H "Content-Type: application/json" \
  -d '{"account_number":"1001","amount":150}'
```

### ✅ Withdraw

```bash
curl -X POST http://127.0.0.1:3000/api.php/withdraw \
  -H "Content-Type: application/json" \
  -d '{"account_number":"1001","amount":50}'
```

### ✅ Transactions for one account

```bash
curl http://127.0.0.1:3000/api.php/transactions?account_number=1001
```

## 🧾 Default Account

- **Account Number:** `1001`
- **Account Name:** `Maxie Cletus`
- **Starting Balance:** `500.00`

## 🛠 Notes

- Data is stored in `storage/bank.json`.
- No MySQL setup is required.
- This is ideal for demos, practice, Replit, and simple coursework.

## 🚀 Next Improvements

- Add login authentication
- Add transfer between accounts
- Add chart analytics
- Add admin/user roles
- Connect to MySQL later if needed
