CREATE TABLE users (
    id         bigint unsigned NOT NULL auto_increment PRIMARY KEY,
    name       varchar(255)    NOT NULL,
    email      varchar(255)    NOT NULL UNIQUE,
    created_at timestamp       DEFAULT CURRENT_TIMESTAMP
);
