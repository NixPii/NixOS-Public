# NixPii — NixOS Configuration

My public NixOS configuration and flake.

> [!IMPORTANT]
> **`main` is the current and recommended branch.**
>
> Changes and larger refactors are developed on the `testing` branch first. Once
> they are working well enough to be considered stable, they are merged into
> `main`.
>
> The old `amd` and `nvidia` branches are archived. GPU selection is now handled
> directly through configuration in `main`.

## About This Repository

This repository is the public version of my personal NixOS configuration.

It includes my:

- NixOS system configuration
- Home Manager configuration
- GPU configuration
- AI / local LLM configuration
- development environment
- gaming setup
- desktop applications
- services
- theming
- Flatpak configuration
- user configuration
- virtualization setup
- miscellaneous fixes and tweaks

This is a fairly large configuration because it reflects an actual
desktop/workstation setup rather than a minimal NixOS example.

## Branches

### `main`

**Recommended branch.**

This contains the current version of the configuration that I consider stable
enough for normal use.

Major changes are tested elsewhere before being merged here.

If you just want to use the configuration:

**Use `main`.**

### `testing`

Development and staging branch.

New features, package changes, hardware changes, module refactors, and other
experiments generally happen here first.

The basic workflow is:

```text
new change
    │
    ▼
 testing
    │
    │ build / evaluate / boot / test
    ▼
stable enough
    │
    ▼
  main
```

The `testing` branch may therefore be ahead of `main`, but it may also contain
incomplete or experimental work.

If you want the current recommended configuration, use `main`.

### `amd`

**Archived.**

This branch was previously used for the AMD-focused version of the
configuration.

It is retained only for historical reference.

AMD support now lives in `main` and is selected with:

```nix
nixpii.gpu.profile = "amd";
```

### `nvidia`

**Archived.**

This branch was previously used to develop and experiment with NVIDIA support.

It is retained only for historical reference.

NVIDIA support now lives directly in `main`.

For example:

```nix
nixpii.gpu.profile = "nvidia";
```

Separate AMD and NVIDIA Git branches are no longer necessary.

---

# GPU Configuration

One of the largest changes introduced during the old `testing` work was
replacing the hardware-specific branch model with a proper GPU module.

Previously, the rough idea was:

```text
AMD user    -> AMD branch
NVIDIA user -> NVIDIA branch
```

That has been replaced with:

```text
             main
              │
     nixpii.gpu.profile
              │
 ┌────────────┼────────────┐
 ▼            ▼            ▼
AMD        NVIDIA       Generic
              │
     ┌────────┼─────────┐
     ▼        ▼         ▼
  modern   10-series   legacy
```

All supported GPU configurations now live together.

Users select the appropriate implementation through NixOS configuration rather
than by changing Git branches.

## Available GPU Profiles

GPU selection is controlled with:

```nix
nixpii.gpu.profile = "...";
```

Available profiles are:

```text
generic
amd
nvidia
nvidia-10series
nvidia-legacy
nouveau
```

For a normal installation, select **one**.

## Generic

```nix
nixpii.gpu.profile = "generic";
```

No vendor-specific GPU configuration is applied.

This is useful for:

- virtual machines
- testing
- Intel graphics
- systems where the normal kernel/Mesa defaults are sufficient
- configurations providing their own GPU-specific setup

`generic` is what I use for VM smoke testing.

## AMD

```nix
nixpii.gpu.profile = "amd";
```

Uses the `amdgpu` driver and enables the AMD-specific graphics configuration.

The profile currently includes support for things such as:

- `amdgpu`
- OpenCL
- AMDGPU overdrive
- ROCm support

My personal system uses an AMD GPU, so AMD is the configuration I can test most
directly on physical hardware.

## NVIDIA

```nix
nixpii.gpu.profile = "nvidia";
```

Intended for modern NVIDIA GPUs, primarily Turing and newer hardware.

This profile uses the current NVIDIA driver configuration with the NVIDIA Open
kernel modules.

## NVIDIA GTX 10-Series / Pascal

```nix
nixpii.gpu.profile = "nvidia-10series";
```

Intended for GTX 10-series / Pascal hardware.

This profile uses the proprietary NVIDIA kernel module rather than the newer
open kernel module configuration.

