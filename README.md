# NixPii — Testing Branch

> [!WARNING]
> **This is the `testing` branch.**
>
> It is used for active development, refactors, package changes, hardware work,
> and experiments before they are considered stable enough to be merged into
> `main`.
>
> If you want the recommended version of this configuration, use the **`main`
> branch** instead.

## What Is This Branch?

The `testing` branch is the staging area for changes that are not ready to be
treated as the current stable configuration yet.

New work generally lands here first.

That includes things such as:

- GPU changes
- kernel changes
- package updates
- module refactors
- AI / Ollama changes
- Home Manager changes
- desktop changes
- service changes
- hardware support
- experimental configuration
- large dependency changes
- VM testing changes

The general development flow is:

```text
new change
    │
    ▼
 testing
    │
    ├── evaluate
    ├── build
    ├── boot
    ├── test
    └── fix problems
    │
    ▼
stable enough
    │
    ▼
  main
```

`testing` is expected to move faster than `main`.

That also means it may break.

## Use `main` for Normal Installations

For normal use, use:

```text
main
```

The `main` branch contains the configuration I currently consider stable enough
to recommend.

The `testing` branch may contain:

- unfinished work
- partially tested changes
- temporary configuration
- dependency experiments
- broken builds
- hardware changes that have not been tested widely
- commits that may be rewritten or replaced before reaching `main`

If you do not specifically want to help test upcoming changes, you probably want
`main`.

## Branch Status

| Branch    | Status          | Purpose                                                       |
| --------- | --------------- | ------------------------------------------------------------- |
| `main`    | **Recommended** | Current configuration considered stable enough for normal use |
| `testing` | **Development** | Active testing and staging before changes reach `main`        |
| `amd`     | **Archived**    | Historical AMD-specific branch                                |
| `nvidia`  | **Archived**    | Historical NVIDIA-specific branch                             |

The old AMD and NVIDIA branches are no longer part of the normal development
model.

GPU selection now happens through configuration.

## GPU Configuration

GPU support lives directly in the shared configuration.

Available profiles include:

```text
generic
amd
nvidia
nvidia-10series
nvidia-legacy
nouveau
```

For example:

```nix
nixpii.gpu.profile = "amd";
```

or:

```nix
nixpii.gpu.profile = "nvidia";
```

For GTX 10-series / Pascal hardware:

```nix
nixpii.gpu.profile = "nvidia-10series";
```

For older supported NVIDIA hardware:

```nix
nixpii.gpu.profile = "nvidia-legacy";
```

For Nouveau:

```nix
nixpii.gpu.profile = "nouveau";
```

For VM and hardware-neutral testing:

```nix
nixpii.gpu.profile = "generic";
```

GPU choice is configuration, not branch choice.

## Universal GPU Mode

An optional multi-GPU specialisation mode is also available:

```nix
nixpii.gpu.specialisations.enable = true;
```

> [!WARNING]
> This mode substantially increases closure size, build time, and disk usage.
>
> Most users should select one GPU profile instead.

This mode is mainly useful when multiple GPU configurations need to be available
from the bootloader.

## AI / Ollama

AI configuration is handled separately from the GPU profile.

For example:

```nix
nixpii.ai = {
  enable = true;
  acceleration = "cpu";
};
```

ROCm:

```nix
nixpii.ai = {
  enable = true;
  acceleration = "rocm";
};
```

CUDA:

```nix
nixpii.ai = {
  enable = true;
  acceleration = "cuda";
};
```

For lightweight testing:

```nix
nixpii.ai.enable = false;
```

Because this is the testing branch, AI-related options and implementation
details may change before reaching `main`.

## Testing Changes

Before actually switching to a configuration from this branch, build it first.

```bash
sudo nixos-rebuild build --flake .#YOUR_HOSTNAME --show-trace
```

If that succeeds, installing it for the next boot is safer than immediately
switching:

```bash
sudo nixos-rebuild boot --flake .#YOUR_HOSTNAME --show-trace
```

Then reboot and test the new generation.

If everything is working correctly, you can switch normally afterward.

## Flake Checks

Run:

```bash
nix flake check
```

This can catch evaluation and configuration problems.

A successful flake check does **not** guarantee that every hardware-specific
configuration works correctly on physical hardware.

This is especially relevant for:

- NVIDIA drivers
- older GPUs
- Wayland
- kernel changes
- hardware-specific modules

## VM Testing

The configuration can also be tested through a NixOS VM.

For example:

```bash
nix build '.#nixosConfigurations.nixie.config.system.build.vm' -o result
```

Then launch the generated VM from:

```bash
result/bin/
```

The VM should normally use:

```nix
nixpii.gpu.profile = "generic";
```

and may disable heavyweight features such as AI tooling:

```nix
nixpii.ai.enable = false;
```

The VM is intended to answer:

```text
Does the configuration actually boot?
```

It is not intended to reproduce every hardware-specific part of the real
workstation.

## Testing Philosophy

There are two separate things worth testing.

### Full Build

The full configuration answers:

```text
Does the complete system evaluate and build?
```

This catches problems involving:

- packages
- modules
- dependencies
- services
- NixOS options
- system closure

### VM Boot Test

The VM answers:

```text
Does NixOS actually boot?
```

Keeping these separate makes it possible to test basic system bootability
without dragging every heavyweight package or GPU variant into a disposable VM.

## NVIDIA Testing

My personal system uses an **AMD GPU with `amdgpu`**.

Because of that, NVIDIA support does not receive the same amount of direct
physical-hardware testing.

NVIDIA changes are generally checked through:

- NixOS evaluation
- builds
- driver compatibility information
- NixOS/nixpkgs documentation
- VM testing where applicable
- feedback from NVIDIA users

If you are testing this branch on NVIDIA hardware, reports are especially
useful.

## Expect Breakage

This branch exists so that experimental or risky changes do **not** have to land
directly in `main`.

That means breakage is possible.

Changes here may affect:

- boot
- GPU drivers
- Wayland
- packages
- services
- Home Manager
- kernels
- firmware
- desktop sessions
- AI acceleration
- virtualization

Keep a known-good NixOS generation available before testing significant changes.

## Found a Problem?

Please open an issue.

Useful information includes:

- GPU model
- CPU model where relevant
- NixOS / nixpkgs revision
- kernel version
- selected GPU profile
- NVIDIA driver version where applicable
- Wayland or X11
- relevant error messages
- `nixos-rebuild` output
- `journalctl` output
- kernel logs
- the commit you tested
- any local changes you made

If the issue only exists on `testing`, please mention that clearly.

## Contributing

Testing and feedback are welcome.

Pull requests for experimental work may target `testing` first.

Changes that prove stable enough can later be promoted to `main`.

The intended workflow is:

```text
develop
   │
   ▼
testing
   │
   ├── evaluate
   ├── build
   ├── test
   └── receive feedback
   │
   ▼
main
```

## Here Be Dragons

This branch is where the dragons live.

Different combinations of:

- GPU generation
- kernel version
- NVIDIA driver branch
- open vs proprietary NVIDIA modules
- Mesa
- firmware
- Wayland
- X11
- hybrid graphics
- nixpkgs revision
- package updates
- service changes

can behave very differently.

If you are testing older NVIDIA hardware or major kernel/GPU changes in
particular:

**keep a known-good generation available.**

Here be dragons. 🐉

## Status

**Active Development / Testing**

This branch is:

- not the recommended branch for normal use
- allowed to contain experimental work
- expected to change frequently
- used to validate changes before they reach `main`

For the current recommended configuration:

**use `main`.**
