/* module_populate.vala
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
	internal static void populate_typeregistry_modules (TypeRegistry tr) {
		tr.register_type ("cmake_module", "module");
		tr.register_type ("cuda_module", "module");
		tr.register_type ("dlang_module", "module");
		tr.register_type ("fs_module", "module");
		tr.register_type ("gnome_module", "module");
		tr.register_type ("python_installation", "external_program");
		tr.register_type ("python_dependency", "dep");
		tr.find_type("gnome_module").register_function("compile_resources", new ParameterBuilder ()
				.register_argument ("id", new MesonType[] {Elementary.STR}, false)
				.register_kwarg_argument ("input_file", new MesonType[] {Elementary.ANY, tr.find_type ("file")}, true)
				.register_kwarg_argument ("build_by_default", new MesonType[] {Elementary.BOOL}, true)
				.register_kwarg_argument ("c_name", new MesonType[] {Elementary.STR}, true)
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList(new MesonType[] {tr.find_type ("file"), tr.find_type("custom_tgt"), tr.find_type ("custom_idx")})}, true)
				.register_kwarg_argument ("export", new MesonType[] {Elementary.BOOL}, true)
				.register_kwarg_argument ("extra_args", new MesonType[] {new MList(new MesonType[]{Elementary.STR})}, true)
				.register_kwarg_argument ("gresource_bundle", new MesonType[] {Elementary.BOOL}, true)
				.register_kwarg_argument ("install_dir", new MesonType[] {Elementary.STR}, true)
				.register_kwarg_argument ("source_dir", new MesonType[] {new MList(new MesonType[]{Elementary.STR})}, true)
			.build (), new MesonType[] {
								new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			}, false);
		tr.find_type ("gnome_module").register_function ("generate_gir", new ParameterBuilder ()
				.register_argument ("libs", new MesonType[] {tr.find_type ("exe"), tr.find_type ("lib")}, false, false)
				.register_kwarg_argument ("dependencies", new MesonType[] {new MList (new MesonType[]{tr.find_type ("dep")})})
				.register_kwarg_argument ("export_packages", new MesonType[] {new MList (new MesonType[]{Elementary.STR})})
				.register_kwarg_argument ("fatal_warnings", new MesonType[] {Elementary.BOOL})
				.register_kwarg_argument ("header", new MesonType[] {new MList (new MesonType[]{Elementary.STR})})
				.register_kwarg_argument ("identifier_prefix", new MesonType[] {new MList (new MesonType[]{Elementary.STR})})
				.register_kwarg_argument ("include_directories", new MesonType[] {new MList (new MesonType[]{Elementary.STR, tr.find_type ("inc")})})
				.register_kwarg_argument ("install", new MesonType[] {Elementary.BOOL})
				.register_kwarg_argument ("install_gir", new MesonType[] {Elementary.BOOL})
				.register_kwarg_argument ("install_dir_gir", new MesonType[] {Elementary.BOOL, Elementary.STR})
				.register_kwarg_argument ("link_with", new MesonType[] {new MList(new MesonType[]{tr.find_type ("lib")})})
				.register_kwarg_argument ("namespace", new MesonType[] {Elementary.STR}, false)
				.register_kwarg_argument ("nsversion", new MesonType[] {Elementary.STR}, false)
				.register_kwarg_argument ("sources", new MesonType[] {new MList (new MesonType[] {Elementary.STR, tr.find_type ("file"), tr.find_type ("generated_list"), tr.find_type ("custom_tgt"), tr.find_type ("custom_idx")})})
				.register_kwarg_argument ("symbol_prefix", new MesonType[] {new MList(new MesonType[] {Elementary.STR})})
			.build (), new MesonType[] {
								new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			}, true);
		tr.find_type ("gnome_module").register_function ("genmarshal", new ParameterBuilder ()
				.register_argument ("basename", new MesonType[] {Elementary.STR})
			.build (), new MesonType[] {
								new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			});
		tr.find_type ("gnome_module").register_function ("mkenums", new ParameterBuilder ()
				.register_argument ("basename", new MesonType[] {Elementary.STR})
			.build (), new MesonType[] {
								new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			});
		tr.find_type ("gnome_module").register_function ("mkenums_simple", new ParameterBuilder ()
				.register_argument ("basename", new MesonType[] {Elementary.STR})
			.build (), new MesonType[] {
								new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			});
		tr.find_type ("gnome_module").register_function ("compile_schemas", new ParameterBuilder ()
				.register_argument ("basename", new MesonType[] {Elementary.STR})
			.build (), new MesonType[] {
								new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			});
		tr.find_type ("gnome_module").register_function ("gdbus_codegen", new ParameterBuilder ()
				.register_argument ("basename", new MesonType[] {Elementary.STR})
			.build (), new MesonType[] {
								new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			});
		tr.find_type ("gnome_module").register_function ("generate_vapi", new ParameterBuilder ()
				.register_argument ("basename", new MesonType[] {Elementary.STR})
			.build (), new MesonType[] {
								tr.find_type ("dep"),
			});
		tr.find_type ("gnome_module").register_function ("yelp", new ParameterBuilder ()
				.register_argument ("basename", new MesonType[] {Elementary.STR})
			.build (), new MesonType[] {
								new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			});
		tr.find_type ("gnome_module").register_function ("gtkdoc", new ParameterBuilder ()
				.register_argument ("basename", new MesonType[] {Elementary.STR})
			.build (), new MesonType[] {
								tr.find_type ("tgt"),
			});
		tr.find_type ("gnome_module").register_function ("gtkdoc_html_dir", new ParameterBuilder ()
			.build (), new MesonType[] {
								Elementary.STR,
			});
		tr.find_type ("gnome_module").register_function ("post_install", new ParameterBuilder ()
			.build (), new MesonType[] {
			});
		tr.register_type ("hotdoc_module", "module");
		tr.register_type ("i18n_module", "module");
		tr.find_type ("i18n_module").register_function ("gettext", new ParameterBuilder ()
			.build (), new MesonType[] {
				new MList(new MesonType[] {tr.find_type ("run_tgt"), tr.find_type ("alias_tgt")}),
			});
		tr.find_type ("i18n_module").register_function ("merge_file", new ParameterBuilder ()
			.build (), new MesonType[] {
				new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			});
		tr.find_type ("i18n_module").register_function ("itstool_join", new ParameterBuilder ()
			.build (), new MesonType[] {
				new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			});
		tr.register_type ("icestorm_module", "module");
		tr.register_type ("java_module", "module");
		tr.register_type ("keyval_module", "module");
		tr.register_type ("pkgconfig_module", "module");
		tr.register_type ("python_module", "module");
		tr.find_type ("pkgconfig_module").register_function ("generate", new ParameterBuilder ()
			.build (), new MesonType[] {
				new MList(new MesonType[] {tr.find_type ("custom_tgt")}),
			});
		tr.register_type ("python3_module", "module");
		tr.find_type ("python_module").register_function ("find_installation", new ParameterBuilder ()
			.build (), new MesonType[] {
				tr.find_type ("python_installation"),
			});
		tr.find_type ("python_installation").register_function ("path", new ParameterBuilder ()
			.build (), new MesonType[] {
				Elementary.STR
			});
		tr.find_type ("python_installation").register_function ("extension_module", new ParameterBuilder ()
			.build (), new MesonType[] {
				tr.find_type("build_tgt")
			});
		tr.find_type ("python_installation").register_function ("dependency", new ParameterBuilder ()
			.build (), new MesonType[] {
				tr.find_type("python_dependency")
			});
		tr.find_type ("python_installation").register_function ("install_sources", new ParameterBuilder ()
			.build (), new MesonType[] {
			});
		tr.find_type ("python_installation").register_function ("get_install_dir", new ParameterBuilder ()
			.build (), new MesonType[] {
				Elementary.STR
			});
		tr.find_type ("python_installation").register_function ("language_version", new ParameterBuilder ()
			.build (), new MesonType[] {
				Elementary.STR
			});
		tr.find_type ("python_installation").register_function ("get_path", new ParameterBuilder ()
			.build (), new MesonType[] {
				Elementary.STR
			});
		tr.find_type ("python_installation").register_function ("has_path", new ParameterBuilder ()
			.build (), new MesonType[] {
				Elementary.BOOL
			});
		tr.find_type ("python_installation").register_function ("get_variable", new ParameterBuilder ()
			.build (), new MesonType[] {
				Elementary.STR
			});
		tr.find_type ("python_installation").register_function ("has_variable", new ParameterBuilder ()
			.build (), new MesonType[] {
				Elementary.BOOL
			});
		tr.register_type ("qt4_module", "module");
		tr.register_type ("qt5_module", "module");
		tr.register_type ("qt6_module", "module");
		tr.register_type ("rust_module", "module");
		tr.register_type ("simd_module", "module");
		tr.register_type ("sourceset_module", "module");
		tr.register_type ("wayland_module", "module");
		tr.register_type ("windows_module", "module");
	}
}
