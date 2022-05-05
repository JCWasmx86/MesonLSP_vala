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
- List symbols in file
- Include subdirectories
- Hovering works for the builtin objects
- Hovering over options gives a description of it

## Issues
- Parsing big projects (E.g. mesa) leads to stuttering
- After some time it disconnects from GNOME-Builder (Or the other way round)

## Supported software
- GNOME Builder

## TODO-List
- Hover
- Fix memory leaks
- Add documentation for hover
- Autocompletion
- Performance improvements
- Type deduction/linting
- Make it live together with Vala-Language-Server
- Improve code quality
- Semantic highlighting

## Legal
- Everything I wrote is GPLv3 licensed
- Parser from https://github.com/bearcove/tree-sitter-meson (MIT) with my own changes (JCWasmx86/tree-sitter-meson)
- Some parts were copied verbatim from src/protocol.vala and src/server.vala from https://github.com/vala-lang/vala-language-server (LGPLv2.1)
- docs/methods.txt and docs/objects.txt contain text from the meson documentation [mesonbuild.com](https://mesonbuild.com/), (CC BY-SA 4.0)

## FAQ
### Why Vala?
I had these requirements for the language server:
1. Single small binary (Dynamically linked)
2. Natively compiled
3. Fast compile times
4. Highlevel language
5. Interop with C
Some would consider rust a good candidate, but 4. is a dealbreaker for me,
as fast compile times are needed for my style of development and the final binaries are massive.

C is maybe a bit too low-level for this task.

Python would have allowed reusing the parser from meson itself, but I don't like to use languages that fail at runtime with e.g. a syntax error

Using Java + Lsp4j would have been another solution, it would have a dependency on the JVM, thus a high memory usage. Using GraalVM to AOT-compile this to a native executable would check all marks except the small binary. Furthermore, I found the documentation of Lsp4j a bit sparse.

So my choice fell onto Vala, it checks all marks, the dependencies like glib, gobject json-glib are basically on every Linux desktop.

