#!/usr/bin/env bash
set -e
cd /mnt/data/bank-app
mkdir -p public/assets/css public/assets/js public/assets/images src/data storage
cat > README.md <<'MD'
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
MD

cat > .replit <<'R'
run = "php -S 0.0.0.0:3000 -t public"
entrypoint = "public/index.php"
modules = ["php-web"]
R

cat > replit.nix <<'N'
{ pkgs }: {
  deps = [
    pkgs.php84
  ];
}
N

cat > storage/bank.json <<'JSON'
{
  "accounts": [
    {
      "account_number": "1001",
      "account_name": "Maxie Cletus",
      "balance": 500
    }
  ],
  "transactions": [
    {
      "id": 1,
      "account_number": "1001",
      "type": "opening_balance",
      "amount": 500,
      "created_at": "2026-04-22 09:00:00"
    }
  ]
}
JSON

cat > src/DataStore.php <<'PHP'
<?php

class DataStore
{
    private string $file;

    public function __construct(string $file)
    {
        $this->file = $file;
        if (!file_exists($this->file)) {
            $this->initialize();
        }
    }

    private function initialize(): void
    {
        $default = [
            'accounts' => [
                [
                    'account_number' => '1001',
                    'account_name' => 'Maxie Cletus',
                    'balance' => 500.00,
                ],
            ],
            'transactions' => [
                [
                    'id' => 1,
                    'account_number' => '1001',
                    'type' => 'opening_balance',
                    'amount' => 500.00,
                    'created_at' => date('Y-m-d H:i:s'),
                ],
            ],
        ];

        $this->write($default);
    }

    public function read(): array
    {
        $content = file_get_contents($this->file);
        $data = json_decode($content ?: '{}', true);
        return is_array($data) ? $data : ['accounts' => [], 'transactions' => []];
    }

    public function write(array $data): void
    {
        $dir = dirname($this->file);
        if (!is_dir($dir)) {
            mkdir($dir, 0777, true);
        }

        $fp = fopen($this->file, 'c+');
        if ($fp === false) {
            throw new RuntimeException('Unable to open storage file.');
        }

        flock($fp, LOCK_EX);
        ftruncate($fp, 0);
        fwrite($fp, json_encode($data, JSON_PRETTY_PRINT));
        fflush($fp);
        flock($fp, LOCK_UN);
        fclose($fp);
    }
}
PHP

cat > src/AccountService.php <<'PHP'
<?php
require_once __DIR__ . '/DataStore.php';

class AccountService
{
    private DataStore $store;

    public function __construct(DataStore $store)
    {
        $this->store = $store;
    }

    public function getAllAccounts(): array
    {
        $data = $this->store->read();
        return $data['accounts'];
    }

    public function getAccount(string $accountNumber): ?array
    {
        foreach ($this->getAllAccounts() as $account) {
            if ($account['account_number'] === $accountNumber) {
                return $account;
            }
        }
        return null;
    }

    public function createAccount(string $accountNumber, string $accountName, float $balance): array
    {
        $accountNumber = trim($accountNumber);
        $accountName = trim($accountName);

        if ($accountNumber === '' || $accountName === '') {
            return ['success' => false, 'message' => 'Account number and name are required.'];
        }

        if ($balance < 0) {
            return ['success' => false, 'message' => 'Opening balance cannot be negative.'];
        }

        $data = $this->store->read();
        foreach ($data['accounts'] as $account) {
            if ($account['account_number'] === $accountNumber) {
                return ['success' => false, 'message' => 'Account number already exists.'];
            }
        }

        $data['accounts'][] = [
            'account_number' => $accountNumber,
            'account_name' => $accountName,
            'balance' => round($balance, 2),
        ];

        $nextId = empty($data['transactions']) ? 1 : (max(array_column($data['transactions'], 'id')) + 1);
        $data['transactions'][] = [
            'id' => $nextId,
            'account_number' => $accountNumber,
            'type' => 'opening_balance',
            'amount' => round($balance, 2),
            'created_at' => date('Y-m-d H:i:s'),
        ];

        $this->store->write($data);

        return ['success' => true, 'message' => 'Account created successfully.'];
    }

