# NVIDIA Support — Archived

> [!IMPORTANT]
> **This branch is archived and is no longer the recommended way to use NVIDIA
> GPUs with this project.**
>
> A better GPU implementation now exists in the **main branch**, where AMD,
> NVIDIA, Nouveau, and generic GPU configurations are handled through selectable
> GPU profiles.
>
> This branch is being kept only for historical reference.

## About This Branch

This branch was originally created to experiment with NVIDIA support alongside
the project's AMD-focused configuration.

It introduced separate NVIDIA configurations for different GPU generations,
including:

- Modern NVIDIA GPUs using the NVIDIA Open kernel modules
- GTX 10-series / Pascal GPUs
- Older NVIDIA GPUs using legacy driver branches
- Nouveau as a fallback option

This approach worked as an experiment, but maintaining a separate NVIDIA branch
turned out not to be the best long-term design.

The project now uses a cleaner implementation in the **main branch**.

## Use the Main Branch Instead

You should **not use this branch for new installations**.

GPU support is now included directly in the main configuration.

Instead of switching Git branches depending on your GPU, users can select the
appropriate GPU profile in their NixOS configuration.

For example:

```nix
nixpii.gpu.profile = "nvidia";
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

This means:

```text
main contains all supported GPU implementations
            ↓
the user selects the appropriate GPU profile
```

rather than:

```text
AMD user    -> AMD branch
NVIDIA user -> NVIDIA branch
```

This is easier to maintain, easier to test, and much less confusing for users.

## Why This Branch Was Archived

The original NVIDIA implementation relied heavily on NixOS specialisations.

The system could provide multiple boot options such as:

```text
AMD base configuration
NVIDIA modern specialisation
NVIDIA 10-series specialisation
NVIDIA legacy specialisation
Nouveau specialisation
```

While this was useful for experimentation, it also caused the system closure and
resulting disk images to become significantly larger.

The new implementation allows normal users to select **one GPU profile**
instead.

Optional multi-GPU specialisations still exist in the main branch for users who
actually want them, but they are no longer the default design.

## Historical NVIDIA Configurations

This branch contained the following NVIDIA configurations.

### `nvidia`

For newer NVIDIA GPUs, primarily Turing and newer.

Used the NVIDIA Open kernel modules where supported.

### `nvidia-10series`

Intended for NVIDIA GTX 10-series / Pascal hardware.

Used the proprietary NVIDIA driver instead of the open kernel modules.

### `nvidia-legacy`

Intended for older NVIDIA GPUs requiring a legacy NVIDIA driver branch.

### `nvidia-nouveau`

A fallback configuration using the open-source Nouveau driver.

This was primarily intended for recovery, troubleshooting, and basic fallback
use.

## Hardware Testing

My personal system uses an **AMD GPU with `amdgpu`**.

Because of that, NVIDIA support has never had the same level of direct hardware
testing as the AMD configuration.

The NVIDIA configuration was developed using:

- NixOS configuration and module behavior
- NVIDIA and NixOS documentation
- expected driver compatibility
- build and evaluation testing
- feedback from users with NVIDIA hardware

That remains important context when looking through the history of this branch.

## Issues and Pull Requests

Please do **not** report new NVIDIA problems against this archived
implementation unless the issue is specifically about its historical behavior.

For current NVIDIA support, use the implementation from the **main branch**.

If you encounter a problem there, please open an issue against the current
configuration and include useful information such as:

- GPU model
- NVIDIA generation
- NixOS version
- Kernel version
- NVIDIA driver version
- Selected GPU profile
- Relevant error messages
- `nixos-rebuild` output
- Relevant `journalctl` or kernel logs
- Whether Wayland or X11 is being used
- Any local configuration changes

Pull requests improving the current GPU implementation are also welcome.

## Here Be Dragons

This branch contains experimental and historical NVIDIA work.

Different combinations of:

- GPU generation
- Kernel version
- NVIDIA driver branch
- Open vs proprietary kernel modules
- Wayland
- X11
- Hybrid graphics
- Firmware
- NixOS/nixpkgs revisions

can behave very differently.

If you are browsing this branch for reference, especially the older NVIDIA
configurations:

**Here be dragons.**

Do not assume that code in this branch represents the current recommended
configuration.

## Status

**Archived**

This branch is:

- No longer under active development
- No longer the recommended NVIDIA installation method
- Preserved for historical reference
- Superseded by the GPU profile implementation in `main`

For current NVIDIA support, use the **main branch** and select the appropriate
GPU profile.
