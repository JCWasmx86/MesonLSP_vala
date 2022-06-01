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
		internal Gee.List<Method> functions;
		internal void init () {
			new Elementary (ElementaryType.VOID);
			this.types = new Gee.ArrayList<MesonType>();
			this.functions = new Gee.ArrayList<Method>();
			Meson.populate_typeregistry (this);
			Meson.populate_typeregistry_modules (this);
		}

		internal void register_function (string name, Gee.List<Parameter> args, MesonType[] ret, bool variadic) {
			var m = new Method ();
			m.parameters = args;
			m.name = name;
			m.varargs = variadic;
			m.return_type = new Gee.ArrayList<MesonType>();
			m.return_type.add_all_array (ret);
			this.functions.add (m);
		}

		internal void register_type (string name, string super) {
			var obj = new ObjectType ();
			obj.name = name;
			obj.super_type = super;
			this.types.add (obj);
		}

		internal Method? find_function (string name) {
			foreach (var t in this.functions) {
				if (t.name == name)
					return t;
			}
			return null;
		}

		internal ObjectType find_type (string obj_name) {
			foreach (var t in this.types) {
				if (t is ObjectType && ((ObjectType) t).name == obj_name) {
					return (ObjectType) t;
				}
			}
			critical ("Not found: %s", obj_name);
			assert_not_reached ();
		}

		internal ObjectType? find_type_safe (string obj_name) {
			foreach (var t in this.types) {
				if (t is ObjectType && ((ObjectType) t).name == obj_name) {
					return (ObjectType) t;
				}
			}
			return null;
		}
	}

	class ParameterBuilder {
		Gee.List<Parameter> arr { get; set; default = new Gee.ArrayList<Parameter> (); }

		internal ParameterBuilder register_kwarg_argument (string name, MesonType[] t, bool optional = false) {
			var p = new Parameter ();
			p.name = name;
			p.is_keyword = true;
			p.required = optional;
			p.possible_types.add_all_array (t);
			this.arr.add (p);
			return this;
		}

		internal ParameterBuilder register_argument (string name, MesonType[] alternatives, bool optional = false, bool varargs = false) {
			var p = new Parameter ();
			p.name = name;
			p.is_keyword = false;
			p.possible_types.add_all_array (alternatives);
			p.required = !optional;
			p.varargs = varargs;
			this.arr.add (p);
			return this;
		}

		internal Gee.List<Parameter> build () {
			return this.arr;
		}
	}

	internal class MesonType : GLib.Object {
		internal virtual string to_string () {
			return "<<>>";
		}
	}

	internal class ObjectType : MesonType {
		internal string name;
		internal string super_type;
		internal string docs;
		internal Gee.List<Method> methods { get; set; default = new Gee.ArrayList<Method>(); }
		internal ObjectType register_function (string name, Gee.List<Parameter> args, MesonType[] ret, bool varargs = false) {
			var m = new Method ();
			m.varargs = varargs;
			m.parameters = args;
			m.name = name;
			m.return_type = new Gee.ArrayList<MesonType>();
			m.return_type.add_all_array (ret);
			this.methods.add (m);
			return this;
		}

		internal Method? find_method_safe (string name) {
			foreach (var m in this.methods) {
				if (m.name == name)
					return m;
			}
			return null;
		}

		internal override string to_string () {
			return this.name;
		}
	}

	internal class Method {
		internal string name;
		internal string? doc;
		internal Gee.List<Parameter> parameters;
		internal bool varargs;
		internal Gee.List<MesonType> return_type;

		internal string generate_docs () {
			var sb = new StringBuilder ();
			sb.append ("`").append (this.name).append ("`\n\n");
			if (this.doc != null)
				sb.append (this.doc).append ("\n");
			sb.append ("```\n");
			sb.append (this.return_type_doc ()).append (" ").append (this.name);
			if (this.parameters.size == 0)
				sb.append (" ();");
			else {
				sb.append (" (\n");
				var kw = new StringBuilder ();
				var p = new StringBuilder ();
				foreach (var param in this.parameters) {
					if (!param.is_keyword) {
						p.append ("	").append (param.type_string ())
						 .append (" ").append (param.name).append (param.varargs ? "…" : "").append (",\n");
					}
				}
				foreach (var param in this.parameters) {
					if (param.is_keyword) {
						kw.append ("	").append (param.name)
						 .append (": ").append (param.type_string ())
						 .append (param.required ? "(optional),\n" : ",\n");
					}
				}
				sb.append (p.str).append (kw.str);
				sb.append (");");
			}
			sb.append ("\n```");
			return sb.str;
		}

		string return_type_doc () {
			var types = new string[0];
			foreach (var t in this.return_type)
				types += t.to_string ();
			var sb = new StringBuilder ();
			for (var i = 0; i < types.length; i++) {
				sb.append (types[i]);
				if (i != types.length - 1)
					sb.append ("|");
			}
			return sb.str;
		}
	}

	internal class Parameter {
		internal string name;
		internal bool is_keyword;
		internal bool required;
		internal bool varargs;
		internal Gee.List<MesonType> possible_types { get; set; default = new Gee.ArrayList<MesonType>(); }

		internal string type_string () {
			var types = new string[0];
			foreach (var t in this.possible_types)
				types += t.to_string ();
			var sb = new StringBuilder ();
			for (var i = 0; i < types.length; i++) {
				sb.append (types[i]);
				if (i != types.length - 1)
					sb.append ("|");
			}
			return sb.str;
		}
	}

	internal class Elementary : MesonType {

		public static Elementary ANY = new Elementary (ElementaryType.ANY);
		public static Elementary BOOL = new Elementary (ElementaryType.BOOL);
		public static Elementary INT = new Elementary (ElementaryType.INT);
		public static Elementary STR = new Elementary (ElementaryType.STR);
		public static Elementary VOID = new Elementary (ElementaryType.VOID);
		public static Elementary NOT_DEDUCEABLE = new Elementary (ElementaryType.NOT_DEDUCEABLE);

		static construct {
			ANY = new Elementary (ElementaryType.ANY);
			BOOL = new Elementary (ElementaryType.BOOL);
			INT = new Elementary (ElementaryType.INT);
			STR = new Elementary (ElementaryType.STR);
			VOID = new Elementary (ElementaryType.VOID);
			NOT_DEDUCEABLE = new Elementary (ElementaryType.NOT_DEDUCEABLE);
		}

		internal ElementaryType type;

		internal Elementary (ElementaryType t) {
			this.type = t;
		}

		internal override string to_string () {
			switch (this.type) {
			case ElementaryType.ANY:
				return "any";
			case ElementaryType.BOOL:
				return "bool";
			case ElementaryType.INT:
				return "int";
			case ElementaryType.STR:
				return "str";
			case ElementaryType.VOID:
				return "void";
			case ElementaryType.NOT_DEDUCEABLE:
				return "<not_deduceable>";
			}
			assert_not_reached ();
		}
	}

	internal class Dictionary : MesonType {
		internal Gee.Set<MesonType> values { get; set; default = new Gee.TreeSet<MesonType> (compare_types_func); }

		internal override string to_string () {
			return "dict[%s]".printf (this.values.fold<string> ((a, b) => a.to_string () + "|" + b.to_string (), "")).replace ("|]", "]");
		}

		internal Dictionary (MesonType[] types) {
			this.values.add_all_array (types);
		}
	}

	internal class MList : MesonType {
		internal Gee.Set<MesonType> values { get; set; default = new Gee.TreeSet<MesonType> (compare_types_func); }
		internal override string to_string () {
			return "list[%s]".printf (this.values.fold<string> ((a, b) => a.to_string () + "|" + b.to_string (), "")).replace ("|]", "]");
		}

		internal MList (MesonType[] types) {
			this.values.add_all_array (types);
		}
	}

	internal enum ElementaryType {
		ANY,
		BOOL,
		INT,
		STR,
		VOID,
		NOT_DEDUCEABLE
	}
}
