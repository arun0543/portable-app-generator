#!/usr/bin/env bash
framework_require loader || true
test_framework_loaded() {
    # TODO: implement test for framework_loaded
    assert_equals 0 0
    return 0
}
test_register "test_framework_loaded"
test_framework_require() {
    # TODO: implement test for framework_require
    assert_equals 0 0
    return 0
}
test_register "test_framework_require"
test_framework_load() {
    # TODO: implement test for framework_load
    assert_equals 0 0
    return 0
}
test_register "test_framework_load"
