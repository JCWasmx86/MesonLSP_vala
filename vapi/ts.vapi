[CCode (cheader_filename = "tree_sitter/api.h,tree_sitter/parser.h")]
namespace TreeSitter {
	[CCode (cname = "tree_sitter_meson")]
	public static TSLanguage tree_sitter_meson ();

	[Compact]
	[CCode (has_type_id = false, cname = "TSLanguage", free_function = "")]
	public class TSLanguage {

	}

	[Compact]
	[CCode (has_type_id = false, cname = "TSParser", free_function = "ts_parser_delete")]
	public class TSParser {
		[CCode (cname = "ts_parser_new")]
		public TSParser ();

		[CCode (cname = "ts_parser_set_language")]
		public void set_language (TSLanguage tsl);

		[CCode (cname = "ts_parser_parse_string")]
		public TSTree parse_string (TSTree? old_tree, string s, uint32 length);
	}

	[Compact]
	[CCode (has_type_id = false, cname = "TSTree", free_function = "ts_tree_delete")]
	public class TSTree {
		[CCode (cname = "ts_tree_root_node")]
		public TSNode root_node ();
	}

	[SimpleType]
	[CCode (has_type_id = false, cname = "TSNode", free_function = "")]
	public struct TSNode {
		[CCode (cname = "ts_node_named_child")]
		public TSNode named_child (uint index);

		[CCode (cname = "ts_node_type")]
		public unowned string type ();

		[CCode (cname = "ts_node_string")]
		public string to_string ();
	}
}
