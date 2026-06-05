# sqlfmt

A MySQL SQL formatter written in Rust. Reads SQL from stdin or a file, and writes back consistently formatted SQL.

## Features

- **Keyword uppercasing** — SQL keywords (`SELECT`, `FROM`, `WHERE`, `CREATE`, `INSERT`, etc.) are uppercased
- **CREATE TABLE formatting** — column names and types aligned, constraints on separate lines
- **CREATE VIEW formatting** — select columns on separate lines with `AS` alignment, JOINs indented
- **INSERT formatting** — multi-line value tuples when they exceed 100 characters
- **SELECT formatting** — aligned columns, organized FROM/JOIN/WHERE clauses
- **Comment preservation** — `--`, `/* */`, and `#` comments are preserved and positioned correctly
- **In-place file editing** — pass a file path to format it in place, or use stdin/stdout

## Installation

### macOS / Linux

```bash
git clone <repo-url>
cd sqlfmt
chmod +x build.sh install.sh
./build.sh
./install.sh
source ~/.bashrc  # or restart terminal
```

The install script copies the binary to `~/bin/` and adds it to your PATH.

### Windows (PowerShell)

```powershell
.\build.ps1
.\install.ps1
# Restart terminal
```

### Manual

```bash
cargo build --release
cp ./target/release/sqlfmt /usr/local/bin/
```

## Usage

### Format a file (in-place)

```bash
sqlfmt path/to/file.sql
```

### Format from stdin

```bash
cat query.sql | sqlfmt
```

### Pipe directly

```bash
echo "SELECT * FROM users WHERE active = 1;" | sqlfmt
```

## Examples

### SELECT with JOIN

**Input:**
```sql
select u.name, o.total from users u inner join orders o on u.id = o.user_id where o.total > 100;
```

**Output:**
```sql
SELECT u.name, o.total
FROM users u
    INNER JOIN orders o
        ON u.id = o.user_id
WHERE o.total > 100;
```

### CREATE TABLE

**Input:**
```sql
create table users (id bigint unsigned not null auto_increment primary key, name varchar(255) not null, email varchar(255) not null unique, created_at timestamp default current_timestamp);
```

**Output:**
```sql
CREATE TABLE users (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(255)    NOT NULL,
    email       VARCHAR(255)    NOT NULL UNIQUE,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);
```

### With comments preserved

**Input:**
```sql
SELECT * FROM users; -- get all users
```

**Output:**
```sql
SELECT *
FROM users; -- get all users
```

## Supported statement types

- `SELECT` (generic formatting)
- `CREATE TABLE` (aligned column definitions, constraints)
- `CREATE VIEW` (aligned SELECT columns with AS, indented JOINs)
- `CREATE INDEX` (uppercased, compact)
- `INSERT` (multi-line values for long tuples)
- `DROP` (uppercased, compact)

## How it works

1. **Tokenization** — raw SQL is split into tokens (keywords, identifiers, operators, comments, strings)
2. **Statement splitting** — tokens are split at semicolons into individual statements
3. **Type detection** — each statement is classified (CREATE TABLE, SELECT, INSERT, etc.)
4. **Formatting** — each statement type has a dedicated formatter that produces well-structured output

## Building from source

Requires [Rust](https://rustup.rs/) (edition 2021).

```bash
cargo build --release
# Binary at ./target/release/sqlfmt
```
