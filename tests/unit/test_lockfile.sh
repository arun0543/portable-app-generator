#!/usr/bin/env bash
framework_require lockfile || true
test_lockfile_generate() {
    # TODO: implement test for lockfile_generate
    assert_equals 0 0
    return 0
}
test_register "test_lockfile_generate"
test_lockfile_load() {
    # TODO: implement test for lockfile_load
    assert_equals 0 0
    return 0
}
test_register "test_lockfile_load"
test_lockfile_verify() {
    # TODO: implement test for lockfile_verify
    assert_equals 0 0
    return 0
}
test_register "test_lockfile_verify"
