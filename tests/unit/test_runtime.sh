#!/usr/bin/env bash
framework_require runtime || true
test_runtime_init() {
    # TODO: implement test for runtime_init
    assert_equals 0 0
    return 0
}
test_register "test_runtime_init"
test_runtime_shutdown() {
    # TODO: implement test for runtime_shutdown
    assert_equals 0 0
    return 0
}
test_register "test_runtime_shutdown"
test_runtime_reset() {
    # TODO: implement test for runtime_reset
    assert_equals 0 0
    return 0
}
test_register "test_runtime_reset"
