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
