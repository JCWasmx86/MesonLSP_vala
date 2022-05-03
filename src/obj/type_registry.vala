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
			this.register_type ("cfg_data", "");
			this.register_type ("compiler", "");
			this.register_type ("inc", "");
			this.register_type ("extracted_obj", "");
			this.register_type ("alias_tgt", "tgt");
			this.register_type ("build_tgt", "tgt");
			this.register_type ("dep", "");
			this.register_type ("file", "");
			this.register_type ("build_machine", "");
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
			this.register_type ("meson", "");
			this.register_type ("cfg_data", "");
			this.register_type ("disabler", "");
			this.register_type ("extracted_obj", "");
			this.register_type ("feature", "");
			this.register_type ("generated_list", "");
			this.register_type ("generator", "");
			this.register_type ("module", "");
			this.register_type ("range", "");
			this.register_type ("runresult", "");
			this.register_type ("structured_src", "");
			this.register_type ("subproject", "");
			this.find_type ("cfg_data")
				.register_method_v ("get",
					new ParameterListBuilder()
						.add_param (ElementaryType.STR, "varname")
						.add_variable_param ("default_value", new MesonType[]{
							new Elementary(ElementaryType.STR),
							new Elementary(ElementaryType.INT),
							new Elementary(ElementaryType.BOOL)
						})
					.build(), new MesonType[]{
						new Elementary(ElementaryType.STR),
						new Elementary(ElementaryType.INT),
						new Elementary(ElementaryType.BOOL)
					})
				.register_method_v ("get_unquoted",
					new ParameterListBuilder()
						.add_param (ElementaryType.STR, "varname")
						.add_variable_param ("default_value", new MesonType[]{
							new Elementary(ElementaryType.STR),
							new Elementary(ElementaryType.INT),
							new Elementary(ElementaryType.BOOL)
						})
					.build(), new MesonType[]{
						new Elementary(ElementaryType.STR),
						new Elementary(ElementaryType.INT),
						new Elementary(ElementaryType.BOOL)
					})
				.register_method ("has",
					new ParameterListBuilder()
						.add_param (ElementaryType.STR, "varname")
					.build(), new Elementary(ElementaryType.STR))
				.register_method ("keys", new Gee.ArrayList<Parameter>(), this.list(ElementaryType.STR))
				.register_method ("merge_from", new ParameterListBuilder().add_param1 (this.find_type("cfg_data"), "other").build(), new Elementary(ElementaryType.VOID))
				.register_method ("set", new ParameterListBuilder()
					.add_param (ElementaryType.STR, "varname")
					.add_variable_param ("default_value", new MesonType[]{
							new Elementary(ElementaryType.STR),
							new Elementary(ElementaryType.INT),
							new Elementary(ElementaryType.BOOL)
					})
					.add_kwarg (ElementaryType.STR, "description")
				.build(), new Elementary(ElementaryType.VOID))
				.register_method ("set10", new ParameterListBuilder()
					.add_param (ElementaryType.STR, "varname")
					.add_variable_param ("default_value", new MesonType[]{
							new Elementary(ElementaryType.INT),
							new Elementary(ElementaryType.BOOL)
					})
					.add_kwarg (ElementaryType.STR, "description")
				.build(), new Elementary(ElementaryType.VOID))
				.register_method ("set_quoted", new ParameterListBuilder()
					.add_param (ElementaryType.STR, "varname")
					.add_variable_param ("default_value", new MesonType[]{
							new Elementary(ElementaryType.STR),
							new Elementary(ElementaryType.INT),
							new Elementary(ElementaryType.BOOL)
					})
					.add_kwarg (ElementaryType.STR, "description")
				.build(), new Elementary(ElementaryType.VOID));
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
			this.find_type ("feature")
				.register_method ("allowed", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method ("auto", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method ("disable_auto_if", new ParameterListBuilder().add_param(ElementaryType.BOOL, "value").build(), this.find_type("feature"))
				.register_method ("disabled", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method ("enabled", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method ("require", new ParameterListBuilder().add_param(ElementaryType.BOOL, "value").add_kwarg (ElementaryType.STR, "error_message").build(), this.find_type("feature"));
			this.find_type ("generator")
				.register_method ("process", new ParameterListBuilder()
					.add_variable_param ("source", new MesonType[]{
							new Elementary(ElementaryType.STR),
							this.find_type ("file"),
							this.find_type ("custom_tgt"),
							this.find_type ("custom_idx"),
							this.find_type ("generated_list"),
					})
					.add_kwarg (ElementaryType.STR, "preserve_path_from")
					.build(), this.find_type ("generated_list"));
			this.find_type ("module")
				.register_method ("found", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL));
			this.find_type ("runresult")
				.register_method ("compiled", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method ("returncode", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.INT))
				.register_method ("stderr", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("stdout", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR));
			this.find_type ("subproject")
				.register_method ("found", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.BOOL))
				.register_method ("get_variable", new ParameterListBuilder()
					.add_param (ElementaryType.STR, "var_name")
					.add_param1 (this.list(ElementaryType.ANY), "fallback")
					.build(), new Elementary (ElementaryType.ANY));
			this.find_type ("compiler")
				.register_method ("alignment", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "typename")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), new Elementary(ElementaryType.INT))
				.register_method ("check_header", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "header_name")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
					.add_kwargv (new MesonType[]{new Elementary (ElementaryType.BOOL), this.find_type("feature")}, "required")
				.build(), new Elementary(ElementaryType.BOOL))
				.register_method ("cmd_array", new Gee.ArrayList<Parameter>(), this.list (ElementaryType.STR))
				.register_method ("compiles", new ParameterListBuilder ()
					.add_variable_param ("code", new MesonType[]{new Elementary(ElementaryType.STR), this.find_type("file")})
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), new Elementary(ElementaryType.BOOL))
				.register_method ("compute_int", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "expr")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwarg (ElementaryType.INT, "guess")
					.add_kwarg (ElementaryType.INT, "high")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.INT, "low")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), new Elementary(ElementaryType.INT))
				.register_method ("find_library", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "libname")
					.add_kwarg1 (this.list(ElementaryType.STR), "dirs")
					.add_kwarg (ElementaryType.BOOL, "disabler")
					.add_kwarg1 (this.list(ElementaryType.STR), "header_args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "header_dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "header_include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "header_prefix")
					.add_kwargv (new MesonType[]{new Elementary (ElementaryType.BOOL), this.find_type("feature")}, "required")
					.add_kwarg (ElementaryType.BOOL, "static")
				.build(), this.find_type("dep"))
				.register_method ("first_supported_link_argument", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "arg")
				.build(), this.list(ElementaryType.STR))
				.register_method ("get_argument_syntax", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("get_define", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "code")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), new Elementary(ElementaryType.STR))
				.register_method ("get_id", new Gee.ArrayList<Parameter>(), new Elementary(ElementaryType.STR))
				.register_method ("get_linker_id", new Gee.ArrayList<Parameter>(), new Elementary(ElementaryType.STR))
				.register_method ("get_supported_arguments", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "arg")
					.add_kwarg (ElementaryType.STR, "checked")
				.build(), this.list(ElementaryType.STR))
				.register_method ("get_supported_function_attributes", new Gee.ArrayList<Parameter>(), this.list(ElementaryType.STR))
				.register_method ("get_supported_link_arguments", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "arg")
				.build(), this.list(ElementaryType.STR))
				.register_method ("has_argument", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "arg")
				.build(), this.list(ElementaryType.BOOL))
				.register_method ("has_function", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "funcname")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), new Elementary(ElementaryType.BOOL))
				.register_method ("has_function_attribute", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "name")
				.build(), this.list(ElementaryType.BOOL))
				.register_method ("has_header", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "header_name")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
					.add_kwargv (new MesonType[]{new Elementary (ElementaryType.BOOL), this.find_type("feature")}, "required")
				.build(), new Elementary(ElementaryType.BOOL))
				.register_method ("has_header_symbol", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "header_name")
					.add_param (ElementaryType.STR, "symbol")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
					.add_kwargv (new MesonType[]{new Elementary (ElementaryType.BOOL), this.find_type("feature")}, "required")
				.build(), new Elementary(ElementaryType.BOOL))
				.register_method ("has_link_argument", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "name")
				.build(), this.list(ElementaryType.BOOL))
				.register_method ("has_member", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "typename")
					.add_param (ElementaryType.STR, "membername")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), new Elementary(ElementaryType.BOOL))
				.register_method ("has_members", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "typename")
					.add_param (ElementaryType.STR, "member")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), new Elementary(ElementaryType.BOOL))
				.register_method ("has_multi_arguments", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "arg")
				.build(), this.list(ElementaryType.BOOL))
				.register_method ("has_multi_link_arguments", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "arg")
				.build(), this.list(ElementaryType.BOOL))
				.register_method ("has_type", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "typename")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), new Elementary(ElementaryType.BOOL))
				.register_method ("links", new ParameterListBuilder ()
					.add_variable_param ("code", new MesonType[]{new Elementary(ElementaryType.STR), this.find_type("file")})
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), new Elementary(ElementaryType.BOOL))
				.register_method ("run", new ParameterListBuilder ()
					.add_variable_param ("code", new MesonType[]{new Elementary(ElementaryType.STR), this.find_type("file")})
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), this.find_type("runresult"))
				.register_method ("sizeof", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "typename")
					.add_kwarg1 (this.list(ElementaryType.STR), "args")
					.add_kwargv (new MesonType[]{this.find_type("dep"), this.list1(this.find_type("dep"))}, "dependencies")
					.add_kwargv (new MesonType[]{this.find_type("inc"), this.list1(this.find_type("inc"))}, "include_directories")
					.add_kwarg (ElementaryType.BOOL, "no_builtin_args")
					.add_kwarg (ElementaryType.STR, "prefix")
				.build(), new Elementary(ElementaryType.INT))
				.register_method ("symbols_have_underscore_prefix", new Gee.ArrayList<Parameter>(), new Elementary(ElementaryType.BOOL))
				.register_method ("symbols_have_underscore_prefix", new Gee.ArrayList<Parameter>(), new Elementary(ElementaryType.STR));
			this.find_type ("custom_idx")
				.register_method ("full_path", new Gee.ArrayList<Parameter>(), new Elementary(ElementaryType.STR));
			this.find_type ("custom_tgt")
				.register_method ("full_path", new Gee.ArrayList<Parameter>(), new Elementary(ElementaryType.STR))
				.register_method ("to_list", new Gee.ArrayList<Parameter>(), this.list1 (this.find_type("custom_idx")));
			this.find_type ("dep")
				.register_method ("link_as_whole", new Gee.ArrayList<Parameter>(), this.find_type("dep"))
				.register_method ("as_system", new ParameterListBuilder ()
					.add_param1 (this.list(ElementaryType.STR), "value")
				.build(), this.find_type("dep"))
				.register_method ("found", new Gee.ArrayList<Parameter>(), new Elementary(ElementaryType.BOOL))
				.register_method ("get_configtool_variable", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "var_name")
				.build(), new Elementary (ElementaryType.STR))
				.register_method ("get_pkgconfig_variable", new ParameterListBuilder ()
					.add_param (ElementaryType.STR, "var_name")
					.add_kwarg (ElementaryType.STR, "default")
					.add_kwarg1 (this.list(ElementaryType.STR), "prefix")
				.build(), new Elementary (ElementaryType.STR))
				.register_method ("get_variable", new ParameterListBuilder ()
					.add_param1 (this.list(ElementaryType.STR), "varname")
					.add_kwarg (ElementaryType.STR, "cmake")
					.add_kwarg (ElementaryType.STR, "configtool")
					.add_kwarg (ElementaryType.STR, "default_value")
					.add_kwarg (ElementaryType.STR, "internal")
					.add_kwarg (ElementaryType.STR, "pkgconfig")
					.add_kwarg1 (this.list(ElementaryType.STR), "pkgconfig_define")
				.build(), new Elementary (ElementaryType.STR))
				.register_method ("include_type", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("name", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("get_pkgconfig_variable", new ParameterListBuilder ()
					.add_param (ElementaryType.BOOL, "compile_args")
					.add_param (ElementaryType.BOOL, "includes")
					.add_param (ElementaryType.BOOL, "link_args")
					.add_param (ElementaryType.BOOL, "links")
					.add_param (ElementaryType.BOOL, "sources")
				.build(), this.find_type("dep"))
				.register_method ("type_name", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				.register_method ("version", new Gee.ArrayList<Parameter>(), new Elementary (ElementaryType.STR))
				;
			this.find_type ("disabler")
				.register_method ("found", new Gee.ArrayList<Parameter>(), new Elementary(ElementaryType.BOOL));

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
		MesonType list1 (MesonType t) {
			var l = new MList ();
			l.values.add (t);
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

		internal ParameterListBuilder add_kwarg1 (MesonType t, string name) {
			var p = new Parameter ();
			p.name = name;
			p.is_keyword = true;
			p.possible_types.add (t);
			this.arr.add (p);
			return this;
		}
		internal ParameterListBuilder add_kwargv (MesonType[] t, string name) {
			var p = new Parameter ();
			p.name = name;
			p.is_keyword = true;
			p.possible_types.add_all_array (t);
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
			m.return_type = new Gee.ArrayList<MesonType>();
			m.return_type.add (ret);
			this.methods.add (m);
			return this;
		}
		internal ObjectType register_method_v (string name, Gee.List<Parameter> args, MesonType[] ret) {
			var m = new Method ();
			m.parameters = args;
			m.name = name;
			m.return_type = new Gee.ArrayList<MesonType>();
			m.return_type.add_all_array (ret);
			this.methods.add (m);
			return this;
		}
	}

	internal class Method {
		internal string name;
		internal string doc;
		internal Gee.List<Parameter> parameters;
		internal bool varargs;
		internal Gee.List<MesonType> return_type;
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
