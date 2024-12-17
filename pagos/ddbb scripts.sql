BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE users CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE users (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    username VARCHAR2(50) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    role VARCHAR2(20) NOT NULL CHECK (role IN ('ADMIN', 'USER')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE payment_transactions CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE payment_transactions (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    user_id NUMBER NOT NULL,
    payment_gateway VARCHAR2(50) NOT NULL,
    amount NUMBER(10, 2) NOT NULL,
    currency VARCHAR2(10) NOT NULL,
    status VARCHAR2(20) NOT NULL CHECK (status IN ('COMPLETED', 'PENDING', 'FAILED', 'REFUNDED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE refunds CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE refunds (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    transaction_id NUMBER NOT NULL,
    amount NUMBER(10, 2) NOT NULL,
    reason VARCHAR2(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_transaction_id FOREIGN KEY (transaction_id) REFERENCES payment_transactions (id) ON DELETE CASCADE
);

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE chargebacks CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE chargebacks (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    transaction_id NUMBER NOT NULL,
    amount NUMBER(10, 2) NOT NULL,
    reason VARCHAR2(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    CONSTRAINT fk_chargeback_transaction_id FOREIGN KEY (transaction_id) REFERENCES payment_transactions (id) ON DELETE CASCADE
);

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE payment_gateway_credentials CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE payment_gateway_credentials (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    gateway_name VARCHAR2(50) UNIQUE NOT NULL,
    api_key VARCHAR2(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE currency_rates CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE currency_rates (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    from_currency VARCHAR2(10) NOT NULL,
    to_currency VARCHAR2(10) NOT NULL,
    rate NUMBER(10, 6) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_currency_pair UNIQUE (from_currency, to_currency)
);

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE transaction_events CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

CREATE TABLE transaction_events (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    transaction_id NUMBER NOT NULL,
    event_type VARCHAR2(50) NOT NULL,
    event_data CLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_event_transaction_id FOREIGN KEY (transaction_id) REFERENCES payment_transactions (id) ON DELETE CASCADE
);

--Data
INSERT INTO users (id, username, password, email, role, created_at) VALUES
(1, 'admin', 'hashed_password', 'admin@example.com', 'ADMIN', SYSDATE);
INSERT INTO users (id, username, password, email, role, created_at) VALUES
(2, 'john_doe', 'hashed_password', 'john.doe@example.com', 'USER', SYSDATE);
INSERT INTO users (id, username, password, email, role, created_at) VALUES
(3, 'jane_doe', 'hashed_password', 'jane.doe@example.com', 'USER', SYSDATE);

INSERT INTO payment_transactions (id, user_id, payment_gateway, amount, currency, status, created_at, updated_at) VALUES
(1, 2, 'PayPal', 100.50, 'USD', 'COMPLETED', SYSDATE - 10, SYSDATE - 10);
INSERT INTO payment_transactions (id, user_id, payment_gateway, amount, currency, status, created_at, updated_at) VALUES
(2, 2, 'Stripe', 200.00, 'EUR', 'PENDING', SYSDATE - 5, NULL);
INSERT INTO payment_transactions (id, user_id, payment_gateway, amount, currency, status, created_at, updated_at) VALUES
(3, 3, 'PayPal', 50.00, 'USD', 'REFUNDED', SYSDATE - 15, SYSDATE - 10);

INSERT INTO refunds (id, transaction_id, amount, reason, created_at, updated_at) VALUES
(1, 3, 50.00, 'Customer request', SYSDATE - 10, SYSDATE - 9);

INSERT INTO chargebacks (id, transaction_id, amount, reason, created_at, updated_at) VALUES
(1, 3, 50.00, 'Dispute by cardholder', SYSDATE - 8, SYSDATE - 7);

INSERT INTO payment_gateway_credentials (id, gateway_name, api_key, created_at, updated_at) VALUES
(1, 'PayPal', 'paypal_api_key_example', SYSDATE, NULL);
INSERT INTO payment_gateway_credentials (id, gateway_name, api_key, created_at, updated_at) VALUES
(2, 'Stripe', 'stripe_api_key_example', SYSDATE, NULL);

INSERT INTO currency_rates (id, from_currency, to_currency, rate, updated_at) VALUES
(1, 'USD', 'EUR', 0.92, SYSDATE);
INSERT INTO currency_rates (id, from_currency, to_currency, rate, updated_at) VALUES
(2, 'EUR', 'USD', 1.09, SYSDATE);
INSERT INTO currency_rates (id, from_currency, to_currency, rate, updated_at) VALUES
(3, 'USD', 'GBP', 0.78, SYSDATE);

INSERT INTO transaction_events (id, transaction_id, event_type, event_data, created_at) VALUES
(1, 1, 'PAYMENT_SUCCESS', '{ "amount": 100.50, "currency": "USD" }', SYSDATE - 10);
INSERT INTO transaction_events (id, transaction_id, event_type, event_data, created_at) VALUES
(2, 2, 'PAYMENT_PENDING', '{ "amount": 200.00, "currency": "EUR" }', SYSDATE - 5);
INSERT INTO transaction_events (id, transaction_id, event_type, event_data, created_at) VALUES
(3, 3, 'REFUND_PROCESSED', '{ "amount": 50.00 }', SYSDATE - 9);

select * from payment_gateway_keys;
select * from transaction_events;
