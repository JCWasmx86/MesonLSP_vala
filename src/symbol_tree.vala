/* symbol_tree.vala
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
	class SymbolTree : Data {
		internal Gee.List<Data> datas { get; set; default = new Gee.ArrayList<Data>(); }
		internal Gee.Map<string, string> patches { get; set; default = new Gee.HashMap<string, string>(); }
		internal Gee.List<string> child_files { get; set; default = new Gee.ArrayList<string>(); }
		internal string filename;
		internal SourceFile? file;
		internal Gee.List<Symbol> flatten () {
			var ret = new Gee.ArrayList<Symbol> ();
			foreach (var data in this.datas) {
				if (data is Symbol)
					ret.add (((Symbol) data));
				else if (data is SymbolTree)
					ret.add_all (((SymbolTree) data).flatten ());
			}
			return ret;
		}

		internal Gee.List<Symbol>? get_symbols (File file) {
			if (this.filename == file.get_path ()) {
				var ret = new Gee.ArrayList<Symbol> ();
				foreach (var data in this.datas) {
					if (data is Symbol) {
						var s = (Symbol) data;
						ret.add (s);
					}
				}
				return ret;
			}
			foreach (var data in this.datas) {
				if (data is SymbolTree) {
					var s = ((SymbolTree) data).get_symbols (file);
					if (s != null)
						return s;
				}
			}
			return null;
		}

		void analyze_ast_stmt (Gee.List<Statement> to_insert, Statement stmt, ref int i) {
			if (stmt is FunctionExpression && ((FunctionExpression) stmt).name == "subdir") {
				var arg_list = ((FunctionExpression) stmt).arg_list;
				if (arg_list == null || arg_list.args.size == 0)
					return;
				var arg = arg_list.args[0];
				if (arg is StringLiteral) {
					info ("Found call to subdir: %s", ((StringLiteral) arg).val);
					var found = false;
					foreach (var data in this.datas) {
						if (found) {
							assert (data is SymbolTree);
							var s = ((SymbolTree) data).merge ();
							to_insert.insert_all (i, s.statements);
							i += s.statements.size;
							break;
						}
						if (data is Subdir && ((Subdir) data).name == ((StringLiteral) arg).val) {
							found = true;
						}
					}
				}
			} else if (stmt is SelectionStatement) {
				var sst = (SelectionStatement) stmt;
				foreach (var block in sst.blocks) {
					for (var j = 0; j < block.size; j++) {
						this.analyze_ast_stmt (block, block[j], ref j);
					}
				}
			}
			// Iteration statements will blow up, no matter what I will do
		}

		internal SourceFile merge () {
			info ("Merging: %s", this.filename);
			for (var i = 0; i < this.file.statements.size; i++) {
				var stmt = this.file.statements[i];
				analyze_ast_stmt (this.file.statements, stmt, ref i);
			}
			return this.file;
		}

		public static SymbolTree build (Uri uri, Gee.Map<string, string> patches = new Gee.HashMap<string, string>(), Gee.Set<Diagnostic> diagnostics) {
			var ret = new SymbolTree ();
			ret.patches = patches;
			var file = File.new_build_filename (File.new_for_uri (uri.to_string ()).get_path (), "meson.build");
			if (!file.query_exists ())
				return ret;
			ret.filename = file.get_path ();
			ret.child_files.add (ret.filename);
			info ("Found meson.build: %s", file.get_path ());
			var ps = new TreeSitter.TSParser ();
			var lang = TreeSitter.tree_sitter_meson ();
			ps.set_language (lang);
			var data = "";
			size_t data_length = 0;
			if (patches.has_key (file.get_uri ())) {
				data = patches[file.get_uri ()];
				data_length = data.length;
			} else
				FileUtils.get_contents (file.get_path (), out data, out data_length);
			var tree = ps.parse_string (null, data + "\n", (uint32) data_length + 1);
			var root = tree.root_node ();
			ret.file = SourceFile.build_ast (data + "\n", file.get_path (), root, diagnostics);
			assert (ret.file != null);
			if (root.named_child_count () == 0) {
				tree.free ();
				return ret;
			}
			var build_def = root.named_child (0);
			if (build_def.type () != "build_definition") {
				info ("Unexpected type: %s", build_def.type ());
				tree.free ();
				return ret;
			}

			for (var i = 0; i < build_def.named_child_count (); i++) {
				var stmt = build_def.named_child (i);
				if (stmt.type () != "statement")
					continue;
				analyze_statement (stmt, ret, uri, file, data, patches, diagnostics);
			}
			tree.free ();
			return ret;
		}

		static void analyze_statement (TreeSitter.TSNode stmt, SymbolTree ret, Uri uri, File file, string data, Gee.Map<string, string> patches, Gee.Set<Diagnostic> diagnostics) {
			for (var j = 0; j < stmt.named_child_count (); j++) {
				var s = stmt.named_child (j);
				if (s.named_child_count () == 0)
					continue;
				if (s.type () == "expression") {
					if (s.named_child (0).type () == "function_expression") {
						var fe = s.named_child (0).named_child (0);
						var name = data.substring (fe.start_byte (), fe.end_byte () - fe.start_byte ());
						if (name == "subdir") {
							var str_literal = s.named_child (0).named_child (1).named_child (0).named_child (0).named_child (0);
							var str = data.substring (str_literal.start_byte () + 1, str_literal.end_byte () - str_literal.start_byte () - 2);
							info ("Found subdir: %s", str);
							var sd = new Subdir ();
							sd.name = str;
							ret.datas.add (sd);
							var new_uri = File.new_build_filename (File.new_for_uri (uri.to_string ()).get_path (), str).get_uri ();
							var st = SymbolTree.build (Uri.parse (new_uri, UriFlags.NONE), patches, diagnostics);
							assert (st.file != null);
							ret.datas.add (st);
							ret.child_files.add (File.new_build_filename (File.new_for_uri (uri.to_string ()).get_path (), str + "/meson.build").get_path ());
						}
					}
				} else if (s.type () == "assignment_statement") {
					var name = s.named_child (0).named_child (0).named_child (0);
					var var_name = data.substring (name.start_byte (), name.end_byte () - name.start_byte ());
					var symbol = new Symbol ();
					symbol.name = var_name;
					symbol.file = file.get_path ();
					symbol.start = new uint[] { name.start_point ().row, name.start_point ().column };
					symbol.end = new uint[] { name.end_point ().row, name.end_point ().column };
					ret.datas.add (symbol);
					info ("Variable: %s", var_name);
				} else if (s.type () == "iteration_statement") {
					for (var i = 3; i < s.named_child_count (); i++) {
						if (s.named_child (i).type () != "statement")
							continue;
						analyze_statement (s.named_child (i), ret, uri, file, data, patches, diagnostics);
					}
				} else if (s.type () == "selection_statement") {
					for (var i = 0; i < s.named_child_count (); i++) {
						if (s.named_child (i).type () != "statement")
							continue;
						analyze_statement (s.named_child (i), ret, uri, file, data, patches, diagnostics);
					}
				}
			}
		}
	}
	abstract class Data : GLib.Object {
	}

	internal class Symbol : Data {
		internal string name;
		internal string file;
		// {line, column}
		internal uint[] start;
		internal uint[] end;

		internal DocumentSymbol to_symbol () {
			var ds = new DocumentSymbol ();
			ds.name = this.name;
			ds.kind = SymbolKind.Variable;
			ds.range = new Range () {
				start = new Position () {
					line = start[0],
					character = start[1]
				},
				end = new Position () {
					line = end[0],
					character = end[1]
				}
			};
			return ds;
		}
	}

	internal class Subdir : Data {
		internal string name;
	}
}
