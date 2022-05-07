
// AUTO-Generated
namespace Meson {
	internal static void populate_typeregistry (TypeRegistry tr) {
		tr.register_type("alias_tgt", "tgt");
		tr.register_type("module", "");
		tr.register_type("int", "");
		tr.register_type("bool", "");
		tr.register_type("list", "");
		tr.register_type("void", "");
		tr.register_type("structured_src", "");
		tr.register_type("generator", "");
		tr.register_type("compiler", "");
		tr.register_type("external_program", "");
		tr.register_type("dep", "");
		tr.register_type("any", "");
		tr.register_type("cmake_options", "");
		tr.register_type("str", "");
		tr.register_type("custom_idx", "");
		tr.register_type("file", "");
		tr.register_type("inc", "");
		tr.register_type("tgt", "");
		tr.register_type("generated_list", "");
		tr.register_type("disabler", "");
		tr.register_type("cmake", "");
		tr.register_type("dict", "");
		tr.register_type("build_machine", "");
		tr.register_type("feature", "");
		tr.register_type("env", "");
		tr.register_type("cfg_data", "");
		tr.register_type("subproject", "");
		tr.register_type("extracted_obj", "");
		tr.register_type("meson", "");
		tr.register_type("runresult", "");
		tr.register_type("range", "");
		tr.register_type("target_machine", "build_machine");
		tr.register_type("both_libs", "lib");
		tr.register_type("lib", "build_tgt");
		tr.register_type("run_tgt", "tgt");
		tr.register_type("jar", "build_tgt");
		tr.register_type("exe", "build_tgt");
		tr.register_type("host_machine", "build_machine");
		tr.register_type("build_tgt", "tgt");
		tr.register_type("custom_tgt", "tgt");
		tr.register_function("add_global_link_arguments", new ParameterBuilder ()
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("language", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("range", new ParameterBuilder ()
				.register_argument ("start", new MesonType[] {new Elementary (ElementaryType.INT)}, true)
				.register_argument ("step", new MesonType[] {new Elementary (ElementaryType.INT)}, true)
				.register_argument ("stop", new MesonType[] {new Elementary (ElementaryType.INT)}, true)
			.build (), new MesonType[] {
								tr.find_type("range"),
			}, false);
		tr.register_function("environment", new ParameterBuilder ()
				.register_argument ("env", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.STR)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR)}), new Dictionary (new MesonType[]{new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})}, true)
				.register_kwarg_argument ("separator", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("method", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								tr.find_type("env"),
			}, false);
		tr.register_function("benchmark", new ParameterBuilder ()
				.register_argument ("name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("executable", new MesonType[] {tr.find_type("exe"), tr.find_type("jar"), tr.find_type("external_program"), tr.find_type("file")}, false)
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("tgt")})})
				.register_kwarg_argument ("should_fail", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("suite", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("timeout", new MesonType[] {new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("env", new MesonType[] {tr.find_type("env"), new MList (new MesonType[]{new Elementary (ElementaryType.STR)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("protocol", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("verbose", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("depends", new MesonType[] {new MList (new MesonType[]{tr.find_type("build_tgt"), tr.find_type("custom_tgt")})})
				.register_kwarg_argument ("priority", new MesonType[] {new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("workdir", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("subproject", new ParameterBuilder ()
				.register_argument ("subproject_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("required", new MesonType[] {new Elementary (ElementaryType.BOOL), tr.find_type("feature")})
				.register_kwarg_argument ("default_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("version", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								tr.find_type("subproject"),
			}, false);
		tr.register_function("unset_variable", new ParameterBuilder ()
				.register_argument ("varname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("install_man", new ParameterBuilder ()
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("locale", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("install_data", new ParameterBuilder ()
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("sources", new MesonType[] {new MList (new MesonType[]{tr.find_type("file"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("rename", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("subdir", new ParameterBuilder ()
				.register_argument ("dir_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("if_found", new MesonType[] {new MList (new MesonType[]{tr.find_type("dep")})})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("import", new ParameterBuilder ()
				.register_argument ("module_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("required", new MesonType[] {new Elementary (ElementaryType.BOOL), tr.find_type("feature")})
				.register_kwarg_argument ("disabler", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("module"),
			}, false);
		tr.register_function("get_option", new ParameterBuilder ()
				.register_argument ("option_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
				new Elementary (ElementaryType.INT),
				new Elementary (ElementaryType.BOOL),
				tr.find_type("feature"),
				new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)}),
			}, false);
		tr.register_function("build_target", new ParameterBuilder ()
				.register_argument ("target_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("implicit_include_directories", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("<lang>_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("pic", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("pie", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("rust_crate_type", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_whole", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("d_unittest", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("extra_files", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("name_suffix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("name_prefix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("main_class", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("override_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("win_subsystem", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_with", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("<lang>_pch", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("version", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("d_debug", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("build_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("implib", new MesonType[] {new Elementary (ElementaryType.BOOL), new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("include_directories", new MesonType[] {new MList (new MesonType[]{tr.find_type("inc"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("gui_app", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("soversion", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("d_import_dirs", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("darwin_versions", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("objects", new MesonType[] {new MList (new MesonType[]{tr.find_type("extracted_obj")})})
				.register_kwarg_argument ("gnu_symbol_visibility", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("export_dynamic", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("java_resources", new MesonType[] {tr.find_type("structured_src")})
				.register_kwarg_argument ("link_language", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("sources", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx"), tr.find_type("generated_list"), tr.find_type("structured_src")})
				.register_kwarg_argument ("build_by_default", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("target_type", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("prelink", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("vs_module_defs", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("d_module_versions", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_depends", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
			.build (), new MesonType[] {
								tr.find_type("build_tgt"),
			}, true);
		tr.register_function("test", new ParameterBuilder ()
				.register_argument ("name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("executable", new MesonType[] {tr.find_type("exe"), tr.find_type("jar"), tr.find_type("external_program"), tr.find_type("file")}, false)
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("tgt")})})
				.register_kwarg_argument ("should_fail", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("is_parallel", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("suite", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("timeout", new MesonType[] {new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("env", new MesonType[] {tr.find_type("env"), new MList (new MesonType[]{new Elementary (ElementaryType.STR)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("protocol", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("verbose", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("depends", new MesonType[] {new MList (new MesonType[]{tr.find_type("build_tgt"), tr.find_type("custom_tgt")})})
				.register_kwarg_argument ("priority", new MesonType[] {new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("workdir", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("project", new ParameterBuilder ()
				.register_argument ("project_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("default_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("meson_version", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("version", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file")})
				.register_kwarg_argument ("subproject_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("license", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("structured_sources", new ParameterBuilder ()
				.register_argument ("root", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx"), tr.find_type("generated_list")})}, false)
				.register_argument ("additional", new MesonType[] {new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx"), tr.find_type("generated_list")})}, true)
			.build (), new MesonType[] {
								tr.find_type("structured_src"),
			}, false);
		tr.register_function("dependency", new ParameterBuilder ()
				.register_kwarg_argument ("include_type", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("not_found_message", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("allow_fallback", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("required", new MesonType[] {new Elementary (ElementaryType.BOOL), tr.find_type("feature")})
				.register_kwarg_argument ("default_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("static", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("method", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("language", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("version", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("disabler", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("fallback", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)}), new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								tr.find_type("dep"),
			}, true);
		tr.register_function("configure_file", new ParameterBuilder ()
				.register_kwarg_argument ("format", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("configuration", new MesonType[] {tr.find_type("cfg_data"), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)})})
				.register_kwarg_argument ("depfile", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("copy", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("encoding", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("input", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file")})
				.register_kwarg_argument ("command", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), tr.find_type("file")})})
				.register_kwarg_argument ("install", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("output", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("output_format", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("capture", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("file"),
			}, false);
		tr.register_function("add_test_setup", new ParameterBuilder ()
				.register_argument ("name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("exe_wrapper", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), tr.find_type("external_program")})})
				.register_kwarg_argument ("timeout_multiplier", new MesonType[] {new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("exclude_suites", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("is_default", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("env", new MesonType[] {tr.find_type("env"), new MList (new MesonType[]{new Elementary (ElementaryType.STR)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("gdb", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("vcs_tag", new ParameterBuilder ()
				.register_kwarg_argument ("input", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("command", new MesonType[] {new MList (new MesonType[]{tr.find_type("exe"), tr.find_type("external_program"), tr.find_type("custom_tgt"), tr.find_type("file"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("fallback", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("output", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("replace_string", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								tr.find_type("custom_tgt"),
			}, false);
		tr.register_function("warning", new ParameterBuilder ()
				.register_argument ("text", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL), new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)})}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("install_emptydir", new ParameterBuilder ()
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("set_variable", new ParameterBuilder ()
				.register_argument ("variable_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("value", new MesonType[] {new Elementary (ElementaryType.ANY)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("subdir_done", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("include_directories", new ParameterBuilder ()
				.register_kwarg_argument ("is_system", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("inc"),
			}, true);
		tr.register_function("disabler", new ParameterBuilder ()
			.build (), new MesonType[] {
								tr.find_type("disabler"),
			}, false);
		tr.register_function("run_command", new ParameterBuilder ()
				.register_kwarg_argument ("env", new MesonType[] {tr.find_type("env"), new MList (new MesonType[]{new Elementary (ElementaryType.STR)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("capture", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("check", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("runresult"),
			}, true);
		tr.register_function("find_program", new ParameterBuilder ()
				.register_argument ("program_name", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file")}, false)
				.register_kwarg_argument ("dirs", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("required", new MesonType[] {new Elementary (ElementaryType.BOOL), tr.find_type("feature")})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("version", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("disabler", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("external_program"),
			}, true);
		tr.register_function("install_symlink", new ParameterBuilder ()
				.register_argument ("link_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("pointing_to", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("add_project_dependencies", new ParameterBuilder ()
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("language", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("debug", new ParameterBuilder ()
				.register_argument ("message", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL), new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)})}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("add_global_arguments", new ParameterBuilder ()
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("language", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("configuration_data", new ParameterBuilder ()
				.register_argument ("data", new MesonType[] {new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.BOOL), new Elementary (ElementaryType.INT)})}, true)
			.build (), new MesonType[] {
								tr.find_type("cfg_data"),
			}, false);
		tr.register_function("add_project_link_arguments", new ParameterBuilder ()
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("language", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("is_variable", new ParameterBuilder ()
				.register_argument ("var", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.register_function("join_paths", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, true);
		tr.register_function("message", new ParameterBuilder ()
				.register_argument ("text", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL), new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)})}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("library", new ParameterBuilder ()
				.register_argument ("target_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("implicit_include_directories", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("<lang>_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("pic", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("rust_crate_type", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_whole", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("d_unittest", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("extra_files", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("name_suffix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("name_prefix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("override_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("win_subsystem", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_with", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("<lang>_pch", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("version", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("d_debug", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("build_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("include_directories", new MesonType[] {new MList (new MesonType[]{tr.find_type("inc"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("gui_app", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("soversion", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("d_import_dirs", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("darwin_versions", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("objects", new MesonType[] {new MList (new MesonType[]{tr.find_type("extracted_obj")})})
				.register_kwarg_argument ("gnu_symbol_visibility", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_language", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("sources", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx"), tr.find_type("generated_list"), tr.find_type("structured_src")})
				.register_kwarg_argument ("build_by_default", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("prelink", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("vs_module_defs", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("d_module_versions", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_depends", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
			.build (), new MesonType[] {
								tr.find_type("lib"),
			}, true);
		tr.register_function("generator", new ParameterBuilder ()
				.register_argument ("exe", new MesonType[] {tr.find_type("exe"), tr.find_type("external_program")}, false)
				.register_kwarg_argument ("arguments", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("depfile", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("depends", new MesonType[] {new MList (new MesonType[]{tr.find_type("build_tgt"), tr.find_type("custom_tgt")})})
				.register_kwarg_argument ("output", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("capture", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("generator"),
			}, false);
		tr.register_function("install_subdir", new ParameterBuilder ()
				.register_argument ("subdir_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("exclude_files", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("exclude_directories", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("strip_directory", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("jar", new ParameterBuilder ()
				.register_argument ("target_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("implicit_include_directories", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("<lang>_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("rust_crate_type", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_whole", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("d_unittest", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("extra_files", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("name_suffix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("name_prefix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("main_class", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("override_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("win_subsystem", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_with", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("<lang>_pch", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("d_debug", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("build_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("include_directories", new MesonType[] {new MList (new MesonType[]{tr.find_type("inc"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("gui_app", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("d_import_dirs", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("objects", new MesonType[] {new MList (new MesonType[]{tr.find_type("extracted_obj")})})
				.register_kwarg_argument ("gnu_symbol_visibility", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("java_resources", new MesonType[] {tr.find_type("structured_src")})
				.register_kwarg_argument ("link_language", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("sources", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx"), tr.find_type("generated_list"), tr.find_type("structured_src")})
				.register_kwarg_argument ("build_by_default", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("d_module_versions", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_depends", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
			.build (), new MesonType[] {
								tr.find_type("jar"),
			}, true);
		tr.register_function("install_headers", new ParameterBuilder ()
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("subdir", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("shared_module", new ParameterBuilder ()
				.register_argument ("target_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("implicit_include_directories", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("<lang>_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("rust_crate_type", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_whole", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("d_unittest", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("extra_files", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("name_suffix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("name_prefix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("override_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("win_subsystem", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_with", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("<lang>_pch", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("d_debug", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("build_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("include_directories", new MesonType[] {new MList (new MesonType[]{tr.find_type("inc"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("gui_app", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("d_import_dirs", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("objects", new MesonType[] {new MList (new MesonType[]{tr.find_type("extracted_obj")})})
				.register_kwarg_argument ("gnu_symbol_visibility", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_language", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("sources", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx"), tr.find_type("generated_list"), tr.find_type("structured_src")})
				.register_kwarg_argument ("build_by_default", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("vs_module_defs", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("d_module_versions", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_depends", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
			.build (), new MesonType[] {
								tr.find_type("build_tgt"),
			}, true);
		tr.register_function("static_library", new ParameterBuilder ()
				.register_argument ("target_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("implicit_include_directories", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("<lang>_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("pic", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("rust_crate_type", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_whole", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("d_unittest", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("extra_files", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("name_suffix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("name_prefix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("override_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("win_subsystem", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_with", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("<lang>_pch", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("d_debug", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("build_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("include_directories", new MesonType[] {new MList (new MesonType[]{tr.find_type("inc"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("gui_app", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("d_import_dirs", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("objects", new MesonType[] {new MList (new MesonType[]{tr.find_type("extracted_obj")})})
				.register_kwarg_argument ("gnu_symbol_visibility", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_language", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("sources", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx"), tr.find_type("generated_list"), tr.find_type("structured_src")})
				.register_kwarg_argument ("build_by_default", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("prelink", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("d_module_versions", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_depends", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
			.build (), new MesonType[] {
								tr.find_type("lib"),
			}, true);
		tr.register_function("add_project_arguments", new ParameterBuilder ()
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("language", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("alias_target", new ParameterBuilder ()
				.register_argument ("target_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								tr.find_type("alias_tgt"),
			}, true);
		tr.register_function("run_target", new ParameterBuilder ()
				.register_argument ("target_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("env", new MesonType[] {tr.find_type("env"), new MList (new MesonType[]{new Elementary (ElementaryType.STR)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("command", new MesonType[] {new MList (new MesonType[]{tr.find_type("exe"), tr.find_type("external_program"), tr.find_type("custom_tgt"), tr.find_type("file"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("depends", new MesonType[] {new MList (new MesonType[]{tr.find_type("build_tgt"), tr.find_type("custom_tgt")})})
			.build (), new MesonType[] {
								tr.find_type("run_tgt"),
			}, false);
		tr.register_function("declare_dependency", new ParameterBuilder ()
				.register_kwarg_argument ("compile_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("include_directories", new MesonType[] {new MList (new MesonType[]{tr.find_type("inc"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("variables", new MesonType[] {new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR)}), new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_with", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib")})})
				.register_kwarg_argument ("sources", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), tr.find_type("file")})})
				.register_kwarg_argument ("d_import_dirs", new MesonType[] {new MList (new MesonType[]{tr.find_type("inc"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_whole", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib")})})
				.register_kwarg_argument ("d_module_versions", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("version", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								tr.find_type("dep"),
			}, false);
		tr.register_function("assert", new ParameterBuilder ()
				.register_argument ("condition", new MesonType[] {new Elementary (ElementaryType.BOOL)}, false)
				.register_argument ("message", new MesonType[] {new Elementary (ElementaryType.STR)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("both_libraries", new ParameterBuilder ()
				.register_argument ("target_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("implicit_include_directories", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("<lang>_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("pic", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("rust_crate_type", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_whole", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("d_unittest", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("extra_files", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("name_suffix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("name_prefix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("override_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("win_subsystem", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_with", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("<lang>_pch", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("version", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("d_debug", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("build_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("include_directories", new MesonType[] {new MList (new MesonType[]{tr.find_type("inc"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("gui_app", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("soversion", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("d_import_dirs", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("darwin_versions", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("objects", new MesonType[] {new MList (new MesonType[]{tr.find_type("extracted_obj")})})
				.register_kwarg_argument ("gnu_symbol_visibility", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_language", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("sources", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx"), tr.find_type("generated_list"), tr.find_type("structured_src")})
				.register_kwarg_argument ("build_by_default", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("prelink", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("vs_module_defs", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("d_module_versions", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_depends", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
			.build (), new MesonType[] {
								tr.find_type("both_libs"),
			}, true);
		tr.register_function("is_disabler", new ParameterBuilder ()
				.register_argument ("var", new MesonType[] {new Elementary (ElementaryType.ANY)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.register_function("add_languages", new ParameterBuilder ()
				.register_kwarg_argument ("required", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, true);
		tr.register_function("custom_target", new ParameterBuilder ()
				.register_argument ("name", new MesonType[] {new Elementary (ElementaryType.STR)}, true)
				.register_kwarg_argument ("depend_files", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), tr.find_type("file")})})
				.register_kwarg_argument ("build_always_stale", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("depfile", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_tag", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("env", new MesonType[] {tr.find_type("env"), new MList (new MesonType[]{new Elementary (ElementaryType.STR)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("feed", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("input", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), tr.find_type("file")})})
				.register_kwarg_argument ("build_by_default", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("command", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("exe"), tr.find_type("external_program")})})
				.register_kwarg_argument ("depends", new MesonType[] {new MList (new MesonType[]{tr.find_type("build_tgt"), tr.find_type("custom_tgt")})})
				.register_kwarg_argument ("install", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("output", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("build_always", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("capture", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("console", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("custom_tgt"),
			}, false);
		tr.register_function("files", new ParameterBuilder ()
			.build (), new MesonType[] {
								new MList (new MesonType[]{tr.find_type("file")}),
			}, true);
		tr.register_function("error", new ParameterBuilder ()
				.register_argument ("message", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.register_function("shared_library", new ParameterBuilder ()
				.register_argument ("target_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("implicit_include_directories", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("<lang>_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("rust_crate_type", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_whole", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("d_unittest", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("extra_files", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("name_suffix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("name_prefix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("override_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("win_subsystem", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_with", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("<lang>_pch", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("version", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("d_debug", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("build_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("include_directories", new MesonType[] {new MList (new MesonType[]{tr.find_type("inc"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("soversion", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("gui_app", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("d_import_dirs", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("darwin_versions", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("objects", new MesonType[] {new MList (new MesonType[]{tr.find_type("extracted_obj")})})
				.register_kwarg_argument ("gnu_symbol_visibility", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_language", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("sources", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx"), tr.find_type("generated_list"), tr.find_type("structured_src")})
				.register_kwarg_argument ("build_by_default", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("vs_module_defs", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("d_module_versions", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_depends", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
			.build (), new MesonType[] {
								tr.find_type("lib"),
			}, true);
		tr.register_function("summary", new ParameterBuilder ()
				.register_argument ("key_or_dict", new MesonType[] {new Elementary (ElementaryType.STR), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.BOOL), new Elementary (ElementaryType.INT), tr.find_type("dep"), tr.find_type("external_program"), new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.BOOL), new Elementary (ElementaryType.INT), tr.find_type("dep"), tr.find_type("external_program")})})}, false)
				.register_argument ("value", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.BOOL), new Elementary (ElementaryType.INT), tr.find_type("dep"), tr.find_type("external_program"), new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.BOOL), new Elementary (ElementaryType.INT), tr.find_type("dep"), tr.find_type("external_program")})}, true)
				.register_kwarg_argument ("bool_yn", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("list_sep", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("section", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.register_function("executable", new ParameterBuilder ()
				.register_argument ("target_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("implicit_include_directories", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("<lang>_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("pie", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("rust_crate_type", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_whole", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("d_unittest", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("extra_files", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
				.register_kwarg_argument ("name_suffix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("name_prefix", new MesonType[] {new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.VOID)})})
				.register_kwarg_argument ("override_options", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("win_subsystem", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("link_with", new MesonType[] {new MList (new MesonType[]{tr.find_type("lib"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})})
				.register_kwarg_argument ("<lang>_pch", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("d_debug", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("build_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("implib", new MesonType[] {new Elementary (ElementaryType.BOOL), new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("include_directories", new MesonType[] {new MList (new MesonType[]{tr.find_type("inc"), new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install_dir", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("install_mode", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT)})})
				.register_kwarg_argument ("gui_app", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("d_import_dirs", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("install_rpath", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("objects", new MesonType[] {new MList (new MesonType[]{tr.find_type("extracted_obj")})})
				.register_kwarg_argument ("gnu_symbol_visibility", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("export_dynamic", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("link_language", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("sources", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx"), tr.find_type("generated_list"), tr.find_type("structured_src")})
				.register_kwarg_argument ("build_by_default", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("d_module_versions", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("link_depends", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")})
			.build (), new MesonType[] {
								tr.find_type("exe"),
			}, true);
		tr.register_function("get_variable", new ParameterBuilder ()
				.register_argument ("variable_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("default", new MesonType[] {new Elementary (ElementaryType.ANY)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.ANY),
			}, false);
		tr.find_type("runresult").register_function("returncode", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.INT),
			}, false);
		tr.find_type("runresult").register_function("compiled", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("runresult").register_function("stderr", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("runresult").register_function("stdout", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("add_postconf_script", new ParameterBuilder ()
				.register_argument ("script_name", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("external_program")}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.find_type("meson").register_function("global_source_root", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("override_dependency", new ParameterBuilder ()
				.register_argument ("dep_object", new MesonType[] {tr.find_type("dep")}, false)
				.register_argument ("name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("static", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.find_type("meson").register_function("project_build_root", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("add_dist_script", new ParameterBuilder ()
				.register_argument ("script_name", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("external_program")}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.find_type("meson").register_function("source_root", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("current_build_dir", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("get_compiler", new ParameterBuilder ()
				.register_argument ("language", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("compiler"),
			}, false);
		tr.find_type("meson").register_function("has_exe_wrapper", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("meson").register_function("get_external_property", new ParameterBuilder ()
				.register_argument ("propname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("fallback_value", new MesonType[] {new Elementary (ElementaryType.ANY)}, true)
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.ANY),
			}, false);
		tr.find_type("meson").register_function("is_unity", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("meson").register_function("build_root", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("get_cross_property", new ParameterBuilder ()
				.register_argument ("propname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("fallback_value", new MesonType[] {new Elementary (ElementaryType.ANY)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.ANY),
			}, false);
		tr.find_type("meson").register_function("install_dependency_manifest", new ParameterBuilder ()
				.register_argument ("output_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.find_type("meson").register_function("is_cross_build", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("meson").register_function("override_find_program", new ParameterBuilder ()
				.register_argument ("progname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("program", new MesonType[] {tr.find_type("exe"), tr.find_type("file"), tr.find_type("external_program")}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.find_type("meson").register_function("project_version", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("version", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("can_run_host_binaries", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("meson").register_function("add_install_script", new ParameterBuilder ()
				.register_argument ("script_name", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file"), tr.find_type("external_program"), tr.find_type("exe"), tr.find_type("custom_tgt"), tr.find_type("custom_idx")}, false)
				.register_kwarg_argument ("skip_if_destdir", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("install_tag", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.find_type("meson").register_function("add_devenv", new ParameterBuilder ()
				.register_argument ("env", new MesonType[] {tr.find_type("env"), new Elementary (ElementaryType.STR), new MList (new MesonType[]{new Elementary (ElementaryType.STR)}), new Dictionary (new MesonType[]{new Elementary (ElementaryType.STR)}), new Dictionary (new MesonType[]{new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})}, false)
				.register_kwarg_argument ("separator", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("method", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.find_type("meson").register_function("backend", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("current_source_dir", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("global_build_root", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("project_license", new ParameterBuilder ()
			.build (), new MesonType[] {
								new MList (new MesonType[]{new Elementary (ElementaryType.STR)}),
			}, false);
		tr.find_type("meson").register_function("project_name", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("project_source_root", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("meson").register_function("has_external_property", new ParameterBuilder ()
				.register_argument ("propname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("native", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("meson").register_function("is_subproject", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("subproject").register_function("get_variable", new ParameterBuilder ()
				.register_argument ("var_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("fallback", new MesonType[] {new Elementary (ElementaryType.ANY)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.ANY),
			}, false);
		tr.find_type("subproject").register_function("found", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("cfg_data").register_function("keys", new ParameterBuilder ()
			.build (), new MesonType[] {
								new MList (new MesonType[]{new Elementary (ElementaryType.STR)}),
			}, false);
		tr.find_type("cfg_data").register_function("set_quoted", new ParameterBuilder ()
				.register_argument ("value", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)}, false)
				.register_argument ("varname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("description", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.find_type("cfg_data").register_function("get_unquoted", new ParameterBuilder ()
				.register_argument ("varname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("default_value", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
				new Elementary (ElementaryType.INT),
				new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("cfg_data").register_function("has", new ParameterBuilder ()
				.register_argument ("varname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("cfg_data").register_function("get", new ParameterBuilder ()
				.register_argument ("varname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("default_value", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
				new Elementary (ElementaryType.INT),
				new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("cfg_data").register_function("set", new ParameterBuilder ()
				.register_argument ("value", new MesonType[] {new Elementary (ElementaryType.STR), new Elementary (ElementaryType.INT), new Elementary (ElementaryType.BOOL)}, false)
				.register_argument ("varname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("description", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.find_type("cfg_data").register_function("set10", new ParameterBuilder ()
				.register_argument ("value", new MesonType[] {new Elementary (ElementaryType.BOOL), new Elementary (ElementaryType.INT)}, false)
				.register_argument ("varname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("description", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.find_type("cfg_data").register_function("merge_from", new ParameterBuilder ()
				.register_argument ("other", new MesonType[] {tr.find_type("cfg_data")}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, false);
		tr.find_type("env").register_function("prepend", new ParameterBuilder ()
				.register_argument ("variable", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("separator", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.find_type("env").register_function("set", new ParameterBuilder ()
				.register_argument ("variable", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("separator", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.find_type("env").register_function("append", new ParameterBuilder ()
				.register_argument ("variable", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("separator", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.find_type("feature").register_function("require", new ParameterBuilder ()
				.register_argument ("value", new MesonType[] {new Elementary (ElementaryType.BOOL)}, false)
				.register_kwarg_argument ("error_message", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								tr.find_type("feature"),
			}, false);
		tr.find_type("feature").register_function("disabled", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("feature").register_function("enabled", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("feature").register_function("disable_auto_if", new ParameterBuilder ()
				.register_argument ("value", new MesonType[] {new Elementary (ElementaryType.BOOL)}, false)
			.build (), new MesonType[] {
								tr.find_type("feature"),
			}, false);
		tr.find_type("feature").register_function("auto", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("feature").register_function("allowed", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("build_machine").register_function("system", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("build_machine").register_function("endian", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("build_machine").register_function("cpu", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("build_machine").register_function("cpu_family", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("dict").register_function("has_key", new ParameterBuilder ()
				.register_argument ("key", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("dict").register_function("keys", new ParameterBuilder ()
			.build (), new MesonType[] {
								new MList (new MesonType[]{new Elementary (ElementaryType.STR)}),
			}, false);
		tr.find_type("dict").register_function("get", new ParameterBuilder ()
				.register_argument ("key", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("fallback", new MesonType[] {new Elementary (ElementaryType.ANY)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.ANY),
			}, false);
		tr.find_type("cmake").register_function("subproject_options", new ParameterBuilder ()
			.build (), new MesonType[] {
								tr.find_type("cmake_options"),
			}, false);
		tr.find_type("disabler").register_function("found", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("custom_idx").register_function("full_path", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("both_libs").register_function("get_static_lib", new ParameterBuilder ()
			.build (), new MesonType[] {
								tr.find_type("lib"),
			}, false);
		tr.find_type("both_libs").register_function("get_shared_lib", new ParameterBuilder ()
			.build (), new MesonType[] {
								tr.find_type("lib"),
			}, false);
		tr.find_type("str").register_function("substring", new ParameterBuilder ()
				.register_argument ("end", new MesonType[] {new Elementary (ElementaryType.INT)}, true)
				.register_argument ("start", new MesonType[] {new Elementary (ElementaryType.INT)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("str").register_function("underscorify", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("str").register_function("replace", new ParameterBuilder ()
				.register_argument ("old", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("new", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("str").register_function("format", new ParameterBuilder ()
				.register_argument ("fmt", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, true);
		tr.find_type("str").register_function("strip", new ParameterBuilder ()
				.register_argument ("strip_chars", new MesonType[] {new Elementary (ElementaryType.STR)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("str").register_function("to_lower", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("str").register_function("to_upper", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("str").register_function("contains", new ParameterBuilder ()
				.register_argument ("fragment", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("str").register_function("join", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, true);
		tr.find_type("str").register_function("version_compare", new ParameterBuilder ()
				.register_argument ("compare_string", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("str").register_function("endswith", new ParameterBuilder ()
				.register_argument ("fragment", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("str").register_function("split", new ParameterBuilder ()
				.register_argument ("split_string", new MesonType[] {new Elementary (ElementaryType.STR)}, true)
			.build (), new MesonType[] {
								new MList (new MesonType[]{new Elementary (ElementaryType.STR)}),
			}, false);
		tr.find_type("str").register_function("to_int", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.INT),
			}, false);
		tr.find_type("str").register_function("startswith", new ParameterBuilder ()
				.register_argument ("fragment", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("cmake_options").register_function("add_cmake_defines", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.VOID),
			}, true);
		tr.find_type("dep").register_function("include_type", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("dep").register_function("as_link_whole", new ParameterBuilder ()
			.build (), new MesonType[] {
								tr.find_type("dep"),
			}, false);
		tr.find_type("dep").register_function("get_variable", new ParameterBuilder ()
				.register_argument ("varname", new MesonType[] {new Elementary (ElementaryType.STR)}, true)
				.register_kwarg_argument ("cmake", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("configtool", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("pkgconfig_define", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("internal", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("pkgconfig", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("default_value", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("dep").register_function("found", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("dep").register_function("get_pkgconfig_variable", new ParameterBuilder ()
				.register_argument ("var_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("define_variable", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("default", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("dep").register_function("as_system", new ParameterBuilder ()
				.register_argument ("value", new MesonType[] {new Elementary (ElementaryType.STR)}, true)
			.build (), new MesonType[] {
								tr.find_type("dep"),
			}, false);
		tr.find_type("dep").register_function("type_name", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("dep").register_function("version", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("dep").register_function("get_configtool_variable", new ParameterBuilder ()
				.register_argument ("var_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("dep").register_function("name", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("dep").register_function("partial_dependency", new ParameterBuilder ()
				.register_kwarg_argument ("compile_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("includes", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("link_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("sources", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("links", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("dep"),
			}, false);
		tr.find_type("external_program").register_function("full_path", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("external_program").register_function("path", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("external_program").register_function("found", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("external_program").register_function("version", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("compiler").register_function("get_supported_arguments", new ParameterBuilder ()
				.register_kwarg_argument ("checked", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new MList (new MesonType[]{new Elementary (ElementaryType.STR)}),
			}, true);
		tr.find_type("compiler").register_function("get_supported_function_attributes", new ParameterBuilder ()
			.build (), new MesonType[] {
								new MList (new MesonType[]{new Elementary (ElementaryType.STR)}),
			}, false);
		tr.find_type("compiler").register_function("has_type", new ParameterBuilder ()
				.register_argument ("typename", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("run", new ParameterBuilder ()
				.register_argument ("code", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file")}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("name", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("runresult"),
			}, false);
		tr.find_type("compiler").register_function("symbols_have_underscore_prefix", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("alignment", new ParameterBuilder ()
				.register_argument ("typename", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.INT),
			}, false);
		tr.find_type("compiler").register_function("get_supported_link_arguments", new ParameterBuilder ()
			.build (), new MesonType[] {
								new MList (new MesonType[]{new Elementary (ElementaryType.STR)}),
			}, true);
		tr.find_type("compiler").register_function("has_members", new ParameterBuilder ()
				.register_argument ("typename", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, true);
		tr.find_type("compiler").register_function("has_multi_arguments", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, true);
		tr.find_type("compiler").register_function("check_header", new ParameterBuilder ()
				.register_argument ("header_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("required", new MesonType[] {new Elementary (ElementaryType.BOOL), tr.find_type("feature")})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("first_supported_link_argument", new ParameterBuilder ()
			.build (), new MesonType[] {
								new MList (new MesonType[]{new Elementary (ElementaryType.STR)}),
			}, true);
		tr.find_type("compiler").register_function("get_argument_syntax", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("compiler").register_function("has_function", new ParameterBuilder ()
				.register_argument ("funcname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("has_function_attribute", new ParameterBuilder ()
				.register_argument ("name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("has_header_symbol", new ParameterBuilder ()
				.register_argument ("symbol", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("header", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("required", new MesonType[] {new Elementary (ElementaryType.BOOL), tr.find_type("feature")})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("has_argument", new ParameterBuilder ()
				.register_argument ("argument", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("cmd_array", new ParameterBuilder ()
			.build (), new MesonType[] {
								new MList (new MesonType[]{new Elementary (ElementaryType.STR)}),
			}, false);
		tr.find_type("compiler").register_function("get_linker_id", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("compiler").register_function("has_header", new ParameterBuilder ()
				.register_argument ("header_name", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("required", new MesonType[] {new Elementary (ElementaryType.BOOL), tr.find_type("feature")})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("has_member", new ParameterBuilder ()
				.register_argument ("membername", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_argument ("typename", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("has_multi_link_arguments", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, true);
		tr.find_type("compiler").register_function("sizeof", new ParameterBuilder ()
				.register_argument ("typename", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.INT),
			}, false);
		tr.find_type("compiler").register_function("version", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("compiler").register_function("compiles", new ParameterBuilder ()
				.register_argument ("code", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file")}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("name", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("links", new ParameterBuilder ()
				.register_argument ("code", new MesonType[] {new Elementary (ElementaryType.STR), tr.find_type("file")}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("name", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("compiler").register_function("find_library", new ParameterBuilder ()
				.register_argument ("libname", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("header_prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("dirs", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("required", new MesonType[] {new Elementary (ElementaryType.BOOL), tr.find_type("feature")})
				.register_kwarg_argument ("header_dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("static", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("header_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("header_include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("disabler", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("header_no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
				.register_kwarg_argument ("has_headers", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
			.build (), new MesonType[] {
								tr.find_type("dep"),
			}, false);
		tr.find_type("compiler").register_function("first_supported_argument", new ParameterBuilder ()
			.build (), new MesonType[] {
								new MList (new MesonType[]{new Elementary (ElementaryType.STR)}),
			}, true);
		tr.find_type("compiler").register_function("get_define", new ParameterBuilder ()
				.register_argument ("definename", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("compiler").register_function("get_id", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("compiler").register_function("compute_int", new ParameterBuilder ()
				.register_argument ("expr", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
				.register_kwarg_argument ("dependencies", new MesonType[] {tr.find_type("dep"), new MList (new MesonType[]{tr.find_type("dep")})})
				.register_kwarg_argument ("include_directories", new MesonType[] {tr.find_type("inc"), new MList (new MesonType[]{tr.find_type("inc")})})
				.register_kwarg_argument ("args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("high", new MesonType[] {new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("prefix", new MesonType[] {new Elementary (ElementaryType.STR)})
				.register_kwarg_argument ("guess", new MesonType[] {new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("low", new MesonType[] {new Elementary (ElementaryType.INT)})
				.register_kwarg_argument ("no_builtin_args", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								new Elementary (ElementaryType.INT),
			}, false);
		tr.find_type("compiler").register_function("has_link_argument", new ParameterBuilder ()
				.register_argument ("argument", new MesonType[] {new Elementary (ElementaryType.STR)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("generator").register_function("process", new ParameterBuilder ()
				.register_kwarg_argument ("extra_args", new MesonType[] {new MList (new MesonType[]{new Elementary (ElementaryType.STR)})})
				.register_kwarg_argument ("preserve_path_from", new MesonType[] {new Elementary (ElementaryType.STR)})
			.build (), new MesonType[] {
								tr.find_type("generated_list"),
			}, true);
		tr.find_type("list").register_function("get", new ParameterBuilder ()
				.register_argument ("index", new MesonType[] {new Elementary (ElementaryType.INT)}, false)
				.register_argument ("fallback", new MesonType[] {new Elementary (ElementaryType.ANY)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.ANY),
			}, false);
		tr.find_type("list").register_function("contains", new ParameterBuilder ()
				.register_argument ("item", new MesonType[] {new Elementary (ElementaryType.ANY)}, false)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("list").register_function("length", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.INT),
			}, false);
		tr.find_type("build_tgt").register_function("extract_all_objects", new ParameterBuilder ()
				.register_kwarg_argument ("recursive", new MesonType[] {new Elementary (ElementaryType.BOOL)})
			.build (), new MesonType[] {
								tr.find_type("extracted_obj"),
			}, false);
		tr.find_type("build_tgt").register_function("full_path", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("build_tgt").register_function("private_dir_include", new ParameterBuilder ()
			.build (), new MesonType[] {
								tr.find_type("inc"),
			}, false);
		tr.find_type("build_tgt").register_function("path", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("build_tgt").register_function("found", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("build_tgt").register_function("extract_objects", new ParameterBuilder ()
			.build (), new MesonType[] {
								tr.find_type("extracted_obj"),
			}, true);
		tr.find_type("build_tgt").register_function("name", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("custom_tgt").register_function("full_path", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("custom_tgt").register_function("to_list", new ParameterBuilder ()
			.build (), new MesonType[] {
								new MList (new MesonType[]{tr.find_type("custom_idx")}),
			}, false);
		tr.find_type("custom_tgt").register_function("[index]", new ParameterBuilder ()
			.build (), new MesonType[] {
								tr.find_type("custom_idx"),
			}, false);
		tr.find_type("bool").register_function("to_int", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.INT),
			}, false);
		tr.find_type("bool").register_function("to_string", new ParameterBuilder ()
				.register_argument ("true_str", new MesonType[] {new Elementary (ElementaryType.STR)}, true)
				.register_argument ("false_str", new MesonType[] {new Elementary (ElementaryType.STR)}, true)
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("int").register_function("is_even", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("int").register_function("is_odd", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);
		tr.find_type("int").register_function("to_string", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.STR),
			}, false);
		tr.find_type("module").register_function("found", new ParameterBuilder ()
			.build (), new MesonType[] {
								new Elementary (ElementaryType.BOOL),
			}, false);

	}
}
