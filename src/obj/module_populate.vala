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
		tr.register_type ("hotdoc_module", "module");
		tr.register_type ("i18n_module", "module");
		tr.register_type ("icestorm_module", "module");
		tr.register_type ("java_module", "module");
		tr.register_type ("keyval_module", "module");
		tr.register_type ("pkgconfig_module", "module");
		tr.register_type ("python3_module", "module");
		tr.register_type ("python_module", "module");
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
