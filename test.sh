#!/bin/bash

# Test script for development environment

echo "Development Environment Test Script"
echo "=================================="

# Check if container is running
echo "Checking if container is running..."
if ! docker ps | grep -q "devmax"; then
    echo "ERROR: devmax container is not running!"
    echo "Please run 'docker compose up -d' first"
    exit 1
fi

echo "Container is running ✓"
echo ""

# Test commands in container
echo "Testing commands in container..."

# Function to test a command
test_command() {
    local cmd="$1"
    local description="$2"
    
    echo "Testing $description..."
    if docker exec devmax bash -c "$cmd" > /dev/null 2>&1; then
        echo "  $description: ✓"
    else
        echo "  $description: ✗"
        return 1
    fi
}

# Initialize test results
failed_tests=0

# Test basic commands
test_command "which curl" "curl" || ((failed_tests++))
test_command "which git" "git" || ((failed_tests++))
test_command "which python3" "python3" || ((failed_tests++))
test_command "which pip3" "pip3" || ((failed_tests++))

# Test Node.js
test_command "node --version" "Node.js" || ((failed_tests++))
test_command "npm --version" "npm" || ((failed_tests++))
test_command "tsc -v" "TypeScript" || ((failed_tests++))

# Test Java
test_command "java -version" "Java" || ((failed_tests++))
test_command "javac -version" "Java compiler" || ((failed_tests++))
test_command "mvn -version" "Maven" || ((failed_tests++))

# Test Go
test_command "go version" "Go" || ((failed_tests++))

# Test Python tools
test_command "black --version" "Black formatter" || ((failed_tests++))
test_command "pytest --version" "pytest" || ((failed_tests++))

# Test additional tools
test_command "which vim" "vim" || ((failed_tests++))
test_command "which jq" "jq" || ((failed_tests++))
test_command "rg --version" "ripgrep" || ((failed_tests++))
test_command "which comby" "comby" || ((failed_tests++))
test_command "which tmux" "tmux" || ((failed_tests++))

# Test SSH service
test_command "pgrep sshd" "SSH daemon" || ((failed_tests++))

echo ""
echo "Test Summary:"
echo "============="

if [ $failed_tests -eq 0 ]; then
    echo "All tests passed! ✓"
    echo "Development environment is ready to use."
    exit 0
else
    echo "$failed_tests test(s) failed! ✗"
    echo "Some tools may not be properly installed."
    exit 1
fi