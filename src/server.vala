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
		SymbolTree tree;
		TypeRegistry tr;
		MainLoop loop;
		SourceFile ast;
		internal MesonLsp (MainLoop l) {
			this.loop = l;
			this.tr = new TypeRegistry ();
			tr.init ();
		}

		protected override bool handle_call (Jsonrpc.Client client, string method, Variant id, Variant parameters){
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
			}
			return true;
		}

		void initialize (Jsonrpc.Client client, Variant id, Variant @params) throws Error {
			var init = Util.parse_variant<InitializeParams> (@params);
			warning ("HERE!!!");
			this.base_uri = Uri.parse (init.rootUri, UriFlags.NONE);
			this.load_tree (this.base_uri);
			client.reply (id, build_dict (
                capabilities: build_dict (
                    documentSymbolProvider: new Variant.boolean (true),
                    hoverProvider: new Variant.boolean (true)
                ),
                serverInfo: build_dict (
                    name: new Variant.string ("Meson Language Server"),
                    version: new Variant.string ("0.0.1-alpha")
                )
            ));
		}

		public void definition (Jsonrpc.Client client, Variant id, Variant @params) throws Error {
			var p = Util.parse_variant<TextDocumentPositionParams>(@params);
			// First find the identifier to look for
			var symbol_name = this.ast.find_identifier (p.get_file(), p.position);
			var ret = (Location) null;
			if (symbol_name == null) {
				client.reply (id, null);
				return;
			}
			info ("Found symbol at location: %s", symbol_name);
			var found = this.ast.find_symbol (symbol_name);
			if (found.is_empty) {
				info ("No matching declarations found :(");
				client.reply (id, null);
				return;
			}
			found.sort ((a,b) => {
				var pf = p.get_file();
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
			var first_good = found[0];
			info ("Found first good: %s (%u %u)", first_good.sref.file, first_good.sref.start_line, first_good.sref.start_column);
			var location = new Location ();
			location.uri = File.new_for_path (first_good.sref.file).get_uri();
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
			var p = Util.parse_variant<TextDocumentPositionParams>(@params);
			var syms = this.tree.get_symbols (File.new_for_uri (p.textDocument.uri));
			var array = new Json.Array ();
			array.ref();
			foreach (var sym in syms)
				array.add_element (Json.gobject_serialize (sym.to_symbol ()));
			var ret = Json.gvariant_deserialize (new Json.Node.alloc ().init_array (array), null);
			client.reply (id, ret);
		}

		internal void load_tree (Uri dir) throws GLib.Error {
			this.tree = SymbolTree.build (dir);
			this.ast = this.tree.merge ();
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
