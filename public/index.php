<?php

declare(strict_types=1);

require_once __DIR__ . '/../src/Database.php';
require_once __DIR__ . '/../src/Response.php';
require_once __DIR__ . '/../src/AccountModel.php';
require_once __DIR__ . '/../src/TransactionModel.php';
require_once __DIR__ . '/../src/AccountService.php';
require_once __DIR__ . '/../src/TransactionService.php';
require_once __DIR__ . '/../src/ATMController.php';

$database = new Database();
$accountModel = new AccountModel($database);
$transactionModel = new TransactionModel($database);
$accountService = new AccountService($accountModel, $transactionModel);
$transactionService = new TransactionService($accountModel, $transactionModel);
$controller = new ATMController($accountService, $transactionService);

$method = $_SERVER['REQUEST_METHOD'];
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?: '/';
$input = json_decode(file_get_contents('php://input'), true);
$input = is_array($input) ? $input : [];
$query = $_GET;

try {
    if ($method === 'GET' && $path === '/') {
        Response::json($controller->health());
        exit;
    }
    if ($method === 'POST' && $path === '/balance') {
        Response::json($controller->balance($input));
        exit;
    }
    if ($method === 'POST' && $path === '/deposit') {
        Response::json($controller->deposit($input));
        exit;
    }
    if ($method === 'POST' && $path === '/withdraw') {
        Response::json($controller->withdraw($input));
        exit;
    }
    if ($method === 'GET' && $path === '/transactions') {
        Response::json($controller->transactions($query));
        exit;
    }
    Response::json(['success' => false, 'message' => 'Route not found'], 404);
} catch (Throwable $e) {
    Response::json(['success' => false, 'message' => 'Server error', 'error' => $e->getMessage()], 500);
}
