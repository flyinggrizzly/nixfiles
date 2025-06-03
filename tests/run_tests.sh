#!/bin/bash

# Test Runner for nixfiles
# Runs all tests in the tests/ directory

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Running nixfiles test suite...${NC}\n"

# Find and run all test scripts
test_files=$(find tests -maxdepth 1 -name "*_test.sh" -type f)

if [[ -z "$test_files" ]]; then
    echo -e "${RED}No test files found${NC}"
    exit 1
fi

total_tests=0
passed_tests=0

for test_file in $test_files; do
    echo -e "${BLUE}Running $test_file${NC}"
    
    if bash "$test_file"; then
        echo -e "${GREEN}✓ $test_file passed${NC}"
        passed_tests=$((passed_tests + 1))
    else
        echo -e "${RED}✗ $test_file failed${NC}"
    fi
    
    total_tests=$((total_tests + 1))
    echo ""
done

# Summary
echo -e "${BLUE}=== Test Summary ===${NC}"
echo -e "Total test files: $total_tests"
echo -e "${GREEN}Passed: $passed_tests${NC}"

if [[ $passed_tests -eq $total_tests ]]; then
    echo -e "${GREEN}All tests passed! 🎉${NC}"
    exit 0
else
    failed_tests=$((total_tests - passed_tests))
    echo -e "${RED}Failed: $failed_tests${NC}"
    exit 1
fi