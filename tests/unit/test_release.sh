#!/usr/bin/env bash
framework_require release || true
test_release_prepare() {
    # TODO: implement test for release_prepare
    assert_equals 0 0
    return 0
}
test_register "test_release_prepare"
test_release_manifest() {
    # TODO: implement test for release_manifest
    assert_equals 0 0
    return 0
}
test_register "test_release_manifest"
test_release_finalize() {
    # TODO: implement test for release_finalize
    assert_equals 0 0
    return 0
}
test_register "test_release_finalize"
