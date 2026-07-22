#!/usr/bin/env bash
framework_require coverage || true
test_coverage_begin() {
    # TODO: implement test for coverage_begin
    assert_equals 0 0
    return 0
}
test_register "test_coverage_begin"
test_coverage_end() {
    # TODO: implement test for coverage_end
    assert_equals 0 0
    return 0
}
test_register "test_coverage_end"
test_coverage_report() {
    # TODO: implement test for coverage_report
    assert_equals 0 0
    return 0
}
test_register "test_coverage_report"
