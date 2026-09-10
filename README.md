
# NixOS Config — Testing Branch 🧪

> [!WARNING]
> **This is the `testing` branch.**
>
> Things here are actively being worked on and may be incomplete, broken,
> untested, or disappear entirely.
>
> If you want the current working version of my configuration, use the
> [`main`](../../tree/main) branch instead. Or the hardware specific `nvidia` or
> `amd` branches.

This repository is the public version of my personal NixOS configuration.

The `testing` branch is where I mess around with new packages, configuration
changes, refactors, hardware changes, and other questionable ideas before they
make it into `main`.

## What to expect

- Work-in-progress configuration
- Stuff that may not evaluate or build
- Temporary/debug code
- Half-finished refactors
- Experimental package and service changes
- Commits that may be rewritten or removed
- General NixOS fuckery :3

If something here breaks, that is very much within spec.

## Repository layout

```text
.
├── extra/              # Miscellaneous fixes / extra configuration
├── hardware-specific/  # GPU and hardware-specific configuration
├── home/               # Home Manager modules
├── programs/           # Programs, packages and application configuration
├── system/             # Core NixOS system configuration
├── theme/              # System-wide theming
├── users/              # User configuration
├── configuration.nix   # Main NixOS configuration
├── flake.nix           # Flake inputs and system definition
├── flake.lock
└── home.nix            # Main Home Manager configuration
```

### DISCLAIMER: THIS README IS NOT FINAL
