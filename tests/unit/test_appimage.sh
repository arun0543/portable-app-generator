#!/usr/bin/env bash
framework_require appimage || true
test_appimage_create() {
    # TODO: implement test for appimage_create
    assert_equals 0 0
    return 0
}
test_register "test_appimage_create"
test_appimage_validate() {
    # TODO: implement test for appimage_validate
    assert_equals 0 0
    return 0
}
test_register "test_appimage_validate"
