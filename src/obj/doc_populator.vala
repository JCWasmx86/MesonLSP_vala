/* doc_populator.vala
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
[CCode (cname = "meson_lsp_class_docs_data", array_length = false)]
extern uint8 meson_lsp_class_docs_data;
[CCode (cname = "meson_lsp_class_docs_data_len")]
extern uint32 meson_lsp_class_docs_data_len;
[CCode (cname = "meson_lsp_method_docs_data", array_length = false)]
extern uint8 meson_lsp_method_docs_data;
[CCode (cname = "meson_lsp_method_docs_data_len")]
extern uint32 meson_lsp_method_docs_data_len;
namespace Meson {
	class DocPopulator {
		public static void populate_docs (TypeRegistry tr) throws IOError {
			var doc_classes = new Gee.ArrayList<DocClass> ();
			var data_copy = new uint8[meson_lsp_class_docs_data_len];
			Posix.memcpy (data_copy, &meson_lsp_class_docs_data, meson_lsp_class_docs_data_len);
			var mis = new MemoryInputStream.from_data (data_copy);
			var dis = new DataInputStream (mis);
			var byte = dis.read_byte ();
			assert (byte == 0x55 && "Does not match 0x55" != null);
			byte = dis.read_byte ();
			assert (byte == 0xaa && "Does not match 0xaa" != null);
			var bytes_read = 2u;
			var bytes_left = meson_lsp_class_docs_data_len - 2;
			dis.read_uint16 ();
			bytes_read += 2;
			bytes_left -= 2;
			var hierarchy = new Gee.HashMap<string, string>();
			while (bytes_left != 0) {
				var has_super_class = dis.read_byte () == 0x1;
				bytes_read++;
				bytes_left--;
				var c = new DocClass ();
				var len = dis.read_uint32 ();
				bytes_read += 4;
				bytes_left -= 4;
				assert (len < bytes_left);
				var bytes = new uint8[len];
				Posix.memset (bytes, 0, len);
				dis.read (bytes);
				bytes_read += len;
				bytes_left -= len;
				bytes += 0;
				var class_name = ((string) bytes).dup ();
				c.name = class_name;
				if (has_super_class) {
					len = dis.read_uint32 ();
					bytes_read += 4;
					bytes_left -= 4;
					assert (len < bytes_left);
					bytes = new uint8[len];
					Posix.memset (bytes, 0, len);
					dis.read (bytes);
					bytes_read += len;
					bytes_left -= len;
					bytes += 0;
					var sclass_name = ((string) bytes).dup ();
					c.super_class = sclass_name;
				}
				len = dis.read_uint32 ();
				bytes_read += 4;
				bytes_left -= 4;
				bytes = new uint8[len];
				Posix.memset (bytes, 0, len);
				dis.read (bytes);
				assert (len <= bytes_left);
				bytes_read += len;
				bytes_left -= len;
				bytes += 0;
				var docs = (string) bytes;
				c.docs = docs;
				doc_classes.add (c);
				info ("Extracted class %s (extends %s)", c.name, c.super_class);
				if (c.super_class != null)
					hierarchy.set (c.name, c.super_class);
			}
			foreach (var c in doc_classes) {
				var h = new string[0];
				var sb = new StringBuilder ();
				var parent = c.super_class;
				while (true) {
					if (parent == null || !hierarchy.has_key (parent))
						break;
					h += parent;
					parent = hierarchy[parent];
				}
				sb.append ("```\n");
				sb.append (c.name);
				if (h.length != 0)
					sb.append (" extends ");
				for (var i = 0; i < h.length; i++) {
					sb.append (h[i]);
					if (i != h.length - 1)
						sb.append (" extends ");
				}
				sb.append ("\n```\n");
				sb.append (c.docs.strip ());
				tr.find_type (c.name).docs = sb.str;
			}
			load_methods (tr);
		}

		static void load_methods (TypeRegistry tr) throws IOError {
			var data_copy = new uint8[meson_lsp_method_docs_data_len];
			Posix.memcpy (data_copy, &meson_lsp_method_docs_data, meson_lsp_method_docs_data_len);
			var mis = new MemoryInputStream.from_data (data_copy);
			var dis = new DataInputStream (mis);
			var byte = dis.read_byte ();
			assert (byte == 0x55 && "Does not match 0x55" != null);
			byte = dis.read_byte ();
			assert (byte == 0xaa && "Does not match 0xaa" != null);
			var bytes_read = 2u;
			var bytes_left = meson_lsp_method_docs_data_len - 2;
			dis.read_uint16 ();
			bytes_read += 2;
			bytes_left -= 2;
			var methods = new Gee.ArrayList<DocMethod>();
			while (bytes_left != 0) {
				var has_obj = dis.read_byte () == 0x1;
				bytes_read++;
				bytes_left--;
				var c = new DocMethod ();
				var len = dis.read_uint32 ();
				bytes_read += 4;
				bytes_left -= 4;
				assert (len < bytes_left);
				var bytes = new uint8[len];
				Posix.memset (bytes, 0, len);
				dis.read (bytes);
				bytes_read += len;
				bytes_left -= len;
				bytes += 0;
				var m_name = (string) bytes;
				c.name = m_name;
				if (has_obj) {
					len = dis.read_uint32 ();
					bytes_read += 4;
					bytes_left -= 4;
					assert (len < bytes_left);
					bytes = new uint8[len];
					Posix.memset (bytes, 0, len);
					dis.read (bytes);
					bytes_read += len;
					bytes_left -= len;
					bytes += 0;
					var obj_name = (string) bytes;
					c.obj = obj_name;
				}
				len = dis.read_uint32 ();
				bytes_read += 4;
				bytes_left -= 4;
				bytes = new uint8[len];
				Posix.memset (bytes, 0, len);
				dis.read (bytes);
				assert (len <= bytes_left);
				bytes_read += len;
				bytes_left -= len;
				bytes += 0;
				var docs = (string) bytes;
				c.docs = docs;
				methods.add (c);
				info ("Extracted method %s (in object %s)", c.name, c.obj);
			}
			foreach (var method in methods) {
				if (method.obj == null) {
					info ("SKIP: %s", method.name);
				} else {
					var type = tr.find_type (method.obj);
					var m = type.find_method (method.name);
					m.doc = method.docs;
				}
			}
		}

		class DocClass {
			internal string name;
			internal string? super_class;
			internal string docs;
		}
		class DocMethod {
			internal string name;
			internal string? obj;
			internal string docs;
		}
	}
}
