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
			this.register_type ("tgt", "");
			this.register_type ("compiler", "");
			this.register_type ("inc", "");
			this.register_type ("extracted_obj", "");
			this.register_type ("alias_tgt", "tgt");
			this.register_type ("build_tgt", "tgt");
			this.register_type ("dep", "");
			this.register_type ("file", "");
			this.register_type ("host_machine", "build_machine");
			this.register_type ("target_machine", "build_machine");
			this.register_type ("exe", "build_tgt");
			this.register_type ("jar", "build_tgt");
			this.register_type ("lib", "build_tgt");
			this.register_type ("both_libs", "lib");
			this.register_type ("custom_tgt", "build_tgt");
			this.register_type ("custom_idx", "build_tgt");
			this.register_type ("run_tgt", "build_tgt");
			this.register_type ("env", "");
			this.register_type ("file", "");
			this.register_type ("external_program", "");
			this.register_type ("build_machine", "");
			this.register_type ("meson", "");
			this.find_type ("build_tgt")
				.register_method("extract_all_objects", new ParameterListBuilder ().add_param (ElementaryType.BOOL, "recursive").build (), this.find_type ("extracted_obj"))
				.register_method("extract_objects",
					new ParameterListBuilder ()
						.add_variable_param ("source",
							new MesonType[]{new Elementary(ElementaryType.STR), this.find_type ("file")}
						).build (), this.find_type ("extracted_obj"))
				.register_method("found", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method("full_path", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method("name", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method("path", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method("private_dir_include", new Gee.ArrayList<Parameter>(), this.find_type ("inc"));
			
			this.find_type ("both_libs")
				.register_method("get_shared_lib", new Gee.ArrayList<Parameter>(), this.find_type ("lib"))
				.register_method("get_static_lib", new Gee.ArrayList<Parameter>(), this.find_type ("lib"));
			this.find_type ("env")
				.register_method ("append",
					new ParameterListBuilder()
						.add_param(ElementaryType.STR, "variable")
						.add_param(ElementaryType.STR, "Value")
						.add_kwarg(ElementaryType.STR, "separator").build(), new Elementary (ElementaryType.STR))
				.register_method ("prepend",
					new ParameterListBuilder()
						.add_param(ElementaryType.STR, "variable")
						.add_param(ElementaryType.STR, "Value")
						.add_kwarg(ElementaryType.STR, "separator").build(), new Elementary (ElementaryType.STR));
			
			this.find_type ("external_program")
				.register_method ("found", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method ("full_path", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("path", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("version", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR));
			this.find_type ("build_machine")
				.register_method ("cpu", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("cpu_family", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("endian", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("system", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR));
			this.find_type ("meson")
				.register_method ("add_devenv",
					new ParameterListBuilder()
						.add_variable_param ("env", new MesonType[]{
														this.find_type ("env"),
														new Elementary (ElementaryType.STR),
														this.list(ElementaryType.STR),
														this.dict(ElementaryType.STR),
														this.dict1(this.list(ElementaryType.STR)),
													})
						.add_kwarg(ElementaryType.STR, "method")
						.add_kwarg(ElementaryType.STR, "separator")
						.build (), new Elementary (ElementaryType.VOID))
				.register_method ("add_dist_script",
					new ParameterListBuilder ()
						.add_variable_param ("script_name", new MesonType[]{
																new Elementary (ElementaryType.STR),
																this.find_type ("file"),
																this.find_type ("external_program")
															})
						.build(), new Elementary (ElementaryType.VOID))
				.register_method ("add_install_script",
					new ParameterListBuilder ()
						.add_variable_param ("script_name", new MesonType[]{
																new Elementary (ElementaryType.STR),
																this.find_type ("file"),
																this.find_type ("external_program"),
																this.find_type ("exe"),
																this.find_type ("custom_tgt"),
																this.find_type ("custom_idx")
															})
						.add_variable_param ("arg", new MesonType[]{
																new Elementary (ElementaryType.STR),
																this.find_type ("file"),
																this.find_type ("external_program"),
																this.find_type ("exe"),
																this.find_type ("custom_tgt"),
																this.find_type ("custom_idx")
															})
						.add_kwarg(ElementaryType.STR, "install_tag")
						.add_kwarg(ElementaryType.BOOL, "skip_if_destdir")
						.build(), new Elementary (ElementaryType.VOID))
				.register_method ("add_postconf_script",
														new ParameterListBuilder ()
															.add_variable_param ("script_name", new MesonType[]{
																new Elementary (ElementaryType.STR),
																this.find_type ("file"),
																this.find_type ("external_program")
															})
						.build(), new Elementary (ElementaryType.VOID))
				.register_method ("backend", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("build_root", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("can_run_host_binaries", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method ("current_build_dir", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("current_source_dir", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("get_compiler",
									new ParameterListBuilder ()
										.add_param (ElementaryType.STR, "language")
										.add_kwarg (ElementaryType.BOOL, "native")
									.build(), this.find_type ("compiler"))
				.register_method("get_cross_property",
									new ParameterListBuilder ()
									.add_param (ElementaryType.STR, "propname")
									.add_param (ElementaryType.ANY, "fallback_value", true)
								.build (), new Elementary(ElementaryType.ANY))
				.register_method("get_external_property",
									new ParameterListBuilder ()
									.add_param (ElementaryType.STR, "propname")
									.add_param (ElementaryType.ANY, "fallback_value", true)
									.add_kwarg (ElementaryType.BOOL, "native")
								.build (), new Elementary(ElementaryType.ANY))
				.register_method ("global_build_root", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("global_source_root", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("has_exe_wrapper", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method("has_external_property",
									new ParameterListBuilder ()
									.add_param (ElementaryType.STR, "propname")
									.add_kwarg (ElementaryType.BOOL, "native")
								.build (), new Elementary(ElementaryType.BOOL))
				.register_method ("install_dependency_manifest", new ParameterListBuilder ().add_param (ElementaryType.STR, "output_name").build (), new Elementary (ElementaryType.STR))
				.register_method ("is_crossbuild", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method ("is_unity", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method ("override_dependency",
									new ParameterListBuilder ()
									.add_param (ElementaryType.STR, "name")
									.add_param1 (this.find_type ("dep"), "name")
									.add_kwarg (ElementaryType.BOOL, "native")
									.add_kwarg (ElementaryType.BOOL, "static")
								.build(), new Elementary (ElementaryType.VOID))
				.register_method ("override_find_program",
									new ParameterListBuilder ()
									.add_param (ElementaryType.STR, "progname")
									.add_variable_param ("program", new MesonType[]{
										this.find_type ("exe"),
										this.find_type ("file"),
										this.find_type ("external_program")
									})

								.build(), new Elementary (ElementaryType.VOID))
				.register_method ("project_build_root", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("project_license", new Gee.ArrayList<Parameter>(), this.list (ElementaryType.STR))
				.register_method ("project_name", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("project_source_root", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("project_version", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("source_root", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("version", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR));
		}

		void register_type (string name, string super) {
			var obj = new ObjectType();
			obj.name = name;
			obj.super_type = super;
			this.types.add(obj);
		}

		MesonType list (ElementaryType t) {
			var l = new MList ();
			l.values.add (new Elementary (t));
			return l;
		}

		MesonType dict (ElementaryType t) {
			var l = new Dictionary ();
			l.values.add (new Elementary (t));
			return l;
		}

		MesonType dict1 (MesonType t) {
			var l = new Dictionary ();
			l.values.add (t);
			return l;
		}

		ObjectType find_type (string obj_name) {
			foreach (var t in this.types) {
				if (t is ObjectType && ((ObjectType)t).name == obj_name) {
					return (ObjectType)t;
				}
			}
			critical ("Not found: %s", obj_name);
			return null;
		}
	}

	class ParameterListBuilder {
		Gee.List<Parameter> arr {get; set; default = new Gee.ArrayList<Parameter> (); }

		internal ParameterListBuilder add_param(ElementaryType t, string name, bool optional = false) {
			var p = new Parameter ();
			p.name = name;
			p.is_keyword = false;
			p.possible_types.add (new Elementary (t));
			this.arr.add (p);
			return this;
		}

		internal ParameterListBuilder add_param1(MesonType t, string name, bool optional = false) {
			var p = new Parameter ();
			p.name = name;
			p.is_keyword = false;
			p.possible_types.add (t);
			this.arr.add (p);
			return this;
		}
		internal ParameterListBuilder add_kwarg(ElementaryType t, string name) {
			var p = new Parameter ();
			p.name = name;
			p.is_keyword = true;
			p.possible_types.add (new Elementary (t));
			this.arr.add (p);
			return this;
		}

		internal ParameterListBuilder add_variable_param(string name, MesonType[] alternatives) {
			var p = new Parameter ();
			p.name = name;
			p.is_keyword = true;
			p.possible_types.add_all_array (alternatives);
			this.arr.add (p);
			return this;
		}

		internal Gee.List<Parameter> build () {
			return this.arr;
		}
	}

	internal class MesonType : GLib.Object {

	}

	internal class ObjectType : MesonType {
		internal string name;
		internal string super_type;
		internal string docs;
		internal Gee.List<Method> methods {get; set; default = new Gee.ArrayList<Method>(); }
		internal ObjectType register_method (string name, Gee.List<Parameter> args, MesonType ret) {
			var m = new Method ();
			m.parameters = args;
			m.name = name;
			m.return_type = ret;
			this.methods.add (m);
			return this;
		}
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
		internal Gee.List<MesonType> possible_types {get; set; default = new Gee.ArrayList<MesonType>(); }
	}

	internal class Elementary : MesonType {
		ElementaryType type;

		internal Elementary (ElementaryType t) {
			this.type = t;
		}
	}

	internal class Dictionary : MesonType {
		internal Gee.List<MesonType> values {get; set; default = new Gee.ArrayList<MesonType>(); }
	}

	internal class MList : MesonType {
		internal Gee.List<MesonType> values {get; set; default = new Gee.ArrayList<MesonType>(); }
	}

	internal enum ElementaryType {
		ANY,
		BOOL,
		INT,
		STR,
		VOID
	}
}
