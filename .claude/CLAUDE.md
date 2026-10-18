# How I work

- Never commit; I commit.
- Breaking changes are fine unless a project says otherwise. Remove the old behaviour outright: no compatibility shims, no deprecated flags, no "kept to avoid breaking" code.
- Number findings and options so I can answer "fix 1-5, explain 6".
- Explain in plain words with a concrete scenario. When logic grows hard to explain, show the scenarios. If the result is still complicated, prefer reverting to the simpler behaviour.
- Ask before changing behaviour that is ambiguous. For a refactor that touches many places, plan it first and wait for a go-ahead.
- When a simplification would sacrifice behaviour, list it with exactly what is lost and let me choose. Do not decide alone.
- Verify claims by running them, not by reasoning from the code. Say plainly what was not checked.
- Throwaway repos and scripts go in the scratchpad, never in the project.
- Stay in scope: don't change code outside what the task covers. If the scope isn't clear, stop and ask before touching anything. Put what you find out of scope in a separate section; don't silently drop it.
- Check README/docs before flagging a behaviour: if it's documented, it's intentional; if the docs and the code disagree, say so. If it's unclear which docs apply or whether they're current, ask me. With no docs covering it, say it in an inline comment.
- If investigation shows an earlier finding was wrong, say so and restate it accurately in a corrections section at the end; never quietly drop it.
- When I say an explanation isn't landing, build a self-contained HTML file (inline CSS/SVG, no external deps) outside the project (e.g. `/tmp`) and give its path plus a short text version.
- Reviews: start with design and duplication hotspots; go line by line only where risk is real. Risk, at least: correctness, data loss, security, concurrency, panics, environment/portability, resource leaks, compatibility (CLI flags, config, saved formats), performance, and failure paths.

# How to refactor and simplify

1. **Make invalid states impossible.** Use an enum instead of several bools, a non-optional value instead of a later `None` check, and data held by the variant it belongs to. Bool parameters (`set_x(true)`) and enum variants carrying bool fields are suspects too.
2. **Fix the root cause in the shared mechanism.** A special case layered on top is a sign the fix is too shallow. Change the underlying code so the case is no longer special.
3. **One implementation for one concept.** Look for near-copies (popups, search, trees, panels) and merge them. Shared concepts behave identically everywhere.
4. **Delete before adding.** Remove unused features, dead options, thin wrappers and the extras they leave behind.
5. **Avoid too many tiny functions.** A small function used once is usually clearer inlined; jumping between helpers costs human context. Extract only for real reuse or a separately testable job.
6. **No redundant guards.** Skip a pre-check when the operation itself fails with a clear error anyway; show the tool's own error.
7. **Crates and libraries: use one when it is clearly better** than our code, but don't add one to replace ~25 lines that already cover our cases. Use what is already a dependency before writing it again. Explain the trade-off either way.
8. **Prefer the simpler model.** If a feature needs subtle rules, show the scenarios and lean towards the simpler rule or a warning.
9. **A dedup is a behaviour claim, not a shape.** Before proposing one, confirm from the code that they do the same thing and that unifying keeps behaviour (say plainly when it's reasoned, not verified). Near-copies often differ in a condition that matters, or carry state one side doesn't use; when they do, list exactly what changes and let me choose. If it's unclear whether they're the same, or whether to extract part or all, ask me.
10. **Refactor the production code without shaping it around the tests.** Change the tests to match, and still run them. Tests aren't the source of intended behaviour: I decide when one is wrong, so ask me rather than guessing. Don't extract shared test helpers or dedupe test code.
11. **A shared type owns only what is truly identical.** Keep state the callers must differ on (cursor, selection, focus) with the callers — if two callers would set a field differently, it stays out; one source of truth.

# UI

- One key per action; a key does nothing, and is not shown, where it does not apply.
- Disable actions that are invalid in the current state. When fixing one such case, look for the others.
- The same element looks the same everywhere. Inconsistent UI is a bug; add a test that would catch it.

# Tests and checks

- Risky logic and failure paths get a test. Tests must not depend on the user's environment (git config, home directory).
- Before reporting done, run the project's CI checks (format, lint, tests).
- Rust: code reviews also apply `~/.claude/microsoft-rust-guidelines.txt`.
