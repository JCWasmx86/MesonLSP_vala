mesonlsp_sources = [
	'ast.vala',
	'main.vala',
	'server.vala',
	'symbol_tree.vala',
	'util.vala',
	'protocol.vala',
	'obj/type_registry.vala'
]

mesonlsp_deps = [
	dependency('glib-2.0'),
	dependency('gobject-2.0'),
	dependency('jsonrpc-glib-1.0'),
	dependency('gee-0.8'),
	dependency('gio-unix-2.0'),
	dependency('gio-2.0'),
	meson.get_compiler('vala').find_library('posix'),
	meson.get_compiler('vala').find_library('ts', dirs: vapi_dir),
]

executable('meson_lsp', mesonlsp_sources,
	vala_args: '--target-glib=2.58',  dependencies: mesonlsp_deps,
	install: true,
	include_directories : incdirs,
	link_with: ts_lib
)
warn (x)