    public function updateAccount(string $accountNumber, string $accountName): array
    {
        $accountName = trim($accountName);
        if ($accountName === '') {
            return ['success' => false, 'message' => 'Account name is required.'];
        }

        $data = $this->store->read();
        $found = false;

        foreach ($data['accounts'] as &$account) {
            if ($account['account_number'] === $accountNumber) {
                $account['account_name'] = $accountName;
                $found = true;
                break;
            }
        }

        if (!$found) {
            return ['success' => false, 'message' => 'Account not found.'];
        }

        $this->store->write($data);
        return ['success' => true, 'message' => 'Account updated successfully.'];
    }

    public function deleteAccount(string $accountNumber): array
    {
        if ($accountNumber === '1001') {
            return ['success' => false, 'message' => 'Default demo account cannot be deleted.'];
        }

        $data = $this->store->read();
        $beforeCount = count($data['accounts']);
        $data['accounts'] = array_values(array_filter(
            $data['accounts'],
            fn ($account) => $account['account_number'] !== $accountNumber
        ));

        if (count($data['accounts']) === $beforeCount) {
            return ['success' => false, 'message' => 'Account not found.'];
        }

        $data['transactions'] = array_values(array_filter(
            $data['transactions'],
            fn ($txn) => $txn['account_number'] !== $accountNumber
        ));

        $this->store->write($data);
        return ['success' => true, 'message' => 'Account deleted successfully.'];
    }
}
PHP

cat > src/TransactionService.php <<'PHP'
<?php
require_once __DIR__ . '/DataStore.php';

class TransactionService
{
    private DataStore $store;

    public function __construct(DataStore $store)
    {
        $this->store = $store;
    }

    public function deposit(string $accountNumber, float $amount): array
    {
        return $this->changeBalance($accountNumber, $amount, 'deposit');
    }

    public function withdraw(string $accountNumber, float $amount): array
    {
        if ($amount <= 0) {
            return ['success' => false, 'message' => 'Amount must be greater than zero.'];
        }

        $data = $this->store->read();
        foreach ($data['accounts'] as &$account) {
            if ($account['account_number'] === $accountNumber) {
                if ($account['balance'] < $amount) {
                    return ['success' => false, 'message' => 'Insufficient funds.'];
                }
                $account['balance'] = round($account['balance'] - $amount, 2);
                $this->addTransaction($data, $accountNumber, 'withdraw', $amount);
                $this->store->write($data);
                return ['success' => true, 'message' => 'Withdrawal successful.', 'balance' => $account['balance']];
            }
        }

        return ['success' => false, 'message' => 'Account not found.'];
    }

    public function getTransactions(?string $accountNumber = null): array
    {
        $data = $this->store->read();
        $transactions = $data['transactions'];

        if ($accountNumber !== null && $accountNumber !== '') {
            $transactions = array_values(array_filter(
                $transactions,
                fn ($txn) => $txn['account_number'] === $accountNumber
            ));
        }

        usort($transactions, fn ($a, $b) => strcmp($b['created_at'], $a['created_at']));
        return $transactions;
    }

    private function changeBalance(string $accountNumber, float $amount, string $type): array
    {
        if ($amount <= 0) {
            return ['success' => false, 'message' => 'Amount must be greater than zero.'];
        }

        $data = $this->store->read();
        foreach ($data['accounts'] as &$account) {
            if ($account['account_number'] === $accountNumber) {
                $account['balance'] = round($account['balance'] + $amount, 2);
                $this->addTransaction($data, $accountNumber, $type, $amount);
                $this->store->write($data);
                return ['success' => true, 'message' => ucfirst($type) . ' successful.', 'balance' => $account['balance']];
            }
        }

        return ['success' => false, 'message' => 'Account not found.'];
    }

