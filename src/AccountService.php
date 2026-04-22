<?php

declare(strict_types=1);

class AccountService
{
    public function __construct(private AccountModel $accountModel, private TransactionModel $transactionModel) {}

    public function getBalance(string $accountNumber): array
    {
        $account = $this->accountModel->findByAccountNumber(trim($accountNumber));
        if (!$account) {
            return ['success' => false, 'message' => 'Account not found'];
        }
        $this->transactionModel->create((int)$account['id'], 'balance', 0.00);
        return [
            'success' => true,
            'account_number' => $account['account_number'],
            'account_name' => $account['account_name'],
            'balance' => (float)$account['balance'],
        ];
    }

    public function getTransactions(string $accountNumber): array
    {
        $account = $this->accountModel->findByAccountNumber(trim($accountNumber));
        if (!$account) {
            return ['success' => false, 'message' => 'Account not found'];
        }
        return [
            'success' => true,
            'account_number' => $account['account_number'],
            'account_name' => $account['account_name'],
            'transactions' => $this->transactionModel->getByAccountId((int)$account['id']),
        ];
    }
}
