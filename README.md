# PHP ATM App for GitHub and Replit

A simple ATM microservice-style backend built with PHP and JSON file storage so it runs easily on Replit without extra database setup.

## Run on Replit
1. Upload all files to a PHP Repl.
2. Click **Run**.
3. Replit starts the app on port `3000`.

## Default account
- account number: `1001`
- name: `Maxie Cletus`
- balance: `500.00`

## Endpoints
- `GET /`
- `POST /balance`
- `POST /deposit`
- `POST /withdraw`
- `GET /transactions?account_number=1001`
