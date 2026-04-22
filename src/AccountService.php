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
