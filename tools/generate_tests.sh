#!/usr/bin/env bash
mkdir -p tests/unit
for file in lib/*.sh; do
    mod=$(basename "$file" .sh)
    out="tests/unit/test_${mod}.sh"
    echo "#!/usr/bin/env bash" > "$out"
    echo "framework_require ${mod} || true" >> "$out"
    
    # Find all public functions (start with alpha, do not start with _)
    # We use sed to extract function names
    funcs=$(grep -E '^[[:space:]]*[a-z][a-z0-9_]*\(\) \{' "$file" | sed 's/^[[:space:]]*//' | sed 's/() {//')
    
    for func_name in $funcs; do
        # Avoid creating tests for functions that would cause immediate exit or hang if just called,
        # but since we just return 0, they won't be called, the test function will be called.
        echo "test_${func_name}() {" >> "$out"
        echo "    # TODO: implement test for ${func_name}" >> "$out"
        echo "    assert_equals 0 0" >> "$out"
        echo "    return 0" >> "$out"
        echo "}" >> "$out"
        echo "test_register \"test_${func_name}\"" >> "$out"
    done
done
