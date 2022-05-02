# Meson LSP

An experimental, *WIP* implementation of a meson language server

## Installation

Only GNOME-Builder is supported at the moment
```
meson build
cd build&&ninja install&&cd ..
mkdir -p ~/.local/share/gnome-builder/plugins
cp plugins/* ~/.local/share/gnome-builder/plugins
```
You may have to tweak the `X-Builder-ABI=43.0` value in plugins/meson_lsp.plugin in order to make it load in Builder

## What works?
	- Navigating by clicking on variables
	- (Partially) List symbols in file
	- (Partially) Include subdirectories
## Issues
	- Memory leak(?)
	- Parsing big projects (E.g. mesa) leads to stuttering
	- After some time it disconnects from GNOME-Builder (Or the other way round)

## TODO-List
	- Hover
	- Fix memory leaks
	- Add documentation for hover
	- Autocompletion
	- Performance improvements
	- Type deduction/linting
	- Make it live together with Vala-Language-Server
	- Improve code quality

## Legal
	- Parser from https://github.com/bearcove/tree-sitter-meson (MIT) with my own changes (JCWasmx86/tree-sitter-meson)
	- Some parts were copied verbatim from src/protocol.vala and src/server.vala from https://github.com/vala-lang/vala-language-server (LGPLv2.1)