It also uses the kernel/driver combination required by that legacy driver
branch.

## NVIDIA Legacy

```nix
nixpii.gpu.profile = "nvidia-legacy";
```

Intended for older NVIDIA hardware, particularly Kepler-era GTX 600/700-series
GPUs supported by the legacy driver configuration.

Older NVIDIA hardware can be sensitive to combinations of:

- GPU generation
- kernel version
- NVIDIA driver branch
- nixpkgs revision
- Wayland
- X11

Keep a known-good boot generation available when experimenting with older
hardware.

## Nouveau

```nix
nixpii.gpu.profile = "nouveau";
```

Uses the open-source Nouveau driver.

This is primarily intended as:

- a fallback
- a recovery option
- a troubleshooting option
- a basic open-source NVIDIA configuration

It is not necessarily the recommended daily-driver configuration for NVIDIA
hardware.

---

# Universal GPU Specialisations

There is also an optional universal GPU mode:

```nix
nixpii.gpu.specialisations.enable = true;
```

This exists for situations where the target GPU is not known ahead of time or
where several GPU configurations need to be available from the bootloader.

In this mode, AMD is used as the default configuration and additional NVIDIA
configurations are provided as NixOS specialisations.

The resulting boot options include configurations for:

- AMD
- modern NVIDIA
- NVIDIA 10-series / Pascal
- NVIDIA legacy
- Nouveau

> [!WARNING]
> **Universal GPU mode substantially increases closure size, build time, and
> disk usage.**
>
> Most users should not enable it.
>
> For a normal installation, select one GPU profile instead.

Example:

```nix
nixpii.gpu.profile = "amd";
```

rather than:

```nix
nixpii.gpu.specialisations.enable = true;
```

unless you actually need all of the GPU variants.

---

# NVIDIA Testing

My personal system uses an **AMD GPU with `amdgpu`**.

Because of that, NVIDIA configurations cannot receive the same level of direct
physical-hardware testing as the AMD profile.

NVIDIA support is developed and checked using:

- NixOS/nixpkgs configuration behavior
- NVIDIA compatibility information
- NixOS documentation
- evaluation and build testing
- VM testing where applicable
- reports from people using NVIDIA hardware

A successful NixOS build does **not** guarantee that a particular NVIDIA GPU and
driver combination will behave correctly on real hardware.

If you use NVIDIA hardware, bug reports and pull requests are especially useful.

---

# AI / Local LLM Configuration

AI tooling has been separated into its own module rather than being tied
directly to the GPU configuration.

This is important because:

```text
GPU used by the desktop
        ≠
acceleration backend used by Ollama
```

AI tooling is controlled through:

```nix
nixpii.ai.enable = true;
```

The available Ollama acceleration backends are:

```text
cpu
rocm
cuda
```

## CPU

```nix
nixpii.ai = {
  enable = true;
  acceleration = "cpu";
};
```

Uses the standard Ollama package without a GPU-specific acceleration backend.

## AMD ROCm

```nix
nixpii.ai = {
  enable = true;
  acceleration = "rocm";
};
```

Uses the ROCm-enabled Ollama package.

Optional AMD-specific overrides are also available.

For example:

```nix
nixpii.ai = {
  enable = true;
  acceleration = "rocm";

  rocm.overrideGfx = "11.0.0";
};
```

And, if required by the GPU:

```nix
nixpii.ai.rocm.hccAmdgpuTarget = "gfx1100";
```

These overrides should normally be left unset unless the hardware specifically
requires them.

## NVIDIA CUDA

```nix
nixpii.ai = {
  enable = true;
  acceleration = "cuda";
};
```

Uses the CUDA-enabled Ollama package.

## Additional AI Tools

The AI module can also control additional software such as:

- OpenCode
- OpenCode Desktop
- Open WebUI

OpenCode and OpenCode Desktop are enabled by default when the AI module is
enabled.

Open WebUI is optional.

For example:

```nix
nixpii.ai = {
  enable = true;
  acceleration = "rocm";

  opencode.enable = true;
  opencodeDesktop.enable = true;
  openWebUI.enable = false;
};
```

For lightweight VM testing, AI tooling can simply be disabled:

