# How I work

- Never commit; I commit.
- Breaking changes are fine unless a project says otherwise. Remove the old behaviour outright: no compatibility shims, no deprecated flags, no "kept to avoid breaking" code.
- Number findings and options so I can answer "fix 1-5, explain 6".
- Explain in plain words with a concrete scenario. When logic grows hard to explain, show the scenarios. If the result is still complicated, prefer reverting to the simpler behaviour.
- Ask before changing behaviour that is ambiguous. For a refactor that touches many places, plan it first and wait for a go-ahead.
- When a simplification would sacrifice behaviour, list it with exactly what is lost and let me choose. Do not decide alone.
- Verify claims by running them, not by reasoning from the code. Say plainly what was not checked.
- Throwaway repos and scripts go in the scratchpad, never in the project.
- Before answering anything from git state (tags, branches, what's released or deployed), run `git fetch` first and check its output and exit code; a failed or partial fetch means the answer is unverified. Read from the remote (`origin/<branch>`, `git ls-remote`), not the local checkout, which may be on a feature branch or hold stale tags. Never force-overwrite local tags or branches to sync; say they're stale and let me decide.
- Stay in scope: don't change code outside what the task covers. If the scope isn't clear, stop and ask before touching anything. Put what you find out of scope in a separate section; don't silently drop it.
- Check README/docs before flagging a behaviour: if it's documented, it's intentional; if the docs and the code disagree, say so. If it's unclear which docs apply or whether they're current, ask me. With no docs covering it, say it in an inline comment.
- If investigation shows an earlier finding was wrong, say so and restate it accurately in a corrections section at the end; never quietly drop it.
- When I say an explanation isn't landing, build a self-contained HTML file (inline CSS/SVG, no external deps) outside the project (e.g. `/tmp`) and give its path plus a short text version.
- Reviews: start with design and duplication hotspots; go line by line only where risk is real. Risk, at least: correctness, data loss, security, concurrency, panics, environment/portability, resource leaks, compatibility (CLI flags, config, saved formats), performance, and failure paths.

# How to refactor and simplify

1. **Make invalid states impossible: store each independent fact once, in its own place.**
    - **One value, one question.** Use an enum instead of several bools, and a non-optional value instead of a later `None` check. When a single value answers two independent questions, it only covers the combinations someone listed, so a valid one can be missing, and every reader has to take it apart; give each question its own value. Signs: names that combine words into a grid (`picked_bright`, `closed_rooted`), the same name with a suffix (`text`, `text_focused`), code that always checks a pair of cases together, or callers that build the value from two others. Missing combinations are fine only when they mean nothing in the domain; say so in a comment.
    - **Don't store what can be asked.** If the receiver can find a fact itself, don't have each caller work it out and pass it in: the copies can disagree, and a new caller can get it wrong.
    - **Keep a fact with what it describes.** A detail that only applies in one case belongs to that case (data held by the variant it belongs to), not beside it where it must be ignored the rest of the time.
    - **Name choices, don't flag them.** A bare `true`/`false` says nothing at the call site; a named choice does. Bool parameters (`set_x(true)`) and enum variants carrying bool fields are suspects.
2. **Fix the root cause in the shared mechanism.** A special case layered on top is a sign the fix is too shallow. Change the underlying code so the case is no longer special.
3. **One implementation for one concept.** Look for near-copies (popups, search, trees, panels) and merge them. Shared concepts behave identically everywhere. The same goes for definitions: two types, settings or names that map one-to-one are one concept; keep one and adapt at the edge (like the names the config or command line uses).
4. **Delete before adding.** Remove unused features, dead options, thin wrappers and the extras they leave behind.
5. **Avoid too many tiny functions.** A small function used once is usually clearer inlined; jumping between helpers costs human context. Extract only for real reuse or a separately testable job.
6. **No redundant guards.** Skip a pre-check when the operation itself fails with a clear error anyway; show the tool's own error.
7. **Crates and libraries: use one when it is clearly better** than our code, but don't add one to replace ~25 lines that already cover our cases. Use what is already a dependency before writing it again. Explain the trade-off either way.
8. **Prefer the simpler model.** If a feature needs subtle rules, show the scenarios and lean towards the simpler rule or a warning.
9. **A dedup is a behaviour claim, not a shape.** Before proposing one, confirm from the code that they do the same thing and that unifying keeps behaviour (say plainly when it's reasoned, not verified). Near-copies often differ in a condition that matters, or carry state one side doesn't use; when they do, list exactly what changes and let me choose. If it's unclear whether they're the same, or whether to extract part or all, ask me.
10. **Refactor the production code without shaping it around the tests.** Change the tests to match, and still run them. Tests aren't the source of intended behaviour: I decide when one is wrong, so ask me rather than guessing. Don't extract shared test helpers or dedupe test code.
11. **A shared type owns only what is truly identical.** Keep state the callers must differ on (cursor, selection, focus) with the callers — if two callers would set a field differently, it stays out; one source of truth.

# UI

- Disable actions that are invalid in the current state. When fixing one such case, look for the others.
- The same element looks the same everywhere. Inconsistent UI is a bug; add a test that would catch it.

# Tests and checks

- Risky logic and failure paths get a test. Tests must not depend on the user's environment (git config, home directory).
- A test for a bug must fail without the fix: check that once, by reverting the fix or with a probe.
- Before reporting done, run the project's CI checks (format, lint, tests), with the whole test suite rather than a filtered run.
- Rust: code reviews also apply `~/.claude/microsoft-rust-guidelines.txt`.
