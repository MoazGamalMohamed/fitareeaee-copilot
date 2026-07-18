# Sanitized Publication History

The original local repository predates Build Week and once tracked a root
`.env` file. Its values are not used by the submitted application, but that
ancestry must not be published. The public submission repository is therefore
created from a separate clone in which `.env` is removed from every commit and
tag. No source or evidence commit is squashed, reordered, or presented as new.

History rewriting changes commit hashes even when the remaining tree and
metadata are otherwise unchanged. This map connects the preserved local
evidence to the sanitized publication history:

| Evidence point | Original local commit | Sanitized public commit |
| --- | --- | --- |
| Pre-existing baseline | `69f9a704c9612d0524a2027275ab0d259508bd49` | `5d28671a47e796ece0c2c5ab2b2a02187b8f0dc7` |
| Stage 0 | `0e07e27d0c0b1a6331a79696b47a6b87bc45962b` | `a370e1a98571ffa2b6629f84fd6f021ba7482eb9` |
| Stage 1 | `9430035b27349f5f6d0fc3d572c9497d396e47e8` | `e1b0aed7187f96fc15d3020145a1bc7392f00cba` |
| Stage 2 local | `3ddeaae13ce4852d1a8744cd8e7204e0fcb8bec9` | `66e2ebaf0564761e61e5e8cfdc8f7152adb91f93` |
| Stage 3 APK source | `31deb8c8dc132f1768e19b55b3676fa712865678` | `8a87b665a3259e6251d1d1d41c8b28012d1a600b` |
| Stage 3 evidence | `9015811b913291e6485be85c91fc3e0dcbd7103a` | `e4819ccc919af2256337fd96ad140f8cdcfbd0b5` |

The annotated tag names are preserved:

- `build-week-preexisting-baseline`
- `build-week-stage0`
- `build-week-stage1`
- `build-week-stage2-local`
- `build-week-stage3-local`

The Stage 3 APK was built before publication rewriting. Its original and
sanitized tagged commits have the same application source tree; the only
history transformation before publication is removal of `.env`. APK evidence
and hashes remain recorded in [`BUILD_WEEK_PROGRESS.md`](BUILD_WEEK_PROGRESS.md).

Before any push, the publication clone is checked for reachable `.env` paths,
secret signatures, backup refs, branch/tag targets, and a clean worktree. The
original local repository is never configured as the public remote and is
never force-pushed.
