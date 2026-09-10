# NVIDIA Support — WIP

> [!WARNING]
> **This branch is a work in progress.**
>
> This is **NOT the main branch** and should not be treated as the stable/default configuration.
>
> Things may break. Things may be incomplete. Some NVIDIA generations may behave differently than expected.

## About This Branch

This branch exists to add and experiment with NVIDIA support alongside the main AMD-focused configuration.

The current goal is to provide separate NixOS specialisations for different NVIDIA GPU generations, including:

* Modern NVIDIA GPUs using the NVIDIA Open kernel modules
* GTX 10-series / Pascal GPUs
* Older Kepler-based NVIDIA GPUs
* Nouveau as a fallback option

This is still under active development and testing.

Expect rough edges.

## Important: I Use AMDGPU

My personal system uses an **AMD GPU with `amdgpu`**.

Because of that, the AMD configuration is what I actually use and test on my own hardware.

I do **not** currently have NVIDIA hardware available for properly testing every NVIDIA configuration, driver branch, kernel combination, or GPU generation included here.

That means NVIDIA support is largely based on NixOS configuration, documentation, expected driver compatibility, and feedback from people who actually have NVIDIA hardware.

So please do not assume that a configuration being present here means it has been thoroughly tested.

## This Is NOT the Main Branch

Again:

**This is not the main branch.**

If you want the normal/default configuration, use the main branch.

The NVIDIA branch is currently intended for:

* Testing
* Development
* Experimentation
* NVIDIA compatibility work
* People willing to report breakage

If you need something that is known to be stable, this branch probably is not what you want yet.

## Current NVIDIA Specialisations

The configuration currently aims to provide several NVIDIA boot options.

### `nvidia`

For newer NVIDIA GPUs, primarily **Turing and newer**.

Uses the NVIDIA Open kernel modules where supported.

### `nvidia-10series`

Intended for NVIDIA GTX 10-series / Pascal hardware.

Uses the proprietary NVIDIA driver rather than the open kernel modules.

### `nvidia-legacy`

Intended for older NVIDIA GPUs requiring the legacy driver branch, particularly Kepler-era hardware.

### `nvidia-nouveau`

A fallback configuration using the open-source Nouveau driver.

This is primarily intended for recovery, troubleshooting, and basic fallback use.

It is **not intended to be the recommended daily-driver configuration**.

## Testing

Please test changes before actually booting into them.

For example:

```bash
sudo nixos-rebuild build --show-trace
```

For flakes:

```bash
sudo nixos-rebuild build --flake .#YOUR_HOSTNAME --show-trace
```

If the build succeeds, it is generally safer to install the configuration for the next boot:

```bash
sudo nixos-rebuild boot --flake .#YOUR_HOSTNAME --show-trace
```

Then reboot and select the appropriate NVIDIA specialisation from the bootloader.

Do not assume that a successful evaluation guarantees that the NVIDIA driver will work correctly on your particular GPU.

## Found a Problem?

Please **open an issue**.

Seriously.

If you are using NVIDIA hardware and something is broken, your issue report is useful because I cannot reproduce every NVIDIA-specific problem on my AMD system.

When opening an issue, please include as much of the following as possible:

* GPU model
* NVIDIA generation, if known
* NixOS version/channel
* Kernel version
* NVIDIA driver version
* Specialisation used
* Relevant error messages
* Output from `nixos-rebuild` if the build failed
* Relevant `journalctl` or kernel logs if the system booted incorrectly
* Whether Wayland or X11 is being used
* Any changes you made to the configuration

Please include logs as text or in a code block where possible.

## Will It Be Fixed?

Probably.

But **not necessarily immediately**.

This branch is currently secondary to the main AMD configuration, since AMDGPU is what I personally use.

If you open an issue, I will try to investigate it and fix it.

It may just happen **later on** rather than immediately.

Please do not interpret a slow response as the NVIDIA branch being abandoned. It is simply a lower-priority, hardware-dependent part of the project at the moment.

Pull requests are also welcome if you have NVIDIA hardware and know how to fix something.

## Here Be Dragons

The NVIDIA configurations are experimental.

Different combinations of:

* GPU generation
* Kernel version
* NVIDIA driver branch
* Open vs proprietary kernel modules
* Wayland
* X11
* Hybrid graphics
* Firmware
* NixOS/nixpkgs revisions

can produce very different results.

If you're using one of the older NVIDIA specialisations in particular:

**Here be dragons.**

Please have a known-good boot entry available before experimenting.

## Status

**WIP**

NVIDIA:

**Experimental / community testing needed**

Nouveau:

**Fallback / troubleshooting**

This will become more polished as NVIDIA support gets more testing and real-world feedback.

Until then, expect changes.
