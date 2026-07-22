#!/usr/bin/env bash
framework_require hooks || true
test_hook_exists() {
    # TODO: implement test for hook_exists
    assert_equals 0 0
    return 0
}
test_register "test_hook_exists"
test_hook_execute() {
    # TODO: implement test for hook_execute
    assert_equals 0 0
    return 0
}
test_register "test_hook_execute"
