<?php

declare(strict_types=1);

class TransactionService
{
    public function __construct(private AccountModel $accountModel, private TransactionModel $transactionModel) {}

    public function deposit(string $accountNumber, float $amount): array
    {
        $account = $this->accountModel->findByAccountNumber(trim($accountNumber));
        if (!$account) {
            return ['success' => false, 'message' => 'Account not found'];
        }
        if ($amount <= 0) {
            return ['success' => false, 'message' => 'Deposit amount must be greater than 0'];
        }
        $newBalance = (float)$account['balance'] + $amount;
        $this->accountModel->updateBalance((int)$account['id'], $newBalance);
        $this->transactionModel->create((int)$account['id'], 'deposit', $amount);
        return ['success' => true, 'message' => 'Deposit successful', 'account_number' => $account['account_number'], 'new_balance' => round($newBalance, 2)];
    }

    public function withdraw(string $accountNumber, float $amount): array
    {
        $account = $this->accountModel->findByAccountNumber(trim($accountNumber));
        if (!$account) {
            return ['success' => false, 'message' => 'Account not found'];
        }
        if ($amount <= 0) {
            return ['success' => false, 'message' => 'Withdrawal amount must be greater than 0'];
        }
        if ((float)$account['balance'] < $amount) {
            return ['success' => false, 'message' => 'Insufficient funds'];
        }
        $newBalance = (float)$account['balance'] - $amount;
        $this->accountModel->updateBalance((int)$account['id'], $newBalance);
        $this->transactionModel->create((int)$account['id'], 'withdraw', $amount);
        return ['success' => true, 'message' => 'Withdrawal successful', 'account_number' => $account['account_number'], 'new_balance' => round($newBalance, 2)];
    }
}
