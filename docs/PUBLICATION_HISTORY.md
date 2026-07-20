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
| Authorized resume, recovery, and judge provisioning | `867f96867ff54588cc07f9f009b657d046a2ccf6` | `d3e624c7666def3a05dd61a4e33bb66852feb904` |
| Hardened booking/chat/safety flow | `31d12dc48fcfb971717464a0b4b46b6d78f9371c` | `d4b2b645971e4c6dc1f972c1716fc7b999c1a64e` |
| Android judge version code | `15baa237707b3115475b09ca7a586e1c171517a7` | `68ee892f7e55253046e808b7b5d6852e0f1e88af` |
| Hardened Android checkpoint evidence | `a4053e12bdcd1f484a54f06e412ffa2dcb141423` | `5c78f8f04dffab66e438821e7092fdc044e3e801` |
| Targeted deployment and release-document checkpoint | `ba9c3436645195180120c012e286d033b2da21f6` | `9af9064f25443f22464e91961c4423085aef0b19` |
| Privacy-safe Copilot diagnostics | `68b123e9ff29382636174fd6aa82e968dedc7827` | `9f5802683e3764b9737df2c7a38c4ef13c569d00` |
| Live GPT-5.6 verification evidence | `2495e70bc2cda0f162084441e2d55f7dfd742d63` | `f2dda9c00bfd6c58140602a8aded0adbfdce6a86` |
| Public v1.0.0 release evidence | `8447d5f` | `4006dc0` |
| Phone-found notification compatibility fix | `c5b67364835aa32a59f6e40e7b2055c6aed8d5d0` | `865a5e8a6d6e581fbcd781e5a4ba936529406609` |
| Phone-tested v1.0.1 release evidence | `866eb46a79783ff2cb5ab44f6b5857ac292b4700` | `b973cc31dad1681fd28e9225bc1bc97c1013ec9f` |
| Judge-path roles/chat/support source | `21f49cabd8303dd7ab4019468cb1cfa71ce26f0c` | `eaa4378` |
| Physical-device checkpoint evidence | `708fb6b` | `5ad4b94` |
| Authorized Chat-list query correction | `832a543cd94c4f5a2a8c17163e73113da85aba24` | `c42bc3f4c04d960b8ab09804b90c1a3d4ef50e43` |
| Payment-gated proposal source / v1.0.5 APK source | `4630703b5a69e151d07d6e6c9683deced6298302` | `6d67f306203886d3d1623f9966f36764589b9cfb` |
| v1.0.5 physical-phone evidence | `a156c8fdef67b018f014d7cece9e5956da9ce4d2` | `b353facc46c3bd4b2918f91458df9d80aea9903d` |
| v1.0.5 stable-release promotion | `dd1378a69bfa072c80542e86d79ab2f74ffbfc0c` | `ffb8a39bb81716b1873efd49efc969a53a607606` |
| v1.0.6 mapped voice/lifecycle source | `47f49ce72504d90446058c9ea2dc3e3db845e3d4` | `9194066a38777d8fba9fd9b84810f688f5bc3a2e` |
| v1.0.6 lifecycle evidence | `4ea1257b9bc3d2df9af34a7fdb965027ac1a5646` | `c5f6d60f0464483603026f52e73c2e2ab575ded2` |
| v1.0.6 optimized APK evidence | `199fd6a0c33aff5f3af2223e826ac540a3ca0904` | `27c706c6cf81f90ba0976f463e95bd90ff57e9ae` |
| v1.0.6 judge-document audit | `9d9705af510a0a00cb988670fe25ee6a39a13894` | `8510b07f4c441deeba808655b4b1f9334527d715` |
| v1.0.6 release-audit evidence | `6f2e9c7d4f8d43593378f8045088eda1f59dac97` | `17b499ef24aac60a068be9a6ed4efceb4162ce84` |
| v1.0.7 visible OSM-attribution source/tag | `96343be6eb348e3ef9dd407ff2b2d84c83d2e801` | `06195d02398c32783fa894f7e1bb5ab1d5fb4daf` |
| v1.0.7 release evidence and credential hardening | `23f1ae0f85cd887307fcaaadae3de5c4b678eda3` | `329f5c656dec48cf86c9f9e8e7d4849bdd966d15` |
| v1.0.8 voice/verification/lifecycle source and tag | `3817ed587bc141856c7c20eed126aa8c5508091e` | `54b1654cf42d716d47d56b1e649da139d6f9b097` |
| v1.0.8 emulator release evidence | `eb78ecf81b9ce898c24c15ba076d2004ebe7eadc` | `d2e81d3f36d74a0cd0a70c02a601ac72bfcc8993` |
| v1.0.8 public artifact evidence | `45452a4c968600438506b493c2939f1f4c4a8266` | `5f2819c574622accdaa420064751cdc9c1b5a827` |
| v1.0.9 truthful owned-trip status source and tag | `ab792130938601370f5ccf87ef4af3ff0290076e` | `ef2eecb7cdc9a0e446c7a15d0d72b335820ffd56` |
| v1.0.9 local release evidence | `d23cafdc83923e00aa16b678d63e893c11464445` | `7beb96fc5c9295e21caab4258d53d3ad4718008d` |
| v1.0.9 public artifact and driver-smoke evidence | `54367090ee43ac93f7d41f8ce75a6662cfcc4258` | `a064e7aa69757a17d8ebf8341ff74c917d18cfcc` |
| Final public-access and cold-launch integrity audit | `358a639daca99672d315009097433db4612e7a99` | `12e34a4e32bd9fd499b3c8ef1d136046d6a744b8` |
| Complete current-source release-gate rerun | `f92f4e57369da413260be3eb3d923e62381d4232` | `e26b61dd245201f30761c27ee02f13dcfcc3c906` |
| Read-only inherited Function inventory revalidation | `0a710d42a6b8fecaf70d123c79eedfcda21fc32b` | `c727ca376f43f0953cdf4da1d4ecb74d8485977e` |
| v1.0.10 verification/map/action source | `9b92625f20912607d3c7ce32db9902fc76971eae` | `fe73ad5509ac348f120b025688eee1abd2c009d8` |
| v1.0.10 verification gate evidence | `ffa6e34811e4682a7ea8ce01990a645bcecdc86f` | `25f2adf2178a624ea79e2ff3f4f8eb13ab67d8f2` |
| v1.0.10 judge handoff and public-release evidence | `deecf6ec12144ae94e4509e1810fdbcff7b3005e` | `6ce1141d8d9283adffc79986cc835bf632e75be1` |
| v1.0.11 role-path/voice/location source and tag | `b05c91fd2b6856952a028866ec57a83c57ac116e` | `4e1439b098c53c41bf9d95b9f82f3a607b0240bc` |

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
