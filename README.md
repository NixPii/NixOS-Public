# NVIDIA branch retired — use `main`

> [!IMPORTANT]
> **Please use the [`main` branch](https://github.com/NixPii/NixOS-Public/tree/main), including on NVIDIA systems.**
>
> This branch is retired. It no longer contains a working NixOS configuration
> and will not receive further configuration updates.

**[Go to the current configuration on `main` →](https://github.com/NixPii/NixOS-Public/tree/main)**

The old files were removed intentionally. Leaving an outdated configuration here
made it too easy to mistake this branch for the version NVIDIA users should
install, even with an archive notice at the top.

NVIDIA support now lives in `main`, alongside the other GPU profiles. Maintaining
separate GPU branches meant duplicating configuration and fixes. GPU selection
now happens inside the shared configuration, so a separate NVIDIA branch is no
longer needed.

This branch contains only this README to point people to the right place. The
previous files remain available in Git history for historical reference.

To get the current configuration:

```bash
git clone --branch main https://github.com/NixPii/NixOS-Public.git
```

Follow the [README on `main`](https://github.com/NixPii/NixOS-Public/blob/main/README.md)
for setup, and select the appropriate
[GPU profile](https://github.com/NixPii/NixOS-Public/blob/main/modules/gpu.nix)
for your hardware before rebuilding. Preserve your own hardware configuration
and private settings when migrating.

If a script, bookmark, or flake reference still points to `nvidia`, update it to
`main`.

Thank you for understanding!
