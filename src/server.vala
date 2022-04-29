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
