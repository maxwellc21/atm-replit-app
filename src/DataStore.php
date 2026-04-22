<?php

class DataStore
{
    private string $file;

    public function __construct(string $file)
    {
        $this->file = $file;
        if (!file_exists($this->file)) {
            $this->initialize();
        }
    }

    private function initialize(): void
    {
        $default = [
            'accounts' => [
                [
                    'account_number' => '1001',
                    'account_name' => 'Maxie Cletus',
                    'balance' => 500.00,
                ],
            ],
            'transactions' => [
                [
                    'id' => 1,
                    'account_number' => '1001',
                    'type' => 'opening_balance',
                    'amount' => 500.00,
                    'created_at' => date('Y-m-d H:i:s'),
                ],
            ],
        ];

        $this->write($default);
    }

    public function read(): array
    {
        $content = file_get_contents($this->file);
        $data = json_decode($content ?: '{}', true);
        return is_array($data) ? $data : ['accounts' => [], 'transactions' => []];
    }

    public function write(array $data): void
    {
        $dir = dirname($this->file);
        if (!is_dir($dir)) {
            mkdir($dir, 0777, true);
        }

        $fp = fopen($this->file, 'c+');
        if ($fp === false) {
            throw new RuntimeException('Unable to open storage file.');
        }

        flock($fp, LOCK_EX);
        ftruncate($fp, 0);
        fwrite($fp, json_encode($data, JSON_PRETTY_PRINT));
        fflush($fp);
        flock($fp, LOCK_UN);
        fclose($fp);
    }
}
