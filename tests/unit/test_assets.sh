#!/usr/bin/env bash
framework_require assets || true
test_assets_install() {
    # TODO: implement test for assets_install
    assert_equals 0 0
    return 0
}
test_register "test_assets_install"
test_assets_remove() {
    # TODO: implement test for assets_remove
    assert_equals 0 0
    return 0
}
test_register "test_assets_remove"
test_assets_verify() {
    # TODO: implement test for assets_verify
    assert_equals 0 0
    return 0
}
test_register "test_assets_verify"