```nix
nixpii.ai.enable = false;
```

---

# Why the Configuration Is Large

This is **not** intended to be a minimal NixOS configuration.

The system includes a large collection of software for things such as:

- software development
- IDEs and editors
- Android development
- gaming
- Wine
- virtualization
- browsers
- multimedia
- security tooling
- AI tooling
- Java development
- LLVM / Clang
- desktop applications
- Flatpak applications

As a result, the system closure is large.

During development, the generic configuration was measured at approximately:

```text
~60 GiB
```

The older configuration containing every GPU specialisation was around:

```text
~70 GiB
```

This does not necessarily indicate that something is wrong.

The configuration simply contains a lot of software.

---

# Disk Images

At one point, a raw disk image built from the full configuration reached
approximately:

```text
~100 GB
```

Very large disk images can also behave poorly with the NixOS image-building
process and tools such as `cptofs`.

Because of this, a giant raw disk image is **not** the preferred smoke test for
this repository.

The project instead uses a combination of:

```text
full system build
        +
lightweight VM boot test
```

---

# Testing

Before switching to a new configuration, build it first.

For flakes:

```bash
sudo nixos-rebuild build --flake .#YOUR_HOSTNAME --show-trace
```

If the build succeeds, you can install it for the next boot:

```bash
sudo nixos-rebuild boot --flake .#YOUR_HOSTNAME --show-trace
```

Or switch immediately:

```bash
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME --show-trace
```

For major GPU or kernel changes, using `boot` first can be safer than
immediately using `switch`.

---

# Flake Checks

Run:

```bash
nix flake check
```

A successful check is useful for catching evaluation and configuration problems.

It does **not** prove that every hardware-specific configuration will work
correctly on physical hardware.

That is particularly important for GPU drivers.

---

# VM Testing

The repository can also be built as a NixOS VM.

For the included `nixie` configuration:

```bash
nix build '.#nixosConfigurations.nixie.config.system.build.vm' -o result
```

The generated VM launcher should appear under:

```bash
result/bin/
```

For example:

```bash
ls -l result/bin
```

Then run the generated VM launcher.

The test configuration uses the generic GPU profile rather than pulling in a
vendor-specific GPU stack:

```nix
nixpii.gpu.profile = "generic";
```

AI tooling can also be disabled for the VM:

```nix
nixpii.ai.enable = false;
```

The purpose of the VM is not to reproduce every aspect of the physical
workstation.

It answers a much simpler question:

```text
Does the NixOS configuration actually boot?
```

---

# Testing Philosophy

There are two useful levels of testing.

## Full Configuration Build

The full system build answers:

```text
Does the real configuration evaluate and build?
```

This catches problems involving:

- packages
- services
- NixOS options
- module evaluation
- dependencies
- the overall system closure

## VM Boot Test

The lightweight VM answers:

```text
Does NixOS actually boot?
```

The VM does not need every GPU implementation or every hardware-specific feature
merely to prove basic bootability.

Keeping these tests separate makes development significantly more practical.

---

# Development Workflow

Larger changes should generally go through `testing` before reaching `main`.

Conceptually:

```text
feature / refactor / package update
              │
              ▼
           testing
              │
       ┌──────┴──────┐
       │             │
    evaluate       build
       │             │
       └──────┬──────┘
              │
           VM test
              │
              ▼
        stable enough?
              │
             yes
              │
              ▼
            main
```

`testing` is allowed to be messy.

`main` should represent the configuration I am comfortable recommending.

This does **not** mean every possible hardware combination has been physically
tested.

It means changes have passed enough evaluation, build, and practical testing to
move out of the development branch.

---

# Repository Layout

The repository is split into modules based on responsibility.

```text
.
├── extra/              # Miscellaneous fixes and additional configuration
├── home/               # Home Manager configuration
├── modules/            # Reusable project modules
│   ├── ai.nix          # AI / Ollama configuration
│   └── gpu.nix         # GPU profiles and specialisations
├── programs/           # Applications, packages, gaming, development, etc.
├── system/             # Core NixOS system configuration
├── theme/              # System-wide theming
├── users/              # User configuration
├── configuration.nix   # Main NixOS configuration
├── flake.nix           # Flake inputs and NixOS system definition
├── flake.lock
└── home.nix            # Main Home Manager configuration
```

