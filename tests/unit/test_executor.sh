#!/usr/bin/env bash
framework_require executor || true
test_plugin_execute() {
    # TODO: implement test for plugin_execute
    assert_equals 0 0
    return 0
}
test_register "test_plugin_execute"
