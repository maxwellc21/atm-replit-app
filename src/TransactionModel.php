<?php

declare(strict_types=1);

class TransactionModel
{
    public function __construct(private Database $database) {}

    public function create(int $accountId, string $type, float $amount): bool
    {
        $data = $this->database->read();
        $data['transactions'][] = [
            'id' => $data['next_transaction_id'],
            'account_id' => $accountId,
            'type' => $type,
            'amount' => round($amount, 2),
            'created_at' => date('Y-m-d H:i:s'),
        ];
        $data['next_transaction_id']++;
        $this->database->write($data);
        return true;
    }

    public function getByAccountId(int $accountId): array
    {
        $data = $this->database->read();
        $transactions = array_values(array_filter($data['transactions'], fn(array $t): bool => (int)$t['account_id'] === $accountId));
        usort($transactions, fn(array $a, array $b): int => $b['id'] <=> $a['id']);
        return $transactions;
    }
}