    private function addTransaction(array &$data, string $accountNumber, string $type, float $amount): void
    {
        $nextId = empty($data['transactions']) ? 1 : (max(array_column($data['transactions'], 'id')) + 1);
        $data['transactions'][] = [
            'id' => $nextId,
            'account_number' => $accountNumber,
            'type' => $type,
            'amount' => round($amount, 2),
            'created_at' => date('Y-m-d H:i:s'),
        ];
    }
}
PHP

cat > public/api.php <<'PHP'
<?php
require_once __DIR__ . '/../src/DataStore.php';
require_once __DIR__ . '/../src/AccountService.php';
require_once __DIR__ . '/../src/TransactionService.php';

header('Content-Type: application/json');

$store = new DataStore(__DIR__ . '/../storage/bank.json');
$accountService = new AccountService($store);
$transactionService = new TransactionService($store);

$method = $_SERVER['REQUEST_METHOD'];
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$path = preg_replace('#^/api\.php#', '', $uri);
$path = $path === '' ? '/' : $path;
$input = json_decode(file_get_contents('php://input'), true) ?? [];

function respond(array $data, int $status = 200): void
{
    http_response_code($status);
    echo json_encode($data, JSON_PRETTY_PRINT);
    exit;
}

if ($method === 'GET' && $path === '/') {
    respond(['success' => true, 'message' => 'ATM Banking API is running']);
}

if ($method === 'GET' && $path === '/accounts') {
    respond(['success' => true, 'accounts' => $accountService->getAllAccounts()]);
}

if ($method === 'POST' && $path === '/accounts') {
    $result = $accountService->createAccount(
        (string)($input['account_number'] ?? ''),
        (string)($input['account_name'] ?? ''),
        (float)($input['balance'] ?? 0)
    );
    respond($result, $result['success'] ? 201 : 400);
}

if ($method === 'PUT' && preg_match('#^/accounts/([^/]+)$#', $path, $matches)) {
    $result = $accountService->updateAccount($matches[1], (string)($input['account_name'] ?? ''));
    respond($result, $result['success'] ? 200 : 400);
}

if ($method === 'DELETE' && preg_match('#^/accounts/([^/]+)$#', $path, $matches)) {
    $result = $accountService->deleteAccount($matches[1]);
    respond($result, $result['success'] ? 200 : 400);
}

if ($method === 'POST' && $path === '/balance') {
    $account = $accountService->getAccount((string)($input['account_number'] ?? ''));
    if (!$account) {
        respond(['success' => false, 'message' => 'Account not found.'], 404);
    }
    respond(['success' => true, 'account' => $account]);
}

if ($method === 'POST' && $path === '/deposit') {
    $result = $transactionService->deposit((string)($input['account_number'] ?? ''), (float)($input['amount'] ?? 0));
    respond($result, $result['success'] ? 200 : 400);
}

if ($method === 'POST' && $path === '/withdraw') {
    $result = $transactionService->withdraw((string)($input['account_number'] ?? ''), (float)($input['amount'] ?? 0));
    respond($result, $result['success'] ? 200 : 400);
}

if ($method === 'GET' && $path === '/transactions') {
    $accountNumber = $_GET['account_number'] ?? null;
    respond(['success' => true, 'transactions' => $transactionService->getTransactions($accountNumber)]);
}

respond(['success' => false, 'message' => 'Route not found.'], 404);
PHP

