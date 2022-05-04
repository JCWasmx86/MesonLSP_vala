classes_c = custom_target('objects.c',
			input: 'objects.txt',
			output: 'classes.c',
			command: [encode_class_docs, '@INPUT0@', '@OUTPUT0@'])
methods_c = custom_target('methods.c',
			input: 'methods.txt',
			output: 'methods.c',
			command: [encode_method_docs, '@INPUT0@', '@OUTPUT0@'])
docs_lib = static_library('docs', [classes_c, methods_c])
