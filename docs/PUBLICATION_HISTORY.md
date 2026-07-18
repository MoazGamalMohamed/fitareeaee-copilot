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
| Pre-existing baseline | `69f9a704c9612d0524a2027275ab0d259508bd49` | `db10ef96d1e4c1169804f003e744747538c10de9` |
| Stage 0 | `0e07e27d0c0b1a6331a79696b47a6b87bc45962b` | `9b92562969657dea38157bddfdf4a05677abfffd` |
| Stage 1 | `9430035b27349f5f6d0fc3d572c9497d396e47e8` | `7b3cc71cb274cc39c6587d1d157ce0ff9e395023` |
| Stage 2 local | `3ddeaae13ce4852d1a8744cd8e7204e0fcb8bec9` | `38376087d21582877087a579f9909914d5ac65a4` |
| Stage 3 APK source | `31deb8c8dc132f1768e19b55b3676fa712865678` | `7f48fd557bf462e83503a5132a217b2295c967ee` |
| Stage 3 evidence | `9015811b913291e6485be85c91fc3e0dcbd7103a` | `86b8e9d784d99a678cf54f6ac71e3af5127f8d88` |
| Firebase deployment source | `28117b949a5d68eee9a80526d390bb3b3d0ce9ef` | `4df6e359fdf5e4097604fa8e9d132ec37e8dbe4a` |
| Firebase deployment evidence | `4b33131ee4f51109f71d038ae16fb056139bf416` | `18c5660199c5e4a53a80df99b0a7bb319149445f` |
| Prototype-residue cleanup source | `289209ba33ad14d3c767cff541ee19d154066f8c` | `4c6c46a39ff9d9d2332edd8e446a134e299323d5` |
| Cleanup release evidence | `b45d0c587e380afefe01a0eca3e85237a2387959` | `c2551976691ff4081435409204c7144c7c1525e8` |
| Constrained avatar authorization | `00f89ec8c4b644800f0e928ba9b73fd8248bb6c8` | `abf5df96eb0217aa659ee4322e1a2e961d10eebd` |
| Authorized chat entry | `d80b6d3adc06427dc139463934b1842c493b155a` | `a8c42f42c5e9bb77e830251d0c0a65e854512f59` |
| Verification data minimization | `3f3fedfd576110af4e4383da016ecfe321ee0142` | `d533c263f41939a381058e6ab6abedfe1073fe6d` |
| Targeted deployment documentation | `85d73f0a8118c32a3dbc0b7a0786f85f86d271ed` | `ba69b4837e4408aa102dcdf6851a5f6f29331d2b` |
| Consolidated security evidence | `a297c73a2820958a7a0af75e143caebc6681c322` | `0abea666c667cf01989809bbdcb7725473989886` |
| Unreachable-stub cleanup source | `9b591e094bcbbbf3a8a9cbd55fec86908c9e5d16` | `9b94427a30ac6f49098c66a7f7fb43971e16bbc0` |
| Release-cleanup evidence | `46e80f5a61b5a976211faf282e071dcf64a8b807` | `9ff773ddb9fab8ed1dc9a638a53e888ea28eac61` |

The annotated tag names are preserved:

- `build-week-preexisting-baseline`
- `build-week-stage0`
- `build-week-stage1`
- `build-week-stage2-local`
- `build-week-stage3-local`

The Stage 3 APK was built before publication rewriting. Its original and
sanitized tagged commits have the same application source tree; the only
history transformations before publication are removal of `.env` and the
ignored Android Firebase config plus replacement of two historical Firebase
client API literals with placeholders. APK evidence and hashes remain recorded
in [`BUILD_WEEK_PROGRESS.md`](BUILD_WEEK_PROGRESS.md).

Before any push, the publication clone is checked for reachable `.env` paths,
secret signatures, backup refs, branch/tag targets, and a clean worktree. The
original local repository is never configured as the public remote and is
never force-pushed.
