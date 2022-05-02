# Meson LSP

An experimental, *WIP* implementation of a meson language server

## What works?
	- Navigating by clicking on variables
	- (Partially) List symbols in file
	- (Partially) Include subdirectories
## Issues
	- Memory leak for each parsed file (But the server crashes so often currently, that it doesn't matter)
	- Parsing big projects (E.g. mesa) leads to stuttering

## TODO-List
	- Hover
	- Fix memory leaks
	- Add documentation for hover
	- Autocompletion
	- Performance improvements
	- Type deduction/linting
	- Make it live together with Vala-Language-Server

## Legal
	- Parser from https://github.com/bearcove/tree-sitter-meson (MIT) with my own changes (JCWasmx86/tree-sitter-meson)
	- Some parts were copied verbatim from src/protocol.vala and src/server.vala from https://github.com/vala-lang/vala-language-server (LGPLv2.1)
