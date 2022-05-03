encode_class_docs = executable('encode_class_docs', 'encode_class_docs.vala', dependencies: [dependency('glib-2.0'), dependency('gobject-2.0'), dependency('gio-2.0')])
objects_c = custom_target('objects.c',
			input: 'objects.txt',
			output: 'objects.c',
			command: [encode_class_docs, '@INPUT0@', '@OUTPUT0@'])
docs_lib = static_library('docs', [objects_c])

