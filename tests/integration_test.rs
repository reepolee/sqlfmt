use std::fs;
use std::io::Write;
use std::path::Path;
use std::process::{Command, Stdio};

const DATA_DIR: &str = "tests/data";

#[test]
fn test_select_join() {
    run_golden_test("select_join");
}

#[test]
fn test_create_table() {
    run_golden_test("create_table");
}

#[test]
fn test_create_view() {
    run_golden_test("create_view");
}

#[test]
fn test_insert_short() {
    run_golden_test("insert_short");
}

#[test]
fn test_insert_long() {
    run_golden_test("insert_long");
}

#[test]
fn test_create_index() {
    run_golden_test("create_index");
}

#[test]
fn test_drop() {
    run_golden_test("drop");
}

#[test]
fn test_comments() {
    run_golden_test("comments");
}

#[test]
fn test_mixed() {
    run_golden_test("mixed");
}

#[test]
fn test_empty() {
    run_golden_test("empty");
}

#[test]
fn test_no_semicolon() {
    run_golden_test("no_semicolon");
}

#[test]
fn test_subquery() {
    run_golden_test("subquery");
}

#[test]
fn test_multi_create_table() {
    run_golden_test("multi_create_table");
}

#[test]
fn test_multi_select() {
    run_golden_test("multi_select");
}

fn run_golden_test(name: &str) {
    let input_path = Path::new(DATA_DIR).join(format!("{}.input.sql", name));
    let golden_path = Path::new(DATA_DIR).join(format!("{}.golden.sql", name));

    let input = fs::read_to_string(&input_path)
        .unwrap_or_else(|e| panic!("Failed to read input file {:?}: {}", input_path, e));

    let expected = fs::read_to_string(&golden_path)
        .unwrap_or_else(|e| panic!("Failed to read golden file {:?}: {}", golden_path, e));

    let mut child = Command::new(env!("CARGO_BIN_EXE_sqlfmt"))
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .unwrap_or_else(|e| panic!("Failed to spawn sqlfmt process: {}", e));

    child
        .stdin
        .take()
        .expect("Failed to take stdin")
        .write_all(input.as_bytes())
        .unwrap_or_else(|e| panic!("Failed to write to stdin: {}", e));

    let output = child
        .wait_with_output()
        .expect("Failed to wait for sqlfmt process");

    assert!(
        output.status.success(),
        "sqlfmt exited with {}: {}",
        output.status,
        String::from_utf8_lossy(&output.stderr)
    );

    let actual = String::from_utf8(output.stdout)
        .expect("Output is not valid UTF-8");

    assert_eq!(
        actual, expected,
        "\n❌ Test '{}' failed\n{}\nExpected:\n{}───────\nActual:\n{}───────\n",
        name,
        fmt_diff(&expected, &actual),
        expected,
        actual,
    );
}

fn fmt_diff(expected: &str, actual: &str) -> String {
    let expected_lines: Vec<&str> = expected.lines().collect();
    let actual_lines: Vec<&str> = actual.lines().collect();

    let max = expected_lines.len().max(actual_lines.len());
    let mut diff = String::from("Diff:\n");

    for i in 0..max {
        let e = expected_lines.get(i).copied().unwrap_or("<EOF>");
        let a = actual_lines.get(i).copied().unwrap_or("<EOF>");
        if e != a {
            diff.push_str(&format!("  Line {}:\n    - {e:?}\n    + {a:?}\n", i + 1));
        }
    }
    diff
}
