# dot-files

![ci-badge](https://img.shields.io/static/v1?label=Built%20with&message=Garnix&color=blue&style=flat&logo=nixos&link=https://garnix.io&labelColor=111212)

Install nix:
https://nixos.org/manual/nix/stable/installation/installing-binary.html#multi-user-installation

Building for the first time:

```sh
nix build .#homeConfigurations.kghost.activationPackage
result/activate
```

After that configurations can be switched using:

```sh
home-manager switch --flake path:/home/kghost/workspace/dot-files
```
