/* util.vala
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
	internal class Util {
		public static T? parse_variant<T> (Variant variant) {
			var json = Json.gvariant_serialize (variant);
			return Json.gobject_deserialize (typeof (T), json);
		}

		public static Variant object_to_variant (Object object) throws Error {
			var json = Json.gobject_serialize (object);
			return Json.gvariant_deserialize (json, null);
		}

		public static string get_string_value (string data, TreeSitter.TSNode node) {
			return data.substring (node.start_byte (), node.end_byte () - node.start_byte ());
		}
	}
	class MesonOption  {
		internal string type;
		internal string description;
	}
}
