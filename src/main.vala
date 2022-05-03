/* main.vala
 *
 * Copyright 2022 JCWasmx86
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
 */

int main (string[] args) {
	if (args.length == 2) {
		var start = GLib.get_real_time () / 1000.0;
		var tr = new Meson.TypeRegistry ();
		tr.init ();
		var end = GLib.get_real_time () / 1000.0;
		Meson.DocPopulator.populate_docs (tr);
		info ("Built type-registry in %lfms", (end - start));
		var ts = new TreeSitter.TSParser ();
		var file = args[1];
		var data = "";
		size_t data_len = 0;
		FileUtils.get_contents (file, out data, out data_len);
		data += "\n";
		data_len++;
		ts.set_language (TreeSitter.tree_sitter_meson ());
		var root = ts.parse_string (null, data, (uint32) data_len);
		Meson.SourceFile.build_ast (data, file, root.root_node ());
		GLib.stdout.printf ("%s\n", root.root_node ().to_string ());
		return 0;
	}
	GLib.Log.writer_default_set_use_stderr (true);
	GLib.Log.set_debug_enabled (true);
	var main_loop = new MainLoop ();
	var s = new Meson.MesonLsp (main_loop);
	var new_stdout_fd = Posix.dup (Posix.STDOUT_FILENO);
	Posix.close (Posix.STDOUT_FILENO);
	Posix.dup2 (Posix.STDERR_FILENO, Posix.STDOUT_FILENO);
	var input_stream = new UnixInputStream (Posix.STDIN_FILENO, false);
	var output_stream = new UnixOutputStream (new_stdout_fd, false);
	s.accept_io_stream (new SimpleIOStream (input_stream, output_stream));
	main_loop.run ();
	return 0;
}
