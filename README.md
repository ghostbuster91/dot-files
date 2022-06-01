# dot-files

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
