# Rails Project — Claude Code Configuration

## Before Every Commit
1. Run `bin/rubocop` to check style
2. Run `bundle exec rspec` to verify tests pass
3. Run `bin/brakeman` to check security
4. Verify no .env or secret files are staged

## RSpec Best Practices (betterspecs.org)

### Structure
- Describe methods with `.class_method` and `#instance_method`
- Use `context` blocks starting with "when", "with", or "without"
- Keep `it` descriptions under 40 characters; use context for setup details
- Never start descriptions with "should" — use third-person present tense ("does not change timings")

### Writing Specs
- One expectation per test in unit specs (multiple OK in system/integration specs)
- Always use `expect()` syntax, never `should`
- Use `subject` and `is_expected` to DRY up specs testing the same object
- Use `let` (lazy) and `let!` (eager) over instance variables in `before` blocks
- Use FactoryBot over fixtures; for pure unit tests, prefer plain objects with no persistence

### Coverage
- Test all paths: valid, edge, and invalid cases
- Use `shared_examples` with `it_behaves_like` to DRY shared behavior
- Prefer system specs (Capybara) for testing user-facing flows over controller specs
- Stub external HTTP with WebMock/VCR — never hit real APIs in tests

### Data
- Create only the data you need — don't over-populate
- Use `create_list` intentionally, not by default

## Rails Conventions
- Follow Rails conventions over configuration
- Use Rails credentials for secrets (`bin/rails credentials:edit`)
- Prefer Hotwire over heavy JavaScript frameworks
- Use Stimulus for JS interactivity
- Use Turbo for SPA-like navigation
- Write tests for all new functionality

## Quality Gates
- Max 100 lines per controller action
- Max 50 lines per model method
- Extract service objects for complex business logic
- Use concerns for shared model/controller behavior
