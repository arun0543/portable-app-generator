#!/usr/bin/env bash
framework_require package || true
test_package_install() {
    # TODO: implement test for package_install
    assert_equals 0 0
    return 0
}
test_register "test_package_install"
test_package_remove() {
    # TODO: implement test for package_remove
    assert_equals 0 0
    return 0
}
test_register "test_package_remove"
test_package_verify() {
    # TODO: implement test for package_verify
    assert_equals 0 0
    return 0
}
test_register "test_package_verify"
