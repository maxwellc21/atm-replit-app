<?php

declare(strict_types=1);

class AccountModel
{
    public function __construct(private Database $database) {}

    public function findByAccountNumber(string $accountNumber): array|false
    {
        $data = $this->database->read();
        foreach ($data['accounts'] as $account) {
            if ($account['account_number'] === $accountNumber) {
                return $account;
            }
        }
        return false;
    }

    public function updateBalance(int $accountId, float $newBalance): bool
    {
        $data = $this->database->read();
        foreach ($data['accounts'] as &$account) {
            if ((int)$account['id'] === $accountId) {
                $account['balance'] = round($newBalance, 2);
                $this->database->write($data);
                return true;
            }
        }
        return false;
    }
}
