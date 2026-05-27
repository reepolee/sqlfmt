cargo build --release 
# binary at ./target/release/sqlfmt
# optionally:
Copy-Item ./target/release/sqlfmt.exe .
# Remove build artifacts (binary was copied above)
Remove-Item ./target -Recurse -Force

