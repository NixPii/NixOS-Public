# AMD Support — Archived

> [!IMPORTANT]
> **This branch is archived and is no longer the recommended way to use AMD GPUs
> with this project.**
>
> A better GPU implementation now exists in the **main branch**, where AMD,
> NVIDIA, Nouveau, and generic GPU configurations are handled through selectable
> GPU profiles.
>
> This branch is being kept only for historical reference.

## About This Branch

This branch was originally used for the project's AMD-focused configuration.

Because my personal system uses an **AMD GPU with `amdgpu`**, this was
historically the configuration I used and tested most directly.

Over time, however, keeping separate branches for different GPU vendors became
unnecessary and made the project harder to maintain.

The GPU configuration has now been redesigned and consolidated into the **main
branch**.

## Use the Main Branch Instead

You should **not use this branch for new installations**.

AMD support is now included directly in the main configuration.

Select the AMD GPU profile in your NixOS configuration:

```nix
nixpii.gpu.profile = "amd";
```

Other available profiles include:

```nix
nixpii.gpu.profile = "generic";
nixpii.gpu.profile = "amd";
nixpii.gpu.profile = "nvidia";
nixpii.gpu.profile = "nvidia-10series";
nixpii.gpu.profile = "nvidia-legacy";
nixpii.gpu.profile = "nouveau";
```

The project now follows this model:

```text
main contains all supported GPU implementations
            ↓
the user selects the appropriate GPU profile
```

instead of:

```text
AMD user    -> AMD branch
NVIDIA user -> NVIDIA branch
```

This keeps GPU support in one place and avoids splitting the project across
hardware-specific branches.

## Why This Branch Was Archived

The original project structure treated AMD as the main/default GPU
configuration, while NVIDIA support lived separately.

That worked while the project was still evolving, but it created several
problems:

- GPU support was spread across multiple branches
- users had to know which branch matched their hardware
- fixes could easily diverge between branches
- documentation had to describe multiple installation paths
- testing and maintenance became more complicated
- the repository structure implied that GPU vendor choice should determine which
  Git branch someone used

The new GPU module solves this by treating GPU selection as **configuration**,
not repository structure.

AMD is now simply one supported profile in the main branch.

## Current AMD Configuration

The current AMD implementation lives in the main branch and can be enabled with:

```nix
nixpii.gpu.profile = "amd";
```

The AMD profile is responsible for AMD-specific graphics configuration such as
`amdgpu` support and related hardware options.

AMD-specific settings are no longer intended to act as the base configuration
for every system.

This is especially important for NVIDIA systems, which should no longer inherit
AMD-specific configuration that then needs to be overridden.

## Historical Context

Historically, AMD was effectively the project's base GPU configuration because
it matched the hardware I personally use.

That also meant AMD received the most direct real-world testing.

The project later experimented with adding NVIDIA support through boot
specialisations and separate development work.

That approach eventually evolved into the current selectable GPU profile system.

The AMD branch therefore represents an earlier stage of the project rather than
a separate supported edition.

## AMD Hardware

My personal system uses an **AMD GPU with `amdgpu`**, so AMD remains the GPU
configuration I can test most directly on physical hardware.

That does **not** mean AMD users should continue using this branch.

Current AMD fixes, improvements, and testing should target the implementation in
the **main branch**.

## Issues and Pull Requests

Please do **not** report new AMD problems against this archived implementation
unless the issue is specifically about its historical behavior.

For current AMD support, use the implementation from the **main branch**.

If you encounter a problem there, please open an issue against the current
configuration and include useful information such as:

- GPU model
- AMD GPU generation, if known
- NixOS version
- Kernel version
- Mesa version, if relevant
- Selected GPU profile
- Relevant error messages
- `nixos-rebuild` output
- Relevant `journalctl` or kernel logs
- Whether Wayland or X11 is being used
- Any local configuration changes

Pull requests improving the current GPU implementation should also target the
main branch.

## Historical Configuration Warning

Code in this branch may differ significantly from the current GPU
implementation.

It may contain:

- old module structure
- AMD-specific assumptions
- configuration that has since moved elsewhere
- options that are no longer used
- behavior that has been replaced by the new profile system

Do not assume that configuration found here represents current best practices
for this project.

If you are looking for something to copy into a current installation, check the
**main branch** first.

## Status

**Archived**

This branch is:

- No longer under active development
- No longer the recommended AMD installation method
- Preserved for historical reference
- Superseded by the GPU profile implementation in `main`

For current AMD support, use the **main branch** and configure:

```nix
nixpii.gpu.profile = "amd";
```
