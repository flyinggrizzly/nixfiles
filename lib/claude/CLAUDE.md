# Coding style
- DO NOT USE CODE COMMENTS, unless the code is very surprising or non-obvious
- ALWAYS CLEAN UP EXTRA WHITESPACE

# Approach
- STAY FOCUSED ON THE IMMEDIATE TASK AT HAND!!!
    - If you have "nice to have" ideas or suggestions, add them to a `nice-to-haves.md` file and ask me about them once the current task is complete
    - DO NOT MAKE UNNECESSARY CHANGES!!!

# Commits
- Use present-tense, active voice, like "Add new config option"

# Permitted hosts
- https://nixos.org
- https://nix-community.github.io/home-manager/

# Ruby-specific instructions

- Prefer singleton modules in Ruby over instantiable classes when no internal state is managed. Use the `extend(self)` style for declaring the singleton module

## Testing

- prefer `refute` over `assert_not` type assertions
- prefer `assert_predicate object, :message?` over `assert object.message?`
