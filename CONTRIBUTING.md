# Contributing to sqlfmt

Thank you for considering contributing to sqlfmt! We welcome bug reports, feature requests, and pull requests.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Help](#getting-help)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Features](#suggesting-features)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Code Style](#code-style)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [License](#license)

## Code of Conduct

This project is governed by a simple principle: **be respectful and constructive**. Harassment, trolling, and other unprofessional behavior will not be tolerated.

## Getting Help

If you have a question about using sqlfmt, open a [GitHub Discussion](https://github.com/ales/sqlfmt/discussions) rather than an issue.

## Reporting Bugs

Before reporting a bug, please:

1. Check the [existing issues](https://github.com/ales/sqlfmt/issues) to see if it has already been reported.
2. Try to reproduce the bug with the latest version.
3. Include a minimal SQL example that triggers the bug — both the input and the unexpected output.

When opening a bug report, include:

- Your OS and Rust version (`rustc --version`)
- The version of sqlfmt (if installed)
- The exact SQL input that causes the issue
- What you expected the formatted output to look like
- What the actual formatted output looks like

## Suggesting Features

Feature requests are welcome! When suggesting a feature:

- Explain the use case and why it would be useful
- If the feature relates to SQL formatting, provide examples of input and desired output
- Indicate if you'd be willing to help implement it

## Development Setup

### Prerequisites

- [Rust](https://rustup.rs/) (edition 2021, latest stable)

### Getting Started

```bash
# Clone your fork
git clone https://github.com/your-username/sqlfmt.git
cd sqlfmt

# Build the project
cargo build

# Run tests
cargo test

# Run the binary
echo "SELECT * FROM users;" | cargo run
```

## Making Changes

1. Fork the repository on GitHub.
2. Create a branch for your changes (`git checkout -b my-feature`).
3. Make your changes, keeping commits small and focused.
4. Write or update tests to cover your changes.
5. Run the full test suite (`cargo test`).
6. Push your branch and open a pull request.

## Code Style

- Follow standard Rust formatting. Run `cargo fmt` before committing.
- Address all `cargo clippy` warnings.
- Keep functions focused and small. If a function is growing too long, consider splitting it.
- Use descriptive names for variables and functions.
- Add comments for non-obvious logic, but prefer self-documenting code.
- When adding a new SQL statement type, follow the existing pattern in the codebase:
  - Add a detection clause in the statement classifier
  - Create a dedicated formatter function or module
  - Add tests for various edge cases
  - Update the README's Supported statement types list

## Testing

### Running tests

```bash
# Run the full test suite
cargo test
```

### Golden file tests

The project uses golden file (snapshot) integration tests. Each test case consists of a pair of files in [`tests/data/`](tests/data):

- **`<name>.input.sql`** — the raw SQL input to format
- **`<name>.golden.sql`** — the expected formatted output

The test binary pipes the input through `sqlfmt` via stdin and asserts that stdout matches the golden file exactly.

### Adding a new test case

1. Create `<name>.input.sql` and `<name>.golden.sql` in `tests/data/`
2. To generate the golden file, run:
   ```bash
   cat tests/data/<name>.input.sql | cargo run > tests/data/<name>.golden.sql
   ```
3. Add a test function in [`tests/integration_test.rs`](tests/integration_test.rs):
   ```rust
   #[test]
   fn test_<name>() {
       run_golden_test("<name>");
   }
   ```
4. Run `cargo test` to verify

### What to cover

When adding features or fixing bugs, include test cases that cover:

- Normal/expected inputs
- Edge cases (empty input, missing semicolon, subqueries)
- Comment preservation (`--`, `/* */`, `#`)
- Multiple statements (same type and mixed types)

## Pull Request Process

1. Ensure all tests pass and there are no `cargo clippy` warnings.
2. Update the README if your changes add, remove, or change any user-facing behavior (e.g., new statement type support, flags, etc.).
3. Reference any related issues in your PR description (e.g., "Closes #12").
4. A maintainer will review your PR. Address any feedback with additional commits.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
