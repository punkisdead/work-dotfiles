# Elixir Code Review

You are reviewing Elixir code for style, correctness, and maintainability. Use the checklist below to evaluate the code. When providing feedback, cite the specific convention being violated and show the preferred form.

## How to Review

1. Read the diff or files provided
2. Walk through each checklist category
3. Report issues grouped by severity:
   - **Must Fix** — violates a convention or introduces a bug
   - **Should Fix** — improves readability/maintainability
   - **Nit** — minor stylistic preference
4. For each issue, show the problematic code and the preferred alternative
5. Call out things done well — good reviews aren't only negative

## Review Checklist

### Expressions & Control Flow
- [ ] Pipe chains start with a bare variable (not a function call)
- [ ] Single-line `if/unless` uses `do:` syntax
- [ ] No `unless` with `else` — should be `if` with positive case first
- [ ] `cond` catch-all uses `true ->`, not `:else ->`
- [ ] Zero-arity function calls include parentheses
- [ ] Simple conditionals use `if`/`case`/`cond`, not unnecessary private function heads
- [ ] Functions with many pattern-matched heads are consolidated using `cond`/`case` in the body

### Naming
- [ ] `snake_case` for atoms, functions, variables
- [ ] `PascalCase` for modules; acronyms stay uppercase (`SomeXML`)
- [ ] Guard macros prefixed with `is_`
- [ ] Predicate functions use trailing `?` (not `is_` prefix)
- [ ] Boolean schema columns use `is_` prefix (`is_deleted`)
- [ ] Boolean struct/map keys use trailing `?` (`enabled?`)
- [ ] Boolean variables use trailing `?`
- [ ] Private functions sharing a public function's name are prefixed with `do_`

### Modules & Aliases
- [ ] One `alias` per line (no grouped aliases)
- [ ] Aliases are alphabetized
- [ ] Module attributes in correct order (`@moduledoc` → `use` → `import` → `require` → `alias` → `@behaviour` → attributes → types → structs → functions)
- [ ] Blank lines between attribute groups
- [ ] `__MODULE__` used for self-references
- [ ] No repeated fragments in module names

### Structs
- [ ] Uses `TypedStruct` instead of bare `defstruct`

### Pattern Matching
- [ ] Variables assigned to the right (`%Struct{} = data`, not `data = %Struct{}`)
- [ ] Deconstruction in pattern heads only when used for control flow; dot access otherwise
- [ ] `with` used for multi-step error propagation (not nested `case`)
- [ ] `with` blocks don't use `else` when error tuples are standardized
- [ ] No named tuple workarounds in `with` (`{:user, ...}`)

### Documentation & Comments
- [ ] `@moduledoc` present (or `@moduledoc false`) right after `defmodule`
- [ ] Blank line after `@moduledoc`
- [ ] No `## Examples` in docs unless backed by `doctest`
- [ ] Comments are capitalized, punctuated, ≤100 chars
- [ ] Annotations use uppercase keywords (`TODO:`, `FIXME:`, etc.)

### Typespecs
- [ ] `@spec` placed right before `def`, after `@doc`, no blank line between
- [ ] Pattern matching preserved in function heads alongside specs
- [ ] Long union types use one variant per line with leading `|`
- [ ] Main module type is `@type t :: %__MODULE__{}`

### Collections & Strings
- [ ] Keyword lists use `[key: value]` syntax
- [ ] All-atom maps use shorthand `%{a: 1}`
- [ ] Mixed-key maps use arrow syntax for all keys
- [ ] String matching uses `<>`, not binary patterns
- [ ] Large numbers use `_` separators (`100_000`)
- [ ] Currency stored as integer cents (`100_000_00`)

### Queries
- [ ] Composable query functions prefixed with `with_`
- [ ] Joins use named bindings (`as: :name`)

### Code Organization
- [ ] Functions located in the context of the return value, not the input
- [ ] External module calls go through domain context (`Accounts.get_user/1`)
- [ ] No `defdelegate` — use wrapper `def` functions
- [ ] External API data wrapped in structs (anti-corruption layer)

### Error Handling
- [ ] Standard error type used (`{:error, %{type: ..., error_message: ...}}`)
- [ ] Exception names end with `Error`
- [ ] Error messages are lowercase, no trailing punctuation

### Testing (if tests are in scope)
- [ ] Expected value on left, actual on right in assertions
- [ ] List assertions sort both sides (unless testing order)
- [ ] `describe` blocks named with function/arity
- [ ] Setup uses named functions, not inline blocks
- [ ] Tags are simple primitives (≤4 per annotation)
- [ ] `build/2` preferred over `insert/2` when DB not needed
- [ ] Tests cover logic at the right level — edge cases pushed to unit tests of called functions

## Output Format

```markdown
## Code Review: [file or PR description]

### Must Fix
1. **[Category]** — [file:line] — [description]
   ```elixir
   # current
   ...
   # preferred
   ...
   ```

### Should Fix
1. ...

### Nits
1. ...

### Looks Good
- [Call out well-written code, good patterns, or nice improvements]
```
