# Elixir Testing Conventions

When writing or modifying ExUnit tests, follow these conventions. Apply them to all new tests. Use this as a reference when asked to write tests or when creating tests as part of a feature.

## Core Testing Philosophy

- **Test logic at the right level.** Only test the logic of the function under test. Push edge case testing for called functions down to their own unit tests.
- **If a function is a pure pass-through chain with no branching**, write one happy path test to verify correct wiring. Don't test edge cases at that level.

## Assertion Style

- **Expected value on the left, actual on the right:**
  ```elixir
  # wrong
  assert actual_function(1) == true

  # right
  assert true == actual_function(1)
  ```

- **Pattern match assertions** are the exception (left side is a pattern):
  ```elixir
  assert {:ok, result} = actual_function(3)
  ```

- **List assertions** — never rely on insertion order unless sort order is explicitly being tested:
  ```elixir
  # wrong — fragile, depends on DB ordering
  assert expected == SomeModule.get_list()

  # right — sort both sides
  assert Enum.sort(expected) == Enum.sort(SomeModule.get_list())

  # also fine — pattern match the shape, then check membership
  assert [item_1, item_2] = SomeModule.get_list()
  for item <- [item_1, item_2], do: assert item in expected
  ```

## Test Organization

- **`describe` blocks**: use function name and arity as the block name. Keep all tests for a function in one describe block.
  ```elixir
  describe "process_order/1" do
    # all tests for process_order/1 here
  end
  ```

- **Setup functions**: use named setup functions with `setup [:create_user, :setup_job]` instead of inline `setup do` blocks with elaborate setup logic.

- **Use `@tag` and `@describetag`** to configure test variants via context setup functions:
  ```elixir
  setup [:create_user, :setup_job]

  test "returns expected result", %{job: job} do
    assert %{clean: true} == SomeModule.process(job)
  end

  @tag number_of_pets: 4
  test "different result with many pets", %{job: job} do
    assert %{clean: false} == SomeModule.process(job)
  end

  defp create_user(ctx) do
    [user: insert(:user, number_of_pets: ctx[:number_of_pets] || 0)]
  end
  ```

- **"Skip setup" pattern**: use a `@tag` (e.g., `@tag no_user: true`) to keep edge case tests for missing data inside the same describe block, rather than placing them outside.

- **Limit tag key-value pairs to 4 or fewer.** If you need more variation, add setup logic inside the test or use additional context setup functions.

- **Tags must be simple primitives** (strings, integers, atoms, booleans). Never use lists or maps in tags. Put complex configuration in context setup functions.

## Factories (ExMachina)

- **Default to `build/2` over `insert/2`** to identify functions that truly need database access. Only use `insert/2` when the function under test hits the database.
  ```elixir
  # prefer this when the function doesn't need DB
  job = build(:job)
  assert %Job{} = SomeModule.transform(job)

  # only when DB access is needed
  job = insert(:job)
  assert %Job{} = SomeModule.fetch_and_process(job.id)
  ```

- **Factories must build all required fields** as a minimum — they should produce valid records without any overrides.

- **Create named factories for different setup scenarios** of the same schema:
  ```elixir
  def job_factory, do: ...
  def job_payable_only_factory, do: ...
  ```

- **Use `merge_attributes/2`** in factories to allow callers to override defaults.

- **Use `Map.get_lazy/3`** in factories for optional associated records — only insert them if not provided by the caller.

- **Compositional factories** — build complex setups with pipes when appropriate:
  ```elixir
  :job_no_obligations
  |> build(debtor: debtor)
  |> with_payable_obligations(payee: payee)
  ```