cat > public/index.php <<'PHP'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaBank Online Banking</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <div class="app-shell">
        <aside class="sidebar">
            <div class="brand">
                <img src="assets/images/logo.svg" alt="NovaBank logo" class="brand-logo">
                <div>
                    <h1>NovaBank</h1>
                    <p>Online Banking</p>
                </div>
            </div>
            <nav class="menu">
                <a href="#dashboard">🏠 Dashboard</a>
                <a href="#accounts">👤 Accounts</a>
                <a href="#actions">💳 Transactions</a>
                <a href="#history">📜 History</a>
            </nav>
            <div class="profile-card">
                <img src="assets/images/avatar.svg" alt="avatar">
                <div>
                    <strong>Welcome back</strong>
                    <span>Banking Demo User</span>
                </div>
            </div>
        </aside>

        <main class="content">
            <header class="hero" id="dashboard">
                <div>
                    <p class="eyebrow">Secure digital banking</p>
                    <h2>Manage accounts, balances, and transactions in one place.</h2>
                    <p class="hero-copy">This demo includes account CRUD, deposit, withdrawal, and live transaction history.</p>
                </div>
                <img src="assets/images/bank-card.svg" alt="Bank card illustration" class="hero-image">
            </header>

            <section class="grid cards-grid">
                <article class="stat-card primary">
                    <span>Selected Account</span>
                    <h3 id="selectedAccountNumber">1001</h3>
                    <p id="selectedAccountName">Maxie Cletus</p>
                </article>
                <article class="stat-card">
                    <span>Current Balance</span>
                    <h3 id="selectedBalance">K 500.00</h3>
                    <p>Updated live from storage</p>
                </article>
                <article class="stat-card">
                    <span>Total Accounts</span>
                    <h3 id="totalAccounts">1</h3>
                    <p>Managed in this app</p>
                </article>
            </section>

            <section class="grid two-columns" id="accounts">
                <div class="panel">
                    <div class="panel-head">
                        <h3>👤 Account List</h3>
                        <button class="ghost-btn" id="refreshBtn">Refresh</button>
                    </div>
                    <div id="accountList" class="account-list"></div>
                </div>

                <div class="panel">
                    <h3>➕ Create Account</h3>
                    <form id="createAccountForm" class="form-grid">
                        <label>
                            Account Number
                            <input type="text" name="account_number" required>
                        </label>
                        <label>
                            Account Name
                            <input type="text" name="account_name" required>
                        </label>
                        <label>
                            Opening Balance
                            <input type="number" name="balance" step="0.01" min="0" required>
                        </label>
                        <button type="submit" class="primary-btn">Create Account</button>
                    </form>
                </div>
            </section>

            <section class="grid two-columns" id="actions">
                <div class="panel">
                    <h3>✏️ Edit Selected Account</h3>
                    <form id="editAccountForm" class="form-grid">
                        <label>
                            Account Number
                            <input type="text" id="editAccountNumber" disabled>
                        </label>
                        <label>
                            Account Name
                            <input type="text" id="editAccountName" required>
                        </label>
                        <div class="button-row">
                            <button type="submit" class="primary-btn">Update Account</button>
                            <button type="button" class="danger-btn" id="deleteAccountBtn">Delete Account</button>
                        </div>
                    </form>
                </div>

                <div class="panel action-panel">
                    <h3>💳 Banking Actions</h3>
                    <div class="action-grid">
                        <form id="depositForm" class="mini-form">
                            <h4>Deposit</h4>
                            <label>
                                Amount
                                <input type="number" name="amount" step="0.01" min="0.01" required>
                            </label>
                            <button type="submit" class="primary-btn">Deposit</button>
                        </form>
                        <form id="withdrawForm" class="mini-form">
                            <h4>Withdraw</h4>
                            <label>
                                Amount
                                <input type="number" name="amount" step="0.01" min="0.01" required>
                            </label>
                            <button type="submit" class="secondary-btn">Withdraw</button>
                        </form>
                    </div>
                </div>
            </section>

            <section class="panel" id="history">
                <div class="panel-head">
                    <h3>📜 Transaction History</h3>
                    <span class="chip" id="historyLabel">Showing account 1001</span>
                </div>
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Account</th>
                                <th>Type</th>
                                <th>Amount</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody id="transactionTableBody"></tbody>
                    </table>
                </div>
            </section>

            <div id="messageBox" class="message-box hidden"></div>
        </main>
    </div>

    <script src="assets/js/app.js"></script>
