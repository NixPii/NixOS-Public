# Private Configuration

This directory is the designated place for **private, local, machine-specific,
or user-specific configuration**.

The directory structure and loader files are included in the public flake, so no
additional setup is required after cloning.

```text
private/
├── README.md
├── private.nix
├── home_private.nix
├── nix/
└── home/
```

## NixOS

`private/private.nix` is imported by `configuration.nix`.

It automatically imports every `.nix` file inside:

```text
private/nix/
```

For example:

```text
private/nix/
├── networking.nix
├── services.nix
└── hardware.nix
```

There is no need to manually update `private.nix` when adding modules.

If no `.nix` files are present, the configuration continues normally and prints
a tip explaining where private NixOS modules can be added.

## Home Manager

`private/home_private.nix` is imported by `home.nix`.

It automatically imports every `.nix` file inside:

```text
private/home/
```

For example:

```text
private/home/
├── git.nix
├── ssh.nix
└── programs.nix
```

There is no need to manually update `home_private.nix` when adding modules.

If no `.nix` files are present, the configuration continues normally and prints
a tip explaining where private Home Manager modules can be added.

## Git

The loader files and directory structure are part of the public repository.

Files added by users under `private/nix/` and `private/home/` should remain
untracked.

A suitable `.gitignore` configuration is:

```gitignore
/private/nix/*
!/private/nix/.gitkeep

/private/home/*
!/private/home/.gitkeep
```

The `.gitkeep` files ensure that both directories exist immediately after
cloning, while the loader only considers files ending in `.nix`.

## Example

After cloning the flake, users can simply add their private modules:

```text
private/
├── README.md
├── private.nix
├── home_private.nix
├── nix/
│   ├── .gitkeep
│   ├── networking.nix
│   └── services.nix
└── home/
    ├── .gitkeep
    ├── git.nix
    └── ssh.nix
```

# Private Configuration

This directory is the designated place for **private, local, machine-specific,
or user-specific configuration**.

The directory structure and loader files are included in the public flake, so no
additional setup is required after cloning.

```text
private/
├── README.md
├── private.nix
├── home_private.nix
├── nix/
│   └── .gitkeep
└── home/
    └── .gitkeep
```

## NixOS

`private/private.nix` is imported by `configuration.nix`.

It automatically imports every `.nix` file inside:

```text
private/nix/
```

For example:

```text
private/nix/
├── networking.nix
├── services.nix
└── hardware.nix
```

There is no need to manually update `private.nix` when adding modules.

If no `.nix` files are present, the configuration continues normally and prints
a tip explaining where private NixOS modules can be added.

## Home Manager

`private/home_private.nix` is imported by `home.nix`.

It automatically imports every `.nix` file inside:

```text
private/home/
```

For example:

```text
private/home/
├── git.nix
├── ssh.nix
└── programs.nix
```

There is no need to manually update `home_private.nix` when adding modules.

If no `.nix` files are present, the configuration continues normally and prints
a tip explaining where private Home Manager modules can be added.

## Git

The loader files and directory structure are part of the public repository.

Files added by users under `private/nix/` and `private/home/` should remain
untracked.

A suitable `.gitignore` configuration is:

```gitignore
/private/nix/*
!/private/nix/.gitkeep

/private/home/*
!/private/home/.gitkeep
```

The `.gitkeep` files ensure that both directories exist immediately after
cloning, while the loader only considers files ending in `.nix`.

## Example

After cloning the flake, users can simply add their private modules:

```text
private/
├── README.md
├── private.nix
├── home_private.nix
├── nix/
│   ├── .gitkeep
│   ├── networking.nix
│   └── services.nix
└── home/
    ├── .gitkeep
    ├── git.nix
    └── ssh.nix
```

The new modules are picked up automatically.

## Secrets

This directory keeps private configuration out of the public Git repository, but
**`.gitignore` is not encryption**.

Do not rely on it for plaintext passwords, API keys, SSH private keys, or other
sensitive credentials.

For secrets, consider an encrypted secrets solution such as:

- [`sops-nix`](https://github.com/Mic92/sops-nix)
- [`agenix`](https://github.com/ryantm/agenix) The new modules are picked up
  automatically.
