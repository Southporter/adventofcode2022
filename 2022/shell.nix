{ pkgs ? import <nixpkgs>{}, ...}:

pkgs.mkShell {
  buildInputs = [
    pkgs.clojure
    pkgs.clojure-lsp
    pkgs.clj-kondo
    pkgs.tree-sitter-grammars.tree-sitter-clojure

    pkgs.python311
  ];
}