---

# Machine-Specific Configuration

Some parts of a NixOS system are inherently machine-specific.

Examples include:

- root filesystem
- disks and filesystem UUIDs
- hardware configuration
- GPU selection
- host-specific kernel modules
- user credentials

Reusable modules should avoid unnecessarily hardcoding those details.

The long-term structure is roughly:

```text
shared configuration
        │
        ├── real machine
        │      ├── real hardware
        │      ├── real filesystem
        │      └── selected GPU
        │
        └── VM / test system
               ├── generic GPU
               ├── test filesystem
               └── VM overrides
```

---

# Passwords and Secrets

This is a **public repository**.

Do not put real passwords, tokens, API keys, private keys, or other secrets
directly into the public configuration.

Disposable VM configurations may use known test credentials when those
credentials apply only to the disposable VM.

Real installations should configure their own credentials securely.

---

# Migrating From the Old AMD Branch

The AMD branch is archived.

You no longer need to use a separate branch for AMD hardware.

Use `main` and configure:

```nix
nixpii.gpu.profile = "amd";
```

Current AMD fixes and improvements should target `main`.

---

# Migrating From the Old NVIDIA Branch

The NVIDIA branch is archived.

You no longer need to switch to a separate NVIDIA branch.

Use `main` and select the profile appropriate for your GPU.

Modern NVIDIA:

```nix
nixpii.gpu.profile = "nvidia";
```

GTX 10-series / Pascal:

```nix
nixpii.gpu.profile = "nvidia-10series";
```

Legacy NVIDIA:

```nix
nixpii.gpu.profile = "nvidia-legacy";
```

Nouveau fallback:

```nix
nixpii.gpu.profile = "nouveau";
```

GPU choice is now configuration, not branch choice.

---

# Found a Problem?

Please open an issue.

For general NixOS problems, useful information includes:

- NixOS / nixpkgs revision
- kernel version
- configuration being built
- relevant error messages
- `nixos-rebuild` output
- relevant `journalctl` output
- any local changes you made

For GPU problems, please also include:

- GPU model
- GPU generation, if known
- selected `nixpii.gpu.profile`
- NVIDIA driver version, where applicable
- whether you are using Wayland or X11
- whether the problem occurs during build, boot, login, or normal desktop use

Please include logs as text or code blocks where possible.

---

# Contributing

Issues and pull requests are welcome.

Hardware-specific feedback is especially useful for configurations I cannot test
directly.

In particular, if you have NVIDIA hardware and discover that one of the GPU
profiles requires changes for your GPU generation, please provide as much
hardware and diagnostic information as possible.

Changes intended for normal use should eventually target `main`.

Larger experimental changes may be better tested through `testing` first.

---

# Here Be Dragons

This is a large personal NixOS configuration.

Some combinations of hardware and software can behave very differently depending
on:

- GPU generation
- kernel version
- NVIDIA driver branch
- NVIDIA open vs proprietary kernel modules
- Mesa
- firmware
- Wayland
- X11
- hybrid graphics
- nixpkgs revision

Older NVIDIA hardware in particular can require very specific combinations.

Before experimenting with major GPU, driver, bootloader, or kernel changes:

**keep a known-good NixOS generation available.**

Here be dragons. 🐉

---

# Status

| Branch    | Status                   | Purpose                                                       |
| --------- | ------------------------ | ------------------------------------------------------------- |
| `main`    | **Active / Recommended** | Current configuration considered stable enough for normal use |
| `testing` | **Development**          | Staging area for changes before they reach `main`             |
| `amd`     | **Archived**             | Historical AMD-specific configuration                         |
| `nvidia`  | **Archived**             | Historical NVIDIA development configuration                   |

## TL;DR

For normal use:

**Use `main`.**

Choose your GPU through configuration:

```nix
nixpii.gpu.profile = "amd";
```

or:

```nix
nixpii.gpu.profile = "nvidia";
```

Use `testing` if you intentionally want to follow development work before it is
promoted to `main`.

The old AMD and NVIDIA branches are archives.

**Hardware choice belongs in the configuration, not in the Git branch.**
