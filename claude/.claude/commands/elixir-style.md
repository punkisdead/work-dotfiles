# Elixir Style Guide — Coding Conventions

When writing or modifying Elixir code, follow these conventions. Apply them to all new code and when refactoring existing code. Do not refactor code that isn't part of the current task.

## Expressions

- **Pipe chains** must start with a bare variable, not a function call.
  ```elixir
  # wrong
  String.trim(s) |> String.downcase()
  # right
  s |> String.trim() |> String.downcase()
  ```

- **Single-line if/unless**: use `do:` syntax — `if condition, do: value`

- **Never use `unless` with `else`**. Rewrite with `if` and positive case first.

- **`cond` catch-all**: use `true ->` as the last clause, not `:else ->`.

- **Zero-arity function calls**: always include parentheses to distinguish from variables.

## Naming

- `snake_case` for atoms, functions, variables.
- `PascalCase` for modules. Keep acronyms uppercase (`SomeXML`, not `SomeXml`).
- Guard macros: prefix with `is_` (`defguard is_cool(var) when ...`).
- Predicate functions (not usable in guards): trailing `?` (`def cool?(var)`).
- **Schema columns** for booleans: use `is_` prefix (`is_deleted`, `is_locked`).
- **Struct/map keys** for booleans: use trailing `?` (`client_level_enabled?`).
- **Variables** for booleans: use trailing `?` (`active?`).
- Private functions with same name as public: prefix with `do_` (`defp do_sum`).

## Modules

- `snake_case` file names for `PascalCase` modules.
- Each nesting level = a directory (`Parser.Core.XMLParser` → `parser/core/xml_parser.ex`).
- Avoid repeating fragments in module names (`Todo.Item` not `Todo.Todo`).
- Use `__MODULE__` for self-references. Alias with `alias __MODULE__, as: Name` if desired.
- **Never group aliases**. Write one `alias` per line, alphabetized.
  ```elixir
  # wrong
  alias App.Accounts.{Client, Company, User}

  # right
  alias App.Accounts.Client
  alias App.Accounts.Company
  alias App.Accounts.User
  ```

- **Module attribute ordering** (with blank lines between groups):
  1. `@moduledoc`
  2. `use`
  3. `import`
  4. `require`
  5. `alias`
  6. `@behaviour`
  7. `@module_attribute`
  8. `@callback` / `@macrocallback` / `@optional_callbacks`
  9. `@type`
  10. `defstruct`
  11. Function definitions (`defmacro`, `defguard`, `def`, etc.)

## Structs

- Use `TypedStruct` instead of `defstruct`:
  ```elixir
  use TypedStruct

  typedstruct do
    field :name, String.t()
    field :active, boolean(), default: true
  end
  ```

## Pattern Matching

- **Assign to the right**: `%SomeStruct{} = data`, not `data = %SomeStruct{}`.
- **Only deconstruct in pattern match heads when used for control flow**. Otherwise use dot access:
  ```elixir
  # wrong — deconstructing just to pass fields
  def process(%Order{id: id, status: status}), do: do_work(id, status)

  # right — use dot access for field reads
  def process(%Order{} = order), do: do_work(order.id, order.status)
  ```
- List deconstruction (`[head | _tail]`) is fine for convenience.

- **Simple conditionals**: prefer `if`/`case`/`cond` over adding private function heads for simple branching.

- **Too many function heads**: consolidate into fewer heads using `cond`/`case` inside the body.

- **Use `with` for branching/error propagation**:
  ```elixir
  with {:ok, user} <- User.find(user_id),
       {:ok, item} <- Item.find(item_id) do
    # happy path
  end
  ```
- **Standardize error tuples** so `with` doesn't need an `else` block. Avoid named tuple workarounds (`{:user, ...}`).
- Prefer `with` over `case` when you're just bubbling up errors.

## Documentation

- Always include `@moduledoc` right after `defmodule` (or `@moduledoc false`).
- Blank line after `@moduledoc`.
- **Avoid `## Examples` in docs** unless you also add `doctest` in the test file to keep them fresh.
- Comments: capitalize, use punctuation for complete sentences, limit to 100 chars.
- Annotation keywords (`TODO`, `FIXME`, `OPTIMIZE`, `HACK`, `REVIEW`): uppercase, followed by colon and space.

## Typespecs

- `@typedoc` and `@type` together, separated by blank lines between pairs.
- Long union types: one variant per line with leading `|`.
- Main module type: `@type t :: %__MODULE__{}` (no field specs in the type).
- `@spec` goes right before `def`, after `@doc`, no blank line between them.
- Keep pattern matching in function heads even with specs (`def process(%Order{} = order)`).

## Collections

- Keyword lists: always use `[key: value]` syntax, not `[{:key, value}]`.
- Maps with all atom keys: use `%{a: 1}` not `%{:a => 1}`.
- Maps with any non-atom key: use arrow syntax for all keys.

## Strings & Numbers

- Match strings with `<>` concatenator, not binary patterns.
- Use `_` to separate large numbers by thousands: `100_000`.
- Store currency as integer cents with visual separator: `100_000_00` ($100,000.00).

## Queries (Ecto)

- Composable query functions: name with `with_` prefix (`def with_company(query)`).
- Use named bindings (`as: :name`) in joins for composability.
- Use macros for composable queries involving embedded schemas/fragments.

## Code Organization

- **Locate functions in the context of the return value**, not the input data.
- **Domain contexts**: group by domain concern, not by functionality. Contexts can have sub-contexts.
- The context module is the public API — other modules call through it (`Accounts.get_user/1`).
- Use `def` wrapper functions instead of `defdelegate` for better IDE navigation.

## Code Patterns

- **Anti-corruption layer**: define structs for external API data (`%GitHub.Repo{}` not raw maps).
- **Error propagation**: define a standard error type used across the application.
- **Data migrations**: separate from schema migrations in `priv/data_migrations/`. Delete when no longer needed.
- **Primary keys**: use `id` for integer PKs, `uuid` for UUID PKs.

## Metaprogramming

- Avoid needless metaprogramming.
