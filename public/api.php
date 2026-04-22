<?php
require_once __DIR__ . '/../src/DataStore.php';
require_once __DIR__ . '/../src/AccountService.php';
require_once __DIR__ . '/../src/TransactionService.php';

header('Content-Type: application/json');

$store = new DataStore(__DIR__ . '/../storage/bank.json');
$accountService = new AccountService($store);
$transactionService = new TransactionService($store);

$method = $_SERVER['REQUEST_METHOD'];
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$path = preg_replace('#^/api\.php#', '', $uri);
$path = $path === '' ? '/' : $path;
$input = json_decode(file_get_contents('php://input'), true) ?? [];

function respond(array $data, int $status = 200): void
{
    http_response_code($status);
    echo json_encode($data, JSON_PRETTY_PRINT);
    exit;
}

if ($method === 'GET' && $path === '/') {
    respond(['success' => true, 'message' => 'ATM Banking API is running']);
}

if ($method === 'GET' && $path === '/accounts') {
    respond(['success' => true, 'accounts' => $accountService->getAllAccounts()]);
}

if ($method === 'POST' && $path === '/accounts') {
    $result = $accountService->createAccount(
        (string)($input['account_number'] ?? ''),
        (string)($input['account_name'] ?? ''),
        (float)($input['balance'] ?? 0)
    );
    respond($result, $result['success'] ? 201 : 400);
}

if ($method === 'PUT' && preg_match('#^/accounts/([^/]+)$#', $path, $matches)) {
    $result = $accountService->updateAccount($matches[1], (string)($input['account_name'] ?? ''));
    respond($result, $result['success'] ? 200 : 400);
}

if ($method === 'DELETE' && preg_match('#^/accounts/([^/]+)$#', $path, $matches)) {
    $result = $accountService->deleteAccount($matches[1]);
    respond($result, $result['success'] ? 200 : 400);
}

if ($method === 'POST' && $path === '/balance') {
    $account = $accountService->getAccount((string)($input['account_number'] ?? ''));
    if (!$account) {
        respond(['success' => false, 'message' => 'Account not found.'], 404);
    }
    respond(['success' => true, 'account' => $account]);
}

if ($method === 'POST' && $path === '/deposit') {
    $result = $transactionService->deposit((string)($input['account_number'] ?? ''), (float)($input['amount'] ?? 0));
    respond($result, $result['success'] ? 200 : 400);
}

if ($method === 'POST' && $path === '/withdraw') {
    $result = $transactionService->withdraw((string)($input['account_number'] ?? ''), (float)($input['amount'] ?? 0));
    respond($result, $result['success'] ? 200 : 400);
}

if ($method === 'GET' && $path === '/transactions') {
    $accountNumber = $_GET['account_number'] ?? null;
    respond(['success' => true, 'transactions' => $transactionService->getTransactions($accountNumber)]);
}

respond(['success' => false, 'message' => 'Route not found.'], 404);
