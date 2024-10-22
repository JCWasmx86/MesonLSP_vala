# **⚠️See [here](https://github.com/JCWasmx86/Swift-MesonLSP) for a rewrite⚠️**























# Meson LSP

An experimental, *WIP* implementation of a meson language server


## Dependencies

- glib-2.0
- gobject-2.0
- jsonrpc-glib-1.0
- gee-0.8
- gio-unix-2.0
- gio-2.0
- vala

## Installation

Only GNOME-Builder is supported at the moment.
```
meson build
cd build&&ninja install&&cd ..
```
Install the meson plugin from [here](https://github.com/JCWasmx86/GNOME-Builder-Plugins)

## What works?
- Navigating by clicking on variables
- List symbols in file
- Include subdirectories
- Hovering works for the builtin objects
- Hovering over options gives a description of it

## Status
### Issues:
- Parsing big projects (E.g. mesa) leads to stuttering
- After some time it disconnects from GNOME-Builder (Or the other way round)

### Supported software
- GNOME Builder (See https://github.com/JCWasmx86/GNOME-Builder-Plugins/)

## TODO-List
- Hover (Partially)
- Fix memory leaks
- Add documentation for hover
- Autocompletion
- Performance improvements
- Type deduction/linting (WIP)
- Make it live together with Vala-Language-Server (Will work in GTK4-Port of GNOME-Builder)
- Improve code quality
- Semantic highlighting

## Legal
- Everything I wrote is GPLv3 licensed
- Parser from https://github.com/bearcove/tree-sitter-meson (MIT) with my own changes (JCWasmx86/tree-sitter-meson)
- Some parts were copied verbatim from src/protocol.vala and src/server.vala from https://github.com/vala-lang/vala-language-server (LGPLv2.1)
- docs/methods.txt and docs/objects.txt contain text from the meson documentation [mesonbuild.com](https://mesonbuild.com/), (CC BY-SA 4.0)
- parser/src is code copied verbatim from [tree-sitter/tree-sitter](https://github.com/tree-sitter/tree-sitter) (MIT)
