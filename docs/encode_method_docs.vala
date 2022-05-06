/* encode_method_docs.vala
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
int main(string[] argv) {
	var input = argv[1];
	var data = "";
	size_t data_length = 0;
	try {
		FileUtils.get_contents(input, out data, out data_length);
		var methods = new Method[0];
		var tmp = new Method();
		var lines = data.split("\n");
		foreach (var line in lines) {
			if (line.has_prefix("===")) {
				methods += tmp;
				tmp = new Method();
				var part = line.replace("===", "");
				var parts = part.split("::");
				if (parts.length == 2) {
					tmp.object_name = parts[0];
					tmp.name = parts[1];
				} else
					tmp.name = parts[0];
				tmp.docs = "";
			} else {
				tmp.docs += (line + "\n");
			}
		}
		methods += tmp;
		var mos = new MemoryOutputStream(null);
		var dos = new DataOutputStream(mos);
		dos.put_byte(0x55);
		dos.put_byte(0xAA);
		dos.put_uint16((uint16) methods.length);
		foreach (var c in methods) {
			if (c.name == null) {
				continue;
			}
			assert(c != null);
			if (c.object_name == null)
				dos.put_byte(0x00);
			else
				dos.put_byte(0x01);
			dos.put_uint32(c.name.length);
			dos.write(c.name.data);
			if (c.object_name != null) {
				dos.put_uint32(c.object_name.length);
				dos.write(c.object_name.data);
			}
			dos.put_uint32(c.docs.length);
			dos.write(c.docs.data);
		}
		var sb = new StringBuilder();
		sb.append("#include<stdint.h>\nuint8_t meson_lsp_method_docs_data[] = {");
		for (var i = 0; i < mos.data_size; i++) {
			sb.append("(uint8_t)%u".printf(((uint8[]) mos.data)[i]));
			if (i != mos.data_size - 1)
				sb.append(", ");
		}
		sb.append("};\n");
		sb.append("uint32_t meson_lsp_method_docs_data_len = %llu;\n".printf(mos.data_size));
		FileUtils.set_contents(argv[2], sb.str);
	} catch (Error e) {
		critical ("%s", e.message);
		return -1;
	}
	return 0;
}

class Method {
	internal string? object_name;
	internal string name;
	internal string docs;
}
