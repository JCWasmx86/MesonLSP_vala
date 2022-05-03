project('mesonlsp', ['c', 'vala'],
	version: '0.1.0',
	meson_version: '>= 0.59.0',
	default_options: ['warning_level=2', 'werror=false'],
)
vapi_dir = meson.current_source_dir() / 'vapi'
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')
# Otherwise VLS would complain about not finding /tmp/vls-meson-.../encode_class_docs
encode_class_docs = executable('encode_class_docs', 'docs/encode_class_docs.vala',
			dependencies: [dependency('glib-2.0'), dependency('gobject-2.0'), dependency('gio-2.0'), dependency('gee-0.8')])
subdir('docs')
subdir('parser')
subdir('src')
