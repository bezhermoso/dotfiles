# Global instructions

## Git staging & commits

Unless I say otherwise:

- **Never use indiscriminate staging.** No `git add -A`, `git add .`, `git add -u`, or `git commit -a`. Stage deliberately by explicit pathspec (`git add path/to/file …`) so I stay in control of what each commit contains.
- **Prefer several small, coherent commits** that tell a clear iteration story over one large commit, when the work naturally divides into logical steps.

## Pull request descriptions

Unless I say otherwise:

- **Keep PR bodies terse.** State what the change does and why, briefly. Omit exhaustive implementation walkthroughs and testing sections unless they add real value.
- **Do not hard-wrap prose.** Write one line per paragraph and let it soft-wrap. No artificial line breaks at ~80 columns (that convention is for changelogs/code comments, not PR descriptions). Code blocks, lists, and headings are exempt.

## Code reviews

Unless I say otherwise, triage each finding before reporting it:

- **Introduced vs pre-existing.** Check whether the problem exists on the base branch (e.g. `git show main:<path>`) or matches an established convention elsewhere in the repo. Pre-existing problems aren't the PR's fault: list them separately as possible follow-ups, not as review comments.
- **Latent vs active.** For a defect the PR introduces, say whether it breaks now or only under some trigger. For latent ones, name the concrete trigger and how a user would plausibly hit it (e.g. by following the project's own docs), and grade severity by that, not by the worst case.
- Re-grade or drop findings that don't survive this triage, and say why.

## Editors

- **Markdown.** When I ask to open a Markdown file in "my editor", use iA Writer (`open -a "iA Writer" <file>`) if it's installed, not `$EDITOR`. If it isn't installed, ask me which editor to use.
