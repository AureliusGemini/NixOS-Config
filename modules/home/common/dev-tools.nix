# Language servers & linters shared by desktop + WSL.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd # Nix LSP
    nixfmt # Nix formatter
    bash-language-server
    shellcheck
    clang-tools # C/C++ (clangd)
    pyright # Python LSP
    typescript-language-server # JS/TS LSP
    dart # Dart/Flutter LSP
    omnisharp-roslyn # C# (.NET / Unity)
  ];
}
