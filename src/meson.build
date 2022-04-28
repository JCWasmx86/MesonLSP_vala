mesonlsp_sources = [
	'main.vala',
]

mesonlsp_deps = [
	dependency('glib-2.0'),
	dependency('gobject-2.0'),
	meson.get_compiler('vala').find_library('ts', dirs: vapi_dir),
]

executable('mesonlsp', mesonlsp_sources,
	vala_args: '--target-glib=2.58',  dependencies: mesonlsp_deps,
	install: true,
	include_directories : incdirs,
	link_with: ts_lib
)

