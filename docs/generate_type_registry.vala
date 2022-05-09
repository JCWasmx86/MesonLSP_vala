/* generate_type_registry.vala
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

public static int main (string[] argv) {
	var parser = new Json.Parser ();
	try {
		parser.load_from_file (argv[1]);
	} catch (Error e) {
		error ("%s", e.message);
	}
	var root = parser.get_root ().get_object ();
	var objects = root.get_object_member ("objects");
	var members = objects.get_members ();
	var ret = new RootObject();
	foreach (var obj in members) {
		var oo = ObjectObject.parse (objects.get_object_member (obj));
		ret.objects[oo.name] = oo;
	}
	var funcs = root.get_object_member ("functions");
	members = funcs.get_members ();
	foreach (var obj in members) {
		var oo = FunctionObject.parse (funcs.get_object_member (obj));
		ret.functions[oo.name] = oo;
	}
	var sb = new StringBuilder ();
	sb.append ("// AUTO-Generated\nnamespace Meson {\n\tinternal static void populate_typeregistry (TypeRegistry tr) {\n");
	var type_names = new Gee.ArrayList<string>();
	type_names.add_all (ret.objects.keys);
	type_names.sort ((a,b) => {
		var sup_a = ret.objects[a].super_class;
		var sup_b = ret.objects[b].super_class;
		if (sup_a != null && sup_b == null)
			return 1;
		else if (sup_a == null && sup_b == null)
			return -1;
		else if (sup_a != null && sup_b != null)
			return sup_a == b ? -1 : ((sup_b == a) ? 1 : 0);
		return a.ascii_casecmp (b);
	});
	foreach (var t in type_names) {
		if (ret.objects[t].name.has_prefix ("cmake"))
			continue;
		var super_class = ret.objects[t].super_class;
		sb.append ("\t\ttr.register_type(\"").append (t).append("\", \"").append (super_class == null ? "" : super_class).append("\");\n");
	}
	foreach (var entry in ret.functions.entries) {
		var f = entry.value;
		sb.append ("\t\ttr.register_function(\"").append(entry.key).append("\", new ParameterBuilder ()\n");
		foreach (var arg in f.posargs.values) {
			sb.append ("\t\t\t\t.register_argument (\"").append (arg.name).append("\", ").append (arg.array ()).append (", false)\n");
		}
		foreach (var arg in f.optargs.values) {
			sb.append ("\t\t\t\t.register_argument (\"").append (arg.name).append("\", ").append (arg.array ()).append (", true)\n");
		}
		foreach (var arg in f.kwargs.values) {
			sb.append ("\t\t\t\t.register_kwarg_argument (\"").append (arg.name).append("\", ").append (arg.array ()).append (")\n");
		}
		if (f.varargs != null) {
			sb.append ("\t\t\t\t.register_argument (\"")
				.append (f.varargs.name).append("\", ")
				.append (f.varargs.array ()).append (", ").append(f.varargs.is_optional.to_string()).append(")\n");
		}
		sb.append ("\t\t\t.build (), new MesonType[] {\n\t\t\t\t");
		foreach (var r in f.returns)
			sb.append ("\t\t\t\t").append (r.to_string ()).append (",\n");
		sb.append("\t\t\t}, ").append ((f.varargs != null).to_string ()).append (");\n");
	}
	foreach (var obj in ret.objects.entries) {
		if (obj.value.name.has_prefix ("cmake"))
			continue;
		var o = obj.value;
		foreach (var fu in o.methods) {
			var f = fu.value;
			sb.append ("\t\ttr.find_type(\"").append (o.name).append ("\").register_function(\"").append(fu.key).append("\", new ParameterBuilder ()\n");
			foreach (var arg in f.posargs.values) {
				sb.append ("\t\t\t\t.register_argument (\"").append (arg.name).append("\", ").append (arg.array ()).append (", false)\n");
			}
			foreach (var arg in f.optargs.values) {
				sb.append ("\t\t\t\t.register_argument (\"").append (arg.name).append("\", ").append (arg.array ()).append (", true)\n");
			}
			foreach (var arg in f.kwargs.values) {
				sb.append ("\t\t\t\t.register_kwarg_argument (\"").append (arg.name).append("\", ").append (arg.array ()).append (")\n");
			}
			if (f.varargs != null) {
				sb.append ("\t\t\t\t.register_argument (\"")
					.append (f.varargs.name).append("\", ")
					.append (f.varargs.array ()).append (", ").append(f.varargs.is_optional.to_string()).append(")\n");
			}
			sb.append ("\t\t\t.build (), new MesonType[] {\n\t\t\t\t");
			foreach (var r in f.returns)
				sb.append ("\t\t\t\t").append (r.to_string ()).append (",\n");
			sb.append("\t\t\t}, ").append ((f.varargs != null).to_string ()).append (");\n");
		}
	}
	sb.append ("\n\t}\n}\n");
	stdout.printf ("\n%s", sb.str.replace(", }", "}"));
	return 0;
}

class TypeObject {
	internal string type;
	internal Gee.List<TypeObject> holds {get; set; default = new Gee.ArrayList<TypeObject>();}
	internal static TypeObject parse (Json.Object obj) {
		var ret = new TypeObject ();
		ret.type = obj.get_string_member ("obj");
		var holds = obj.get_array_member ("holds");
		foreach (var element in holds.get_elements ()) {
			var hold = element.get_object();
			ret.holds.add (TypeObject.parse (hold));
		}
		return ret;
	}

	internal string to_string () {
		switch (this.type) {
			case "str":
			case "bool":
			case "int":
			case "void":
			case "any":
				return "new Elementary (ElementaryType." + this.type.up () + ")";
			case "dict":
				var sb = new StringBuilder ();
				sb.append ("new Dictionary (new MesonType[]{");
				foreach (var m in this.holds)
					sb.append (m.to_string()).append (", ");
				sb.append ("})");
				return sb.str;
			case "list":
				var sb = new StringBuilder ();
				sb.append ("new MList (new MesonType[]{");
				foreach (var m in this.holds)
					sb.append (m.to_string()).append (", ");
				sb.append ("})");
				return sb.str;
			default:
				return "tr.find_type(\"" + this.type + "\")";
		}
	}
}
class Argument {
	internal string name;
	internal bool is_optional;
	Gee.List<TypeObject> types {get; set; default = new Gee.ArrayList<TypeObject>();}

	internal static Argument parse (Json.Object obj) {
		var ret = new Argument ();
		ret.name = obj.get_string_member ("name");
		var t = obj.get_array_member ("type");
		foreach (var m in t.get_elements ()) {
			var obj1 = m.get_object();
			ret.types.add (TypeObject.parse (obj1));
		}
		ret.is_optional = false;
		var min_varargs = obj.get_member ("min_varargs");
		if (min_varargs.get_node_type() != Json.NodeType.NULL) {
			ret.is_optional = min_varargs.get_int() == 0;
		}
		return ret;
	}

	internal string array() {
		var sb = new StringBuilder ();
		sb.append ("new MesonType[] {");
		foreach (var t in this.types) {
			sb.append (t.to_string ()).append (", ");
		}
		sb.append ("}");
		return sb.str;
	}
}
class FunctionObject {
	internal Gee.List<TypeObject> returns {get; set; default = new Gee.ArrayList<TypeObject>();}
	internal Gee.Map<string, Argument> posargs {get; set; default = new Gee.HashMap<string, Argument>();}
	internal Gee.Map<string, Argument> optargs {get; set; default = new Gee.HashMap<string, Argument>();}
	internal Gee.Map<string, Argument> kwargs {get; set; default = new Gee.HashMap<string, Argument>();}
	internal Argument? varargs;
	internal string name;

	internal static FunctionObject parse (Json.Object obj) {
		var ret = new FunctionObject ();
		ret.name = obj.get_string_member ("name");
		var returns = obj.get_array_member ("returns");
		foreach (var o in returns.get_elements ()) {
			var t = o.get_object ();
			ret.returns.add (TypeObject.parse (t));
		}
		var posargs = obj.get_object_member ("posargs");
		foreach (var name in posargs.get_members ()) {
			ret.posargs[name] = Argument.parse (posargs.get_object_member (name));
		}
		var optargs = obj.get_object_member ("optargs");
		foreach (var name in optargs.get_members ()) {
			ret.optargs[name] = Argument.parse (optargs.get_object_member (name));
		}
		var kwargs = obj.get_object_member ("kwargs");
		foreach (var name in kwargs.get_members ()) {
			ret.kwargs[name] = Argument.parse (kwargs.get_object_member (name));
		}
		if (obj.get_member("varargs").get_node_type () != Json.NodeType.NULL)
			ret.varargs = Argument.parse (obj.get_object_member ("varargs"));
		return ret;
	}
}

class ObjectObject {
	internal string name;
	internal string? super_class;
	internal Gee.Map<string, FunctionObject> methods {get; set; default = new Gee.HashMap<string, FunctionObject>();}

	internal static ObjectObject parse (Json.Object obj) {
		var ret = new ObjectObject ();
		ret.name = obj.get_string_member ("name");
		ret.super_class = obj.get_member ("extends").get_node_type () != Json.NodeType.NULL ? obj.get_string_member ("extends") : null;
		var methods = obj.get_object_member ("methods");
		foreach (var name in methods.get_members ()) {
			var method = FunctionObject.parse (methods.get_object_member (name));
			ret.methods[name] = method;
		}
		return ret;
	}
}
class RootObject {
	internal Gee.Map<string, FunctionObject> functions {get; set; default = new Gee.HashMap<string, FunctionObject>();}
	internal Gee.Map<string, ObjectObject> objects {get; set; default = new Gee.HashMap<string, ObjectObject>();}
}
