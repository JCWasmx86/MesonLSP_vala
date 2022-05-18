encode_class_docs = executable('encode_class_docs', 'encode_class_docs.vala',
			dependencies: [dependency('glib-2.0'), dependency('gobject-2.0'), dependency('gio-2.0'), dependency('gee-0.8')])
encode_method_docs = executable('encode_method_docs', 'encode_method_docs.vala',
			dependencies: [dependency('glib-2.0'), dependency('gobject-2.0'), dependency('gio-2.0'), dependency('gee-0.8')])
generate_type_registry = executable('generate_type_registry', 'generate_type_registry.vala',
			dependencies: [dependency('glib-2.0'), dependency('gobject-2.0'), dependency('gio-2.0'), dependency('gee-0.8'), dependency('json-glib-1.0')])
classes_c = custom_target('objects.c',
			input: 'objects.txt',
			output: 'classes.c',
			command: [encode_class_docs, '@INPUT0@', '@OUTPUT0@'])
methods_c = custom_target('methods.c',
			input: 'methods.txt',
			output: 'methods.c',
			command: [encode_method_docs, '@INPUT0@', '@OUTPUT0@'])
docs_lib = static_library('docs', [classes_c, methods_c])
