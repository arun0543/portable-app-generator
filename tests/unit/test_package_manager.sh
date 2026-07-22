#!/usr/bin/env bash
framework_require package_manager || true
test_package_detect() {
    # TODO: implement test for package_detect
    assert_equals 0 0
    return 0
}
test_register "test_package_detect"
test_package_deb() {
    # TODO: implement test for package_deb
    assert_equals 0 0
    return 0
}
test_register "test_package_deb"
test_package_rpm() {
    # TODO: implement test for package_rpm
    assert_equals 0 0
    return 0
}
test_register "test_package_rpm"
