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
