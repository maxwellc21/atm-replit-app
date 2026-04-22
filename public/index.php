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
