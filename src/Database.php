<?php

declare(strict_types=1);

class Database
{
    private string $databaseFile;

    public function __construct()
    {
        $storageDir = __DIR__ . '/../storage';
        $this->databaseFile = $storageDir . '/atm.json';

        if (!is_dir($storageDir)) {
            mkdir($storageDir, 0777, true);
        }

        if (!file_exists($this->databaseFile)) {
            $this->seed();
        }
    }

    public function read(): array
    {
        $raw = file_get_contents($this->databaseFile);
        $data = json_decode($raw ?: '{}', true);

        if (!is_array($data)) {
            $this->seed();
            $data = json_decode((string) file_get_contents($this->databaseFile), true);
        }

        return $data;
    }

    public function write(array $data): void
    {
        file_put_contents($this->databaseFile, json_encode($data, JSON_PRETTY_PRINT));
    }

    private function seed(): void
    {
        $this->write([
            'next_account_id' => 2,
            'next_transaction_id' => 1,
            'accounts' => [[
                'id' => 1,
                'account_number' => '1001',
                'account_name' => 'Maxie Cletus',
                'balance' => 500.00,
            ]],
            'transactions' => [],
        ]);
    }
}
