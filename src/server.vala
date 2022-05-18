/* server.vala
 *
 * Copyright 2022 JCWasmx86 <JCWasmx86@t-online.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
namespace Meson {
	public class MesonLsp : Jsonrpc.Server {
		Uri base_uri;
		SymbolTree? tree;
		TypeRegistry tr;
		MainLoop loop;
		SourceFile? ast;
		Gee.HashMap<string, MesonOption> options;

		internal MesonLsp (MainLoop l) {
			this.loop = l;
			this.tr = new TypeRegistry ();
			tr.init ();
			this.options = new Gee.HashMap<string, MesonOption> ();
			try {
				Meson.DocPopulator.populate_docs (tr);
			} catch (Error e) {
				error ("Meson::DocPopulator failed (SHOULD NEVER HAPPEN!): %s ", e.message);
			}
		}

		protected override void notification (Jsonrpc.Client client, string method, Variant parameters) {
			info ("Received notification %s", method);
			switch (method) {
			case "textDocument/didChange":
				this.did_change (client, parameters);
				break;
			case "textDocument/didSave":
				this.did_save (client, parameters);
				break;
			}
		}

		protected override bool handle_call (Jsonrpc.Client client, string method, Variant id, Variant parameters) {
			info ("Received call %s", method);
			try {
				switch (method) {
				case "initialize":
					this.initialize (client, id, parameters);
					break;
				case "textDocument/documentSymbol":
					this.document_symbol (client, id, parameters);
					break;
				case "textDocument/definition":
					this.definition (client, id, parameters);
					break;
				case "textDocument/hover":
					this.hover (client, id, parameters);
					break;
				}
			} catch (Error e) {
				client.reply_error_async (id, Jsonrpc.ClientError.INTERNAL_ERROR, "Error: %s".printf (e.message), null);
				return false;
			}
			return true;
		}

		void hover (Jsonrpc.Client client, Variant id, Variant params) throws Error {
			var p = Util.parse_variant<TextDocumentPositionParams> (@params);
			var ctx = new HoverContext ();
			ctx.options = this.options;
			var start = GLib.get_real_time () / 1000.0;
			var h = this.ast.hover (this.tr, File.new_for_path (Uri.parse (p.textDocument.uri, UriFlags.NONE).get_path ()).get_path (), p.position, ctx);
			var end = GLib.get_real_time () / 1000.0;
			info ("Searched tree for textDocment/hover in %lfms", (end - start));
			if (h == null) {
				info ("Nothing found for hovering");
				client.reply (id, null);
				return;
			}
			info ("Found something for hovering");
			client.reply (id, Util.object_to_variant (h));
		}

		void did_change (Jsonrpc.Client client, Variant @params) {
			var document = @params.lookup_value ("textDocument", VariantType.VARDICT);
			var changes = @params.lookup_value ("contentChanges", VariantType.ARRAY);
			var uri = (string) document.lookup_value ("uri", VariantType.STRING);
			var iter = changes.iterator ();
			var elem = iter.next_value ();
			if (elem == null) {
				info ("No changes given!");
				return;
			} else if (iter.next_value () != null) {
				info ("Only one big change is supported (The whole file)");
				return;
			}
			var ce = Util.parse_variant<TextDocumentContentChangeEvent> (elem);
			var patches = new Gee.HashMap<string, string>();
			patches.set_all (this.tree.patches);
			// Override other changes
			patches[uri] = ce.text + "\n\n\n";
			this.load_tree (client, this.base_uri, patches);
		}

		void did_save (Jsonrpc.Client client, Variant @params) {
			var document = @params.lookup_value ("textDocument", VariantType.VARDICT);
			var uri = (string) document.lookup_value ("uri", VariantType.STRING);
			var patches = new Gee.HashMap<string, string>();
			patches.set_all (this.tree.patches);
			patches.unset (uri);
			this.load_tree (client, this.base_uri, patches);
		}

		void initialize (Jsonrpc.Client client, Variant id, Variant @params) throws Error {
			var init = Util.parse_variant<InitializeParams> (@params);
			this.base_uri = Uri.parse (init.rootUri, UriFlags.NONE);
			this.load_tree (client, this.base_uri);
			client.reply (id, build_dict (
							  capabilities: build_dict (
								  textDocumentSync: new Variant.int32 (1 /* Full*/),
								  documentSymbolProvider: new Variant.boolean (true),
								  hoverProvider: new Variant.boolean (true),
								  documentHighlightProvider: new Variant.boolean (true)
							  ),
							  serverInfo: build_dict (
								  name: new Variant.string ("Meson Language Server"),
								  version: new Variant.string ("0.0.1-alpha")
							  )
			));
		}

		public void definition (Jsonrpc.Client client, Variant id, Variant @params) throws Error {
			var p = Util.parse_variant<TextDocumentPositionParams> (@params);
			var start = GLib.get_real_time () / 1000.0;
			// First find the identifier to look for
			var symbol_name = this.ast.find_identifier (p.get_file (), p.position);
			if (symbol_name == null) {
				var subdir_location = this.ast.jump_to_subdir (p.get_file (), p.position);
				if (subdir_location != null) {
					var location = new Location ();
					location.uri = File.new_for_path (subdir_location).get_uri ();
					location.range = new Range () {
						start = new Position () {
							line = 0,
							character = 0
						},
						end = new Position () {
							line = 0,
							character = 1
						}
					};
					client.reply (id, Util.object_to_variant (location));
				} else {
					client.reply (id, null);
				}
				return;
			}
			info ("Found symbol at location: %s", symbol_name);
			var found = this.ast.find_symbol (symbol_name);
			if (found.is_empty) {
				client.reply (id, null);
				return;
			}
			found.sort ((a, b) => {
				var pf = p.get_file ();
				if (a.sref.file == pf) {
					if (a.sref.start_line > p.position.line)
						return 1;
				}
				if (b.sref.file == pf) {
					if (b.sref.start_line > p.position.line)
						return 1;
				}
				if (a.sref.file == b.sref.file && a.sref.file == pf) {
					var l_diff_a = p.position.line - a.sref.start_line;
					var l_diff_b = p.position.line - b.sref.start_line;
					if (l_diff_a == l_diff_b)
						return 0;
					return l_diff_a < l_diff_b ? -1 : 1;
				}
				if (a.sref.file == pf)
					return -1;
				if (b.sref.file == pf)
					return 1;
				return 0;
			});
			var end = GLib.get_real_time () / 1000.0;
			info ("Searched tree for textDocment/definition in %lfms", (end - start));
			var first_good = found[0];
			info ("Found good reference: %s (%u %u)", first_good.sref.file, first_good.sref.start_line, first_good.sref.start_column);
			var location = new Location ();
			location.uri = File.new_for_path (first_good.sref.file).get_uri ();
			location.range = new Range () {
				start = new Position () {
					line = first_good.sref.start_line,
					character = first_good.sref.start_column
				},
				end = new Position () {
					line = first_good.sref.end_line,
					character = first_good.sref.end_column
				}
			};
			client.reply (id, Util.object_to_variant (location));
		}

		public void document_symbol (Jsonrpc.Client client, Variant id, Variant @params) throws Error {
			var p = Util.parse_variant<TextDocumentPositionParams> (@params);
			var syms = new Gee.ArrayList<DocumentSymbol>();
			var start = GLib.get_real_time () / 1000.0;
			this.ast.document_symbols (File.new_for_path (Uri.parse (p.textDocument.uri, UriFlags.NONE).get_path ()).get_path (), syms);
			var end = GLib.get_real_time () / 1000.0;
			info ("Searched tree for textDocment/documentSymbol in %lfms", (end - start));
			var array = new Json.Array ();
			array.ref ();
			foreach (var sym in syms)
				array.add_element (Json.gobject_serialize (sym));
			var ret = Json.gvariant_deserialize (new Json.Node.alloc ().init_array (array), null);
			client.reply (id, ret);
		}

		internal void load_tree (Jsonrpc.Client client, Uri dir, Gee.HashMap<string, string> patches = new Gee.HashMap<string, string>()) throws GLib.Error {
			if (this.tree != null && this.tree.child_files != null) {
				foreach (var file in this.tree.child_files) {
					var uri = Uri.parse (File.new_for_path (file).get_uri (), UriFlags.NONE);
					var diags = new Variant.array (VariantType.VARIANT, new Variant[] {});
					client.send_notification ("textDocument/publishDiagnostics",
											  build_dict (
												  uri: new Variant.string (uri.to_string ()),
												  diagnostics: diags
					));
				}
			}
			if (!File.new_for_path (dir.get_path () + "/meson.build").query_exists ()) {
				info ("No meson");
				return;
			}
			this.options.clear ();
			var start = GLib.get_real_time () / 1000.0;
			this.tree = SymbolTree.build (dir, patches);
			this.ast = this.tree.merge ();
			var end = GLib.get_real_time () / 1000.0;
			info ("Built tree in %lfms", (end - start));
			var diagnostics = new Gee.ArrayList<Diagnostic>();
			var env = new MesonEnv (this.tr);
			var hash_map = new Gee.HashMap<string, Gee.List<Diagnostic> >();
			foreach (var diagnostic in diagnostics) {
				var file = diagnostic.file;
				if (hash_map.has_key (file)) {
					hash_map[file].add (diagnostic);
				} else {
					hash_map.set (file, new Gee.ArrayList<Diagnostic>());
					hash_map[file].add (diagnostic);
				}
			}
			foreach (var entry in hash_map) {
				var key = entry.key;
				var v = entry.value;
				var uri = Uri.parse (key, UriFlags.NONE).to_string ();
				info ("Publishing %u diagnostics for %s", v.size, uri);
				var arr = new Json.Array ();
				foreach (var d in v) {
					arr.add_element (Json.gobject_serialize (d));
				}
				client.send_notification (
					"textDocument/publishDiagnostics",
					build_dict (
						uri: new Variant.string (uri),
						diagnostics: Json.gvariant_deserialize (new Json.Node.alloc ().init_array (arr), null)
				));
			}
			this.ast.fill_diagnostics (env, diagnostics);
			var file = this.base_uri.get_path () + "/meson_options.txt";
			var f = File.new_for_path (file);
			if (!f.query_exists ())
				return;
			var parser = new TreeSitter.TSParser ();
			parser.set_language (TreeSitter.tree_sitter_meson ());
			var data = "";
			size_t data_len = 0;
			FileUtils.get_contents (file, out data, out data_len);
			data += "\n\n";
			data_len += 2;
			var tree = parser.parse_string (null, data, (uint32) data_len);
			if (tree == null)
				return;
			var root = tree.root_node ();
			var build_def = root.named_child (0);
			if (build_def.type () != "build_definition") {
				tree.free ();
				return;
			}
			for (var i = 0; i < build_def.named_child_count (); i++) {
				var stmt = build_def.named_child (i);
				if (stmt.type () != "statement" || stmt.named_child_count () == 0)
					continue;
				var expr = stmt.named_child (0);
				if (expr.type () != "expression" || expr.named_child_count () == 0)
					continue;
				var fe = expr.named_child (0);
				if (fe.type () != "function_expression" || fe.named_child_count () == 0)
					continue;
				var function_id = fe.named_child (0);
				var f_name = Util.get_string_value (data, function_id);
				if (f_name != "option")
					continue;
				var arg_list = fe.named_child (1);
				string option_name = null;
				string description = null;
				string type = null;
				for (var j = 0; j < arg_list.child_count (); j++) {
					var arg = arg_list.child (j);
					if (arg.type () == "expression") {
						var sl = arg.named_child (0);
						if (sl.type () != "string_literal")
							continue;
						option_name = Util.get_string_value (data, sl);
						// Remove "'"
						while (option_name.has_prefix ("'"))
							option_name = option_name.substring (1, option_name.length - 2);
					} else if (arg.type () == "keyword_item") {
						var key = arg.named_child (0);
						var n = Util.get_string_value (data, key);
						if (n != "type" && n != "description")
							continue;
						var val = Util.get_string_value (data, arg.named_child (1));
						while (val.has_prefix ("'"))
							val = val.substring (1, val.length - 2);
						if (n == "type")
							type = val;
						else
							description = val;
					}
				}
				if (option_name == null || type == null)
					continue;
				info ("Found option %s of type %s", option_name, type);
				var option = new MesonOption ();
				option.type = type;
				option.description = description;
				this.options.set (option_name, option);
			}
			this.register_option ("prefix", "string", "Installation prefix");
			this.register_option ("bindir", "string", "Executable directory");
			this.register_option ("datadir", "string", " Data file directory");
			this.register_option ("includedir", "string", "Header file directory");
			this.register_option ("infodir", "string", " Info page directory");
			this.register_option ("libdir", "string", "Library directory");
			this.register_option ("libexecdir", "string", " Library executable directory");
			this.register_option ("localedir", "string", "Locale data directory");
			this.register_option ("localstatedir", "string", " Localstate data directory");
			this.register_option ("mandir", "string", "Manual page directory");
			this.register_option ("sbindir", "string", "System executable directory");
			this.register_option ("sharedstatedir", "string", " Architecture-independent data directory");
			this.register_option ("sysconfdir", "string", " Sysconf data directory");
			this.register_option ("auto_features", "combo", " Override value of all 'auto' features");
			this.register_option ("backend", "combo", "Backend to use");
			this.register_option ("buildtype", "combo", "Build type to use");
			this.register_option ("debug", "boolean", " Enable debug symbols and other information");
			this.register_option ("default_library", "combo", "Default library type");
			this.register_option ("errorlogs", "boolean", " Whether to print the logs from failing tests.");
			this.register_option ("install_umask", "integer", " Default umask to apply on permissions of installed files");
			this.register_option ("layout", "combo", " Build directory layout");
			this.register_option ("optimization", "combo", " Optimization level");
			this.register_option ("pkg_config_path", "string", " Additional paths for pkg-config to search before builtin paths");
			this.register_option ("prefer_static", "boolean", " Whether to try static linking before shared linking");
			this.register_option ("cmake_prefix_path", "array", " Additional prefixes for cmake to search before builtin paths");
			this.register_option ("stdsplit", "boolean", " Split stdout and stderr in test logs");
			this.register_option ("strip", "boolean", " Strip targets on install");
			this.register_option ("unity", "combo", "Unity build");
			this.register_option ("unity_size", "integer", "Unity file block size");
			this.register_option ("warning_level", "combo", " Set the warning level. From 0 = none to 3 = highest");
			this.register_option ("werror", "boolean", "Treat warnings as errors");
			this.register_option ("wrap_mode", "combo", " Wrap mode to use");
			this.register_option ("force_fallback_for", "array", " Force fallback for those dependencies");
			this.register_option ("b_asneeded", "boolean", " Use -Wl,--as-needed when linking");
			this.register_option ("b_bitcode", "boolean", "Embed Apple bitcode");
			this.register_option ("b_colorout", "combo", " Use colored output");
			this.register_option ("b_coverage", "boolean", "Enable coverage tracking");
			this.register_option ("b_lundef", "boolean", "Don't allow undefined symbols when linking");
			this.register_option ("b_lto", "boolean", "Use link time optimization");
			this.register_option ("b_lto_threads", "integer", "Use multiple threads for lto");
			this.register_option ("b_lto_mode", "combo", "Select between lto modes, thin and default.");
			this.register_option ("b_ndebug", "combo", "Disable asserts");
			this.register_option ("b_pch", "boolean", "Use precompiled headers");
			this.register_option ("b_pgo", "combo", "Use profile guided optimization");
			this.register_option ("b_sanitize", "combo", " Code sanitizer to use");
			this.register_option ("b_staticpic", "boolean", "Build static libraries as position independent");
			this.register_option ("b_pie", "boolean", "Build position-independent executables");
			this.register_option ("b_vscrt", "combo", "VS runtime library to use");
			this.register_option ("c_args", "array", "C compile arguments to use");
			this.register_option ("c_link_args", "array", "C link arguments to use");
			this.register_option ("c_std", "combo", "C language standard to use");
			this.register_option ("c_winlibs", "array", "Standard Windows libs to link against");
			this.register_option ("c_thread_count", "integer", "Number of threads to use with emcc when using threads");
			this.register_option ("cpp_args", "array", "C++ compile arguments to use");
			this.register_option ("cpp_link_args", "array", "C++ link arguments to use");
			this.register_option ("cpp_std", "combo", "C++ language standard to use");
			this.register_option ("cpp_debugstl", "boolean", "C++ STL debug mode");
			this.register_option ("cpp_eh", "combo", "C++ exception handling type");
			this.register_option ("cpp_rtti", "boolean", "Whether to enable RTTI (runtime type identification)");
			this.register_option ("cpp_thread_count", "integer", "Number of threads to use with emcc when using threads");
			this.register_option ("cpp_winlibs", "array", "Standard Windows libs to link against");
			this.register_option ("fortran_std", "combo", " Fortran language standard to use");
			this.register_option ("cuda_ccbindir", "string", "CUDA non-default toolchain directory to use (-ccbin)");
			this.register_option ("pkgconfig.relocatable", "boolean", "Generate the pkgconfig files as relocatable");
			this.register_option ("python.install_env", "combo", "Which python environment to install to");
			this.register_option ("python.platlibdir", "string", "Directory for site-specific, platform-specific files");
			this.register_option ("python.purelibdir", "string", "Directory for site-specific, non-platform-specific files");
			tree.free ();
		}

		void register_option (string name, string type, string description) {
			var o = new MesonOption ();
			o.type = type;
			o.description = description;
			this.options[name] = o;
		}

		public Variant build_dict (...) {
			var builder = new VariantBuilder (new VariantType ("a{sv}"));
			var l = va_list ();
			while (true) {
				string? key = l.arg ();
				if (key == null) {
					break;
				}
				Variant val = l.arg ();
				builder.add ("{sv}", key, val);
			}
			return builder.end ();
		}
	}
}
