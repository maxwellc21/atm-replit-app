<?php

declare(strict_types=1);

class ATMController
{
    public function __construct(private AccountService $accountService, private TransactionService $transactionService) {}

    public function health(): array
    {
        return ['success' => true, 'message' => 'ATM API is running'];
    }

    public function balance(array $data): array
    {
        return $this->accountService->getBalance((string)($data['account_number'] ?? ''));
    }

    public function deposit(array $data): array
    {
        return $this->transactionService->deposit((string)($data['account_number'] ?? ''), (float)($data['amount'] ?? 0));
    }

    public function withdraw(array $data): array
    {
        return $this->transactionService->withdraw((string)($data['account_number'] ?? ''), (float)($data['amount'] ?? 0));
    }

    public function transactions(array $query): array
    {
        return $this->accountService->getTransactions((string)($query['account_number'] ?? ''));
    }
}
