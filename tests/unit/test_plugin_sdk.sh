#!/usr/bin/env bash
framework_require plugin_sdk || true
test_plugin_create() {
    # TODO: implement test for plugin_create
    assert_equals 0 0
    return 0
}
test_register "test_plugin_create"
test_plugin_validate() {
    # TODO: implement test for plugin_validate
    assert_equals 0 0
    return 0
}
test_register "test_plugin_validate"
test_plugin_build() {
    # TODO: implement test for plugin_build
    assert_equals 0 0
    return 0
}
test_register "test_plugin_build"