</body>
</html>
PHP

cat > public/assets/css/style.css <<'CSS'
:root {
    --bg: #0f172a;
    --panel: #111827;
    --panel-soft: #1f2937;
    --line: rgba(255,255,255,0.08);
    --text: #e5eefc;
    --muted: #9fb0cf;
    --primary: #38bdf8;
    --primary-dark: #0284c7;
    --danger: #ef4444;
    --success: #22c55e;
    --warning: #f59e0b;
    --shadow: 0 20px 45px rgba(0,0,0,0.28);
    --radius: 22px;
}

* { box-sizing: border-box; }
html, body { margin: 0; padding: 0; font-family: Inter, Arial, sans-serif; background: linear-gradient(135deg, #020617, #111827 55%, #0f172a); color: var(--text); }
a { color: inherit; text-decoration: none; }
img { max-width: 100%; display: block; }
button, input { font: inherit; }

.app-shell {
    min-height: 100vh;
    display: grid;
    grid-template-columns: 290px 1fr;
}

.sidebar {
    border-right: 1px solid var(--line);
    background: rgba(2, 6, 23, 0.7);
    backdrop-filter: blur(12px);
    padding: 24px;
    display: flex;
    flex-direction: column;
    gap: 24px;
}

.brand {
    display: flex;
    align-items: center;
    gap: 14px;
}
.brand h1 { margin: 0; font-size: 1.4rem; }
.brand p { margin: 4px 0 0; color: var(--muted); }
.brand-logo { width: 52px; height: 52px; }

.menu {
    display: grid;
    gap: 10px;
}
.menu a {
    padding: 12px 14px;
    border-radius: 14px;
    background: rgba(255,255,255,0.03);
    color: var(--muted);
}
.menu a:hover { background: rgba(56, 189, 248, 0.14); color: white; }

.profile-card {
    margin-top: auto;
    background: linear-gradient(180deg, rgba(56,189,248,0.08), rgba(255,255,255,0.04));
    border: 1px solid var(--line);
    border-radius: 18px;
    padding: 16px;
    display: flex;
    align-items: center;
    gap: 12px;
}
.profile-card img { width: 54px; height: 54px; }
.profile-card span { color: var(--muted); display: block; margin-top: 4px; }

.content {
    padding: 28px;
    display: grid;
    gap: 24px;
}

.hero {
    background: linear-gradient(135deg, rgba(56,189,248,0.18), rgba(30,41,59,0.75));
    border: 1px solid var(--line);
    border-radius: var(--radius);
    padding: 26px;
    box-shadow: var(--shadow);
    display: grid;
    grid-template-columns: 1.4fr 0.9fr;
    align-items: center;
    gap: 20px;
}
.eyebrow { text-transform: uppercase; letter-spacing: 0.18em; color: var(--primary); font-size: 0.78rem; margin-bottom: 10px; }
.hero h2 { margin: 0; font-size: clamp(1.8rem, 3vw, 2.8rem); line-height: 1.1; }
.hero-copy { color: var(--muted); max-width: 60ch; }
.hero-image { justify-self: end; max-width: 320px; }

.grid { display: grid; gap: 20px; }
.cards-grid { grid-template-columns: repeat(3, 1fr); }
.two-columns { grid-template-columns: repeat(2, minmax(0, 1fr)); }

.stat-card, .panel {
    background: rgba(15,23,42,0.72);
    border: 1px solid var(--line);
    border-radius: var(--radius);
    padding: 22px;
    box-shadow: var(--shadow);
}
.stat-card span, .panel-head span, label { color: var(--muted); }
.stat-card h3 { margin: 8px 0; font-size: 2rem; }
.stat-card p { margin: 0; color: var(--muted); }
.stat-card.primary { background: linear-gradient(135deg, rgba(2,132,199,0.4), rgba(15,23,42,0.8)); }

.panel h3 { margin-top: 0; }
.panel-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 16px;
}

.account-list {
    display: grid;
    gap: 12px;
    max-height: 360px;
    overflow: auto;
}
.account-item {
    border: 1px solid var(--line);
    border-radius: 18px;
    padding: 16px;
    background: rgba(255,255,255,0.03);
    cursor: pointer;
    transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
}
.account-item:hover,
.account-item.active {
    transform: translateY(-2px);
    border-color: rgba(56,189,248,0.5);
    background: rgba(56,189,248,0.08);
}
.account-item h4 { margin: 0 0 6px; }
.account-item p { margin: 4px 0; color: var(--muted); }

.form-grid, .mini-form { display: grid; gap: 14px; }
label { display: grid; gap: 8px; font-size: 0.95rem; }
input {
    width: 100%;
    padding: 12px 14px;
    border-radius: 14px;
    border: 1px solid var(--line);
    background: rgba(255,255,255,0.04);
    color: white;
    outline: none;
}
input:focus { border-color: rgba(56,189,248,0.65); box-shadow: 0 0 0 3px rgba(56,189,248,0.14); }
input:disabled { opacity: 0.75; }

.button-row, .action-grid {
    display: grid;
    gap: 12px;
}
.action-grid { grid-template-columns: repeat(2, 1fr); }
.button-row { grid-template-columns: repeat(2, 1fr); }

button {
    border: none;
    border-radius: 14px;
    padding: 12px 16px;
    cursor: pointer;
    font-weight: 700;
}
.primary-btn { background: linear-gradient(135deg, var(--primary), var(--primary-dark)); color: #03111a; }
.secondary-btn { background: linear-gradient(135deg, #f8fafc, #cbd5e1); color: #111827; }
.danger-btn { background: linear-gradient(135deg, #ef4444, #b91c1c); color: white; }
.ghost-btn { background: transparent; color: var(--muted); border: 1px solid var(--line); }

.table-wrap { overflow: auto; }
table { width: 100%; border-collapse: collapse; }
th, td { text-align: left; padding: 14px 12px; border-bottom: 1px solid var(--line); }
th { color: #cfe6ff; font-size: 0.9rem; }
td { color: #e5eefc; }

.chip {
    display: inline-flex;
    align-items: center;
    padding: 8px 12px;
    border-radius: 999px;
    background: rgba(56,189,248,0.12);
    color: #d8f4ff;
    font-size: 0.9rem;
}

.message-box {
    position: fixed;
    right: 24px;
    bottom: 24px;
    min-width: 260px;
    max-width: 420px;
    padding: 16px 18px;
    border-radius: 16px;
    box-shadow: var(--shadow);
    border: 1px solid var(--line);
    z-index: 10;
}
.message-box.success { background: rgba(34,197,94,0.15); }
.message-box.error { background: rgba(239,68,68,0.15); }
.hidden { display: none; }

@media (max-width: 1100px) {
    .app-shell { grid-template-columns: 1fr; }
    .sidebar { border-right: none; border-bottom: 1px solid var(--line); }
    .hero, .cards-grid, .two-columns, .action-grid, .button-row { grid-template-columns: 1fr; }
    .hero-image { justify-self: start; }
}
CSS

cat > public/assets/js/app.js <<'JS'
const API_BASE = 'api.php';

const state = {
  accounts: [],
  selectedAccountNumber: '1001',
  transactions: []
};

const accountList = document.getElementById('accountList');
const selectedAccountNumber = document.getElementById('selectedAccountNumber');
const selectedAccountName = document.getElementById('selectedAccountName');
const selectedBalance = document.getElementById('selectedBalance');
const totalAccounts = document.getElementById('totalAccounts');
const transactionTableBody = document.getElementById('transactionTableBody');
const historyLabel = document.getElementById('historyLabel');
const messageBox = document.getElementById('messageBox');
const editAccountNumber = document.getElementById('editAccountNumber');
const editAccountName = document.getElementById('editAccountName');

async function request(path = '', options = {}) {
  const response = await fetch(`${API_BASE}${path}`, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  return response.json();
}

function showMessage(message, type = 'success') {
  messageBox.className = `message-box ${type}`;
  messageBox.textContent = message;
  setTimeout(() => {
    messageBox.className = 'message-box hidden';
    messageBox.textContent = '';
  }, 3500);
}

function formatMoney(value) {
  const amount = Number(value || 0);
  return `K ${amount.toFixed(2)}`;
}

function renderAccounts() {
  accountList.innerHTML = '';
  totalAccounts.textContent = state.accounts.length;

  state.accounts.forEach(account => {
    const item = document.createElement('div');
    item.className = `account-item ${account.account_number === state.selectedAccountNumber ? 'active' : ''}`;
    item.innerHTML = `
      <h4>${account.account_name}</h4>
      <p><strong>Account:</strong> ${account.account_number}</p>
      <p><strong>Balance:</strong> ${formatMoney(account.balance)}</p>
    `;
    item.addEventListener('click', () => selectAccount(account.account_number));
    accountList.appendChild(item);
  });
}

function updateSelectedCard() {
  const account = state.accounts.find(acc => acc.account_number === state.selectedAccountNumber);
  if (!account) return;

  selectedAccountNumber.textContent = account.account_number;
  selectedAccountName.textContent = account.account_name;
  selectedBalance.textContent = formatMoney(account.balance);
  editAccountNumber.value = account.account_number;
  editAccountName.value = account.account_name;
  historyLabel.textContent = `Showing account ${account.account_number}`;
}

function renderTransactions() {
  transactionTableBody.innerHTML = '';
  if (!state.transactions.length) {
    transactionTableBody.innerHTML = '<tr><td colspan="5">No transactions found.</td></tr>';
    return;
  }

  state.transactions.forEach(txn => {
    const row = document.createElement('tr');
    row.innerHTML = `
      <td>${txn.id}</td>
      <td>${txn.account_number}</td>
      <td>${txn.type}</td>
      <td>${formatMoney(txn.amount)}</td>
      <td>${txn.created_at}</td>
    `;
    transactionTableBody.appendChild(row);
  });
}

async function loadAccounts() {
  const data = await request('/accounts');
  state.accounts = data.accounts || [];
  if (!state.accounts.find(acc => acc.account_number === state.selectedAccountNumber) && state.accounts.length) {
    state.selectedAccountNumber = state.accounts[0].account_number;
  }
  renderAccounts();
  updateSelectedCard();
}

async function loadTransactions() {
  const data = await request(`/transactions?account_number=${encodeURIComponent(state.selectedAccountNumber)}`);
  state.transactions = data.transactions || [];
  renderTransactions();
}

async function selectAccount(accountNumber) {
  state.selectedAccountNumber = accountNumber;
  renderAccounts();
  updateSelectedCard();
  await loadTransactions();
}

async function refreshAll() {
  await loadAccounts();
  await loadTransactions();
}

document.getElementById('refreshBtn').addEventListener('click', refreshAll);

document.getElementById('createAccountForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const formData = new FormData(event.target);
  const payload = Object.fromEntries(formData.entries());
  payload.balance = Number(payload.balance);

  const result = await request('/accounts', {
    method: 'POST',
    body: JSON.stringify(payload),
  });

  showMessage(result.message, result.success ? 'success' : 'error');
  if (result.success) {
    event.target.reset();
    state.selectedAccountNumber = payload.account_number;
    await refreshAll();
  }
});

document.getElementById('editAccountForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const accountNumber = editAccountNumber.value;
  const result = await request(`/accounts/${encodeURIComponent(accountNumber)}`, {
    method: 'PUT',
    body: JSON.stringify({ account_name: editAccountName.value }),
  });
  showMessage(result.message, result.success ? 'success' : 'error');
  if (result.success) {
    await refreshAll();
  }
});

document.getElementById('deleteAccountBtn').addEventListener('click', async () => {
  const accountNumber = editAccountNumber.value;
  if (!accountNumber) return;
  if (!confirm(`Delete account ${accountNumber}?`)) return;

  const result = await request(`/accounts/${encodeURIComponent(accountNumber)}`, {
    method: 'DELETE',
  });
  showMessage(result.message, result.success ? 'success' : 'error');
  if (result.success) {
    await refreshAll();
  }
});

document.getElementById('depositForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const amount = Number(new FormData(event.target).get('amount'));
  const result = await request('/deposit', {
    method: 'POST',
    body: JSON.stringify({ account_number: state.selectedAccountNumber, amount }),
  });
  showMessage(result.message, result.success ? 'success' : 'error');
  if (result.success) {
    event.target.reset();
    await refreshAll();
  }
});

document.getElementById('withdrawForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const amount = Number(new FormData(event.target).get('amount'));
  const result = await request('/withdraw', {
    method: 'POST',
    body: JSON.stringify({ account_number: state.selectedAccountNumber, amount }),
  });
  showMessage(result.message, result.success ? 'success' : 'error');
  if (result.success) {
    event.target.reset();
    await refreshAll();
  }
});

refreshAll();
JS

cat > public/assets/images/logo.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="96" height="96" viewBox="0 0 96 96" fill="none">
  <rect width="96" height="96" rx="24" fill="url(#g)"/>
  <path d="M20 60L48 22L76 60" stroke="white" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M30 60V72H66V60" stroke="white" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
  <defs>
    <linearGradient id="g" x1="14" y1="14" x2="82" y2="82" gradientUnits="userSpaceOnUse">
      <stop stop-color="#38BDF8"/>
      <stop offset="1" stop-color="#0F172A"/>
    </linearGradient>
  </defs>
</svg>
SVG

cat > public/assets/images/bank-card.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="560" height="360" viewBox="0 0 560 360" fill="none">
  <rect x="20" y="20" width="520" height="320" rx="28" fill="url(#paint0_linear)"/>
  <circle cx="452" cy="108" r="58" fill="rgba(255,255,255,0.14)"/>
  <circle cx="400" cy="108" r="58" fill="rgba(255,255,255,0.12)"/>
  <rect x="58" y="86" width="88" height="62" rx="10" fill="#F8FAFC" fill-opacity="0.85"/>
  <text x="58" y="210" fill="white" font-size="28" font-family="Arial">NOVA BANK</text>
  <text x="58" y="248" fill="#D9F6FF" font-size="22" font-family="Arial">**** **** **** 1001</text>
  <text x="58" y="290" fill="#D9F6FF" font-size="18" font-family="Arial">SECURE ONLINE ACCESS</text>
  <defs>
    <linearGradient id="paint0_linear" x1="46" y1="38" x2="506" y2="332" gradientUnits="userSpaceOnUse">
      <stop stop-color="#0EA5E9"/>
      <stop offset="0.5" stop-color="#1E293B"/>
      <stop offset="1" stop-color="#020617"/>
    </linearGradient>
  </defs>
</svg>
SVG

cat > public/assets/images/avatar.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="96" height="96" viewBox="0 0 96 96" fill="none">
  <rect width="96" height="96" rx="48" fill="#1E293B"/>
  <circle cx="48" cy="36" r="18" fill="#E2E8F0"/>
  <path d="M22 78C26 63 36 56 48 56C60 56 70 63 74 78" fill="#E2E8F0"/>
</svg>
SVG

chmod +x /mnt/data/bank-app/create_project.sh
