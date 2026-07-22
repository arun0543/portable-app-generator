#!/usr/bin/env bash
framework_require lock || true
test_lock_exists() {
    # TODO: implement test for lock_exists
    assert_equals 0 0
    return 0
}
test_register "test_lock_exists"
test_lock_acquire() {
    # TODO: implement test for lock_acquire
    assert_equals 0 0
    return 0
}
test_register "test_lock_acquire"
test_lock_release() {
    # TODO: implement test for lock_release
    assert_equals 0 0
    return 0
}
test_register "test_lock_release"
