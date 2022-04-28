incdir = include_directories('include')
incdir1 = include_directories('src')
incdir2 = include_directories('src/unicode')

incdirs = [
	incdir,
	incdir1,
	incdir2,
]
ts_sources = [
	'parser.c',
	'src/alloc.c',
	'src/get_changed_ranges.c',
	'src/language.c',
	'src/lexer.c',
	'src/node.c',
	'src/parser.c',
	'src/query.c',
	'src/stack.c',
	'src/subtree.c',
	'src/tree.c',
	'src/tree_cursor.c'
]
ts_lib = static_library('ts', ts_sources,
	include_directories : incdirs)
