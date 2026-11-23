CREATE TABLE core_banking.customers (
    customer_id        bigint       PRIMARY KEY,
    first_name         text         NOT NULL,
    last_name          text         NOT NULL,
    date_of_birth      date         NOT NULL,
    registration_date  date         NOT NULL,
    province           text         NOT NULL,
    city               text         NOT NULL,
    customer_status    text         NOT NULL,
        CHECK (customer_status IN ('active', 'dormant', 'closed')),
    customer_segment   text         NOT NULL,
        CHECK (customer_segment IN ('youth', 'standard', 'premier', 'business')),
    created_at         timestamptz  NOT NULL DEFAULT now(),
    updated_at         timestamptz  NOT NULL DEFAULT now(),
    CHECK (date_of_birth < registration_date)
);

CREATE TABLE core_banking.merchants (
    merchant_id        bigint       PRIMARY KEY,
    merchant_name      text         NOT NULL,
    merchant_category  text         NOT NULL,
        CHECK (merchant_category IN ('groceries', 'fuel', 'restaurants', 'retail', 'utilities', 'transport', 'entertainment', 'health', 'online')),
    province           text         NOT NULL,
    city               text         NOT NULL,
    merchant_status    text         NOT NULL,
        CHECK (merchant_status IN ('active', 'dormant', 'closed')),
    created_at         timestamptz  NOT NULL DEFAULT now(),
    updated_at         timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE core_banking.accounts (
    account_id         bigint       PRIMARY KEY,
    customer_id        bigint       NOT NULL REFERENCES core_banking.customers (customer_id),
    account_type       text         NOT NULL,
        CHECK (account_type IN ('cheque', 'savings', 'credit_card')),
    account_opening_date    date         NOT NULL,
    account_status     text         NOT NULL,
        CHECK (account_status IN ('active', 'dormant', 'closed')),
    account_balance    numeric(18,2)    NOT NULL,
        CHECK (account_type <> 'savings' OR account_balance >= 0),
    currency           text         NOT NULL DEFAULT 'ZAR' CHECK (currency ~ '^[A-Z]{3}$'),
    created_at         timestamptz  NOT NULL DEFAULT now(),
    updated_at         timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE core_banking.loans (
    loan_id            bigint       PRIMARY KEY,
    customer_id        bigint       NOT NULL REFERENCES core_banking.customers (customer_id),
    principal_amount   numeric(18,2)  NOT NULL,
        CHECK (principal_amount > 0),
    -- annual rate as a percentage, e.g. 11.75
    interest_rate      numeric(5,2) NOT NULL,
        CHECK (interest_rate >= 0),
    loan_initiation_date    date         NOT NULL,
    loan_term_months   int          NOT NULL,
        CHECK (loan_term_months > 0),
    outstanding_balance     numeric(18,2)  NOT NULL,
        CHECK (outstanding_balance >= 0),
    repayment_status   text         NOT NULL,
        CHECK (repayment_status IN ('current', 'in_arrears', 'defaulted', 'settled')),
    created_at         timestamptz  NOT NULL DEFAULT now(),
    updated_at         timestamptz  NOT NULL DEFAULT now()
);

CREATE TABLE core_banking.transactions (
    transaction_id     bigint       PRIMARY KEY,
    account_id         bigint       NOT NULL REFERENCES core_banking.accounts (account_id),
    merchant_id        bigint       REFERENCES core_banking.merchants (merchant_id),
    transaction_timestamp   timestamptz  NOT NULL,
    transaction_amount      numeric(18,2)  NOT NULL,
        CHECK (transaction_amount <> 0),
    transaction_type        text         NOT NULL,
        CHECK (transaction_type IN ('purchase', 'withdrawal', 'deposit', 'transfer', 'fee', 'interest')),
    transaction_status      text         NOT NULL,
        CHECK (transaction_status IN ('pending', 'completed', 'failed', 'reversed')),
    transaction_channel     text         NOT NULL,
        CHECK (transaction_channel IN ('card', 'eft', 'atm', 'app', 'branch')),
    transaction_location    text         NOT NULL,
    created_at         timestamptz  NOT NULL DEFAULT now(),
    updated_at         timestamptz  NOT NULL DEFAULT now()
);