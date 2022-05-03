objects_c = custom_target('objects.c',
			input: 'objects.txt',
			output: 'objects.c',
			command: [encode_class_docs, '@INPUT0@', '@OUTPUT0@'])
docs_lib = static_library('docs', [objects_c])

