CREATE INDEX accounts_customer_id_idx ON core_banking.accounts (customer_id);
CREATE INDEX loans_customer_id_idx ON core_banking.loans (customer_id);
CREATE INDEX transactions_account_id_idx ON core_banking.transactions (account_id);
CREATE INDEX transactions_merchant_id_idx ON core_banking.transactions (account_id);