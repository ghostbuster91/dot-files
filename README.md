# dot-files
`ln -s ~/workspace/dot-files ~/.config/nixpkgs`

Building for the first time:
```sh
nix build .#homeConfigurations.kghost.activationPackage
result/active
```
After that configurations can be switched using:
```sh
home-manager switch --flake path:/home/kghost/workspace/dot-files
```
