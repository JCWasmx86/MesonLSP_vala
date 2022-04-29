/* type_registry.vala
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
	internal class TypeRegistry {
		internal Gee.List<MesonType> types;
		internal void init () {
			this.types = new Gee.ArrayList<MesonType>();
			// this.types.add (new ObjectType ("").add_method (new Method ("add_global_arguments").add_parameter(new Parameter ("args", true, ))));
		}
	}

	internal class MesonType : GLib.Object {

	}

	internal class ObjectType : MesonType {
		string name;
		string super_type;
		string docs;
		internal Gee.List<Method> methods;
	}

	internal class Method {
		internal string name;
		internal string doc;
		internal Gee.List<Parameter> parameters;
		internal bool varargs;
		internal MesonType return_type;
	}

	internal class Parameter {
		internal string name;
		internal bool is_keyword;
		internal bool required;
		internal Gee.List<MesonType> possible_types;
	}

	internal class Elementary : MesonType {
		ElementaryType type;
	}

	internal class Dictionary : MesonType {
		internal Gee.List<MesonType> values;
	}

	internal class MList : MesonType {
		internal Gee.List<MesonType> values;
	}

	internal enum ElementaryType {
		ANY,
		BOOL,
		INT,
		STR,
		VOID
	}
}
