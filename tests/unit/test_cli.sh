#!/usr/bin/env bash
framework_require cli || true
test_cli_main() {
    # TODO: implement test for cli_main
    assert_equals 0 0
    return 0
}
test_register "test_cli_main"
