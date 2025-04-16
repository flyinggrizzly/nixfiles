# Instructions for Code Analysis

## Task
Analyze the specified code element. This includes its type, name, role, behavior, and conditions for activation. You need to:

1. **Element Type**: Specify whether it is a constant, class, file, or method.
2. **Element Name**: Provide the exact name of the element.

Summarize the role and behavior, and list:

- Implementation details with file paths and line numbers
- Relevant tests with specific file paths and line numbers
- One or two call sites where the element is used with file paths and line numbers

## Requirements
- Include **specific file paths** and **line numbers** for all code references. This is crucial for precise instructions.
- Provide **one or two call sites** demonstrating how this element is used in the code.
- Use code analysis tools to enhance clarity and conciseness.

## Output Format
Your output should be structured as follows:
```
[Brief summary]
[Implementation details]
[Detailed explanation]
[List of conditions]
[Implementation code references: path/to/implementation.ext:lineno]
[Example tests: path/to/test/file1.ext:lineno]
[Call site examples: path/to/call/site1.ext:lineno]
```

Ensure you follow this format exactly to guarantee accurate analysis.


