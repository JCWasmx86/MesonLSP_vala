/* ast.vala
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
	class HoverContext {
		internal Gee.Map<string, MesonOption> options;
	}
	class MesonEnv {
		Gee.List<VariableJar> stack { get; default = new Gee.ArrayList<VariableJar>(); }
		Gee.List<VariablePos> positions { get; default = new Gee.ArrayList<VariablePos> (); }
		internal Gee.Map<string, MesonOption> options;

		internal MesonEnv (TypeRegistry tr, Gee.Map<string, MesonOption> options) {
			this.registry = tr;
			this.options = options;
			this.register ("meson", null, ListUtils.of (tr.find_type ("meson")));
		}

		internal void register (string name, SourceReference? sref, Gee.Set<MesonType> deduces) {
			var p = new VariablePos ();
			p.name = name;
			p.sref = sref;
			p.deduced_types.add_all (this.merge (deduces));
			this.positions.add (p);
		}

		private Gee.Set<MesonType> merge (Gee.Set<MesonType> d, uint counter = 0) {
			var a = new Gee.TreeSet<MesonType> (compare_types_func);
			if (counter == 128) {
				info ("CRITICAL-DEPTH reached: %u Fix your build files! (Or meson_lsp could be wrong ^^)", counter);
				a.add_all (d);
				return a;
			}
			var list = new MList (new MesonType[] {});
			var found_list = false;
			var found_dict = false;
			var dict = new Dictionary (new MesonType[] {});
			foreach (var type in d) {
				if (type is MList) {
					list.values.add_all (((MList) type).values);
					found_list = ((MList) type).values.is_empty;
				} else if (type is Dictionary) {
					dict.values.add_all (((Dictionary) type).values);
					found_dict = ((Dictionary) type).values.is_empty;
				} else {
					a.add (type);
				}
			}
			var tmp_set = new Gee.TreeSet<MesonType> (compare_types_func);
			if (!list.values.is_empty || found_list) {
				tmp_set.add_all (list.values);
				a.add (new MList (merge (tmp_set, counter + 1).to_array ()));
			}
			tmp_set = new Gee.TreeSet<MesonType> (compare_types_func);
			if (!dict.values.is_empty || found_dict) {
				tmp_set.add_all (dict.values);
				a.add (new Dictionary (merge (tmp_set, counter + 1).to_array ()));
			}
			return a;
		}

		internal Gee.Set<MesonType> find_identifier (string name) {
			var size = this.positions.size;
			if (size == 0) {
				info ("No variables found while checking %s", name);
				return ListUtils.of (Elementary.NOT_DEDUCEABLE);
			}
			for (var i = size - 1; i >= 0; i--) {
				if (this.positions[i].name == name) {
					return this.positions[i].deduced_types;
				}
			}
			return ListUtils.of (Elementary.NOT_DEDUCEABLE);
		}

		internal void add_types (string name, SourceReference? sref, Gee.Set<MesonType> deduces) {
			var old = this.find_identifier (name);
			var a = new Gee.TreeSet<MesonType> (compare_types_func);
			a.add_all (old);
			a.add_all (deduces);
			this.register (name, sref, a);
		}

		internal TypeRegistry registry;
	}
	static int compare_types_func (MesonType a, MesonType b) {
		if ((a is Elementary) && (b is Elementary)) {
			var a1 = ((Elementary) a).type;
			var b1 = ((Elementary) b).type;
			return (a1 == b1 ? 0 : (a1 < b1 ? -1 : 1));
		} else if ((a is MList) && (b is MList)) {
			var a1 = ((MList) a).values;
			var b1 = ((MList) b).values;
			if (a1.contains_all (b1) && b1.contains_all (a1))
				return 0;
			return a1.size < b1.size ? -1 : 1;
		} else if ((a is Dictionary) && (b is Dictionary)) {
			var a1 = ((Dictionary) a).values;
			var b1 = ((Dictionary) b).values;
			if (a1.contains_all (b1) && b1.contains_all (a1))
				return 0;
			return a1.size < b1.size ? -1 : 1;
		} else if (a is Dictionary) {
			if (b is Elementary)
				return 1;
			if (b is MList)
				return 1;
			if (b is ObjectType)
				return 1;
		} else if (a is MList) {
			if (b is Elementary)
				return -1;
			if (b is Dictionary)
				return -1;
			if (b is ObjectType)
				return -1;
		} else if (a is Elementary) {
			if (b is MList)
				return -1;
			if (b is Dictionary)
				return -1;
			if (b is ObjectType)
				return -1;
		}
		if (a is ObjectType && !(b is ObjectType)) {
			return -1;
		} else if (a is ObjectType && (b is ObjectType)) {
			return ((ObjectType) a).name.collate (((ObjectType) b).name);
		}
		error ("%s %s", a.get_type ().name (), b.get_type ().name ());
	}

	class VariablePos {
		internal string name;
		internal SourceReference? sref;
		internal bool assignment;
		internal Gee.Set<MesonType> deduced_types { get; default = new Gee.TreeSet<MesonType> (compare_types_func); }
	}
	class VariableJar {
		// <name> <possibleTypes>
		Gee.Map<string, Gee.List<MesonType> > variables;
	}
	class SourceReference {
		internal uint start_line;
		internal uint start_column;
		internal uint end_line;
		internal uint end_column;
		internal string file;

		internal SourceReference (string filename, TreeSitter.TSNode node) {
			this.file = filename;
			this.start_line = node.start_point ().row;
			this.start_column = node.start_point ().column;
			this.end_line = node.end_point ().row;
			this.end_column = node.end_point ().column;
		}

		internal bool contains (string file, Position pos) {
			if (this.file != file)
				return false;
			var line_matches = pos.line >= this.start_line && pos.line <= this.end_line;
			if (!line_matches)
				return false;
			if (pos.line != this.start_line && pos.line != this.end_line)
				return true;
			if (pos.line == this.start_line && pos.character < this.start_column)
				return false;
			if (pos.line == this.end_line && pos.character > this.end_column)
				return false;
			return true;
		}

		internal string to_string () {
			return "%s(%u:%u->%u:%u)".printf (this.file, this.start_line, this.start_column, this.end_line, this.end_column);
		}

		internal Range to_lsp_range () {
			return new Range () {
					   start = new Position () {
						   line = this.start_line,
						   character = this.start_column
					   },
					   end = new Position () {
						   line = this.end_line,
						   character = this.end_column
					   }
			};
		}
	}

	class SourceFile {
		internal string filename;
		internal Gee.List<Statement> statements { get; set; default = new Gee.ArrayList<Statement> (); }

		internal static SourceFile build_ast (string data, string filename, TreeSitter.TSNode root, Gee.Set<Diagnostic> diagnostics) {
			var ret = new SourceFile ();
			ret.filename = filename;
			if (root.named_child_count () == 0) {
				info ("No build_definition found!");
				return ret;
			}
			var build_def = root.named_child (0);
			if (build_def.type () != "build_definition") {
				return ret;
			}
			for (var i = 0; i < build_def.named_child_count (); i++) {
				var stmt = build_def.named_child (i);
				if (stmt.type () == "comment")
					continue;
				if (stmt.named_child_count () == 1 && stmt.named_child (0).type () == "comment")
					continue;
				if (stmt.named_child_count () == 0)
					continue;
				ret.statements.add (Statement.parse (data, filename, stmt, diagnostics));
			}
			return ret;
		}

		internal Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			foreach (var s in this.statements) {
				var h = s.hover (tr, file, pos, ctx);
				if (h != null)
					return h;
			}
			return null;
		}

		internal void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			foreach (var s in this.statements) {
				s.document_symbols (path, into);
			}
		}

		internal string? find_identifier (string file, Position pos) {
			foreach (var s in this.statements) {
				var r = s.find_identifier (file, pos);
				if (r != null)
					return r;
			}
			return null;
		}

		internal Gee.List<SymbolDefinition> find_symbol (string name) {
			var ret = new Gee.ArrayList<SymbolDefinition>();
			foreach (var s in this.statements) {
				ret.add_all (s.find_symbol (name));
			}
			return ret;
		}

		internal string? jump_to_subdir (string file, Position pos) {
			foreach (var s in this.statements) {
				var sd = s.jump_to_subdir (file, pos);
				if (sd != null)
					return sd;
			}
			return null;
		}

		internal void fill_env (MesonEnv env) {
			foreach (var s in this.statements) {
				s.fill_env (env);
			}
		}

		internal void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			foreach (var s in this.statements) {
				s.fill_diagnostics (env, diagnostics);
				if (s is JumpStatement) {
					diagnostics.add (
						new Diagnostic.error (
							s.sref,
							"%s outside of loop".printf (((JumpStatement) s).is_break ? "break" : "continue")
						)
					);
				}
			}
		}
	}
	class SymbolDefinition {
		internal SourceReference sref;
		internal bool is_foreach;
		internal SourceReference? parent;
	}

	class JumpStatement : Statement {
		internal bool is_break;
	}

	class ErrorNode : Expression {
		private string msg;

		public ErrorNode (SourceReference sref, string? msg = null) {
			this.sref = sref;
			this.msg = msg ?? "Unknown Error";
			warning (">> %s", this.msg);
		}

		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			diagnostics.add (new Diagnostic.error (this.sref, this.msg));
		}
	}

	class Statement : CodeNode {
		internal static Statement parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "statement" && tsn.type () != "comment") {
				var js = new JumpStatement ();
				js.sref = new SourceReference (filename, tsn);
				js.is_break = Util.get_string_value (data, tsn).strip () == "break";
				return js;
			}
			if (tsn.named_child_count () == 0) {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected named child");
			}
			var child = tsn.named_child (0);
			switch (child.type ()) {
			case "expression":
				return Expression.parse (data, filename, child, diagnostics);
			case "assignment_statement":
				return AssignmentStatement.parse (data, filename, child, diagnostics);
			case "selection_statement":
				return SelectionStatement.parse (data, filename, child, diagnostics);
			case "iteration_statement":
				return IterationStatement.parse (data, filename, child, diagnostics);
			case "comment":
				break;
			}
			return new ErrorNode (new SourceReference (filename, tsn), "Unknown statement type: %s".printf (child.type ()));
		}
	}
	class CodeNode : GLib.Object {
		internal SourceReference sref;

		internal virtual string? find_identifier (string file, Position pos) {
			return null;
		}

		internal virtual Gee.List<SymbolDefinition> find_symbol (string name) {
			return new Gee.ArrayList<SymbolDefinition>();
		}

		internal virtual void document_symbols (string path, Gee.List<DocumentSymbol> into) {
		}

		internal virtual Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			return null;
		}

		internal virtual string? jump_to_subdir (string file, Position pos) {
			return null;
		}

		internal virtual void fill_env (MesonEnv env) {
		}

		internal virtual void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
		}
	}

	class SelectionStatement : Statement {
		Gee.List<Expression> conditions { get; set; default = new Gee.ArrayList<Expression>(); }

		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			foreach (var expr in this.conditions) {
				var types = expr.deduce_types (env);
				expr.fill_diagnostics (env, diagnostics);
				var found_bool = false;
				foreach (var t in types) {
					if (t is Elementary && ((Elementary) t) == Elementary.BOOL) {
						found_bool = true;
						break;
					}
				}
				if (found_bool)
					continue;
				if (!found_bool)
					diagnostics.add (
						new Diagnostic.error (
							expr.sref,
							"Condition is not bool"
						)
					);
			}
			foreach (var block in this.blocks) {
				foreach (var stmt in block) {
					stmt.fill_diagnostics (env, diagnostics);
					if (stmt is JumpStatement) {
						diagnostics.add (
							new Diagnostic.error (
								stmt.sref,
								"%s outside of loop".printf (((JumpStatement) stmt).is_break ? "break" : "continue")
							)
						);
					}
				}
			}
		}

		internal Gee.List<Gee.List<Statement> > blocks { get; set; default = new Gee.ArrayList<Gee.ArrayList<Statement> > (); }

		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			foreach (var c in this.conditions) {
				var h = c.hover (tr, file, pos, ctx);
				if (h != null)
					return h;
			}
			foreach (var c in this.blocks) {
				foreach (var b in c) {
					var h = b.hover (tr, file, pos, ctx);
					if (h != null)
						return h;
				}
			}
			return null;
		}

		internal override new string? jump_to_subdir (string file, Position pos) {
			foreach (var expr in this.conditions) {
				var s = expr.jump_to_subdir (file, pos);
				if (s != null)
					return s;
			}
			foreach (var b in this.blocks) {
				foreach (var s in b) {
					var s1 = s.jump_to_subdir (file, pos);
					if (s1 != null)
						return s1;
				}
			}
			return null;
		}

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			foreach (var s in this.blocks) {
				foreach (var s1 in s)
					s1.document_symbols (path, into);
			}
			foreach (var e in this.conditions)
				e.document_symbols (path, into);
		}

		internal override Gee.List<SymbolDefinition> find_symbol (string name) {
			var ret = new Gee.ArrayList<SymbolDefinition>();
			foreach (var b in this.blocks) {
				foreach (var s in b)
					ret.add_all (s.find_symbol (name));
			}
			foreach (var b in this.conditions) {
				ret.add_all (b.find_symbol (name));
			}
			return ret;
		}

		internal override string? find_identifier (string file, Position pos) {
			foreach (var expr in this.conditions) {
				var s = expr.find_identifier (file, pos);
				if (s != null)
					return s;
			}
			foreach (var b in this.blocks) {
				foreach (var s in b) {
					var s1 = s.find_identifier (file, pos);
					if (s1 != null)
						return s1;
				}
			}
			return null;
		}

		internal static new SelectionStatement parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			var ret = new SelectionStatement ();
			ret.sref = new SourceReference (filename, tsn);
			var tmp = new Gee.ArrayList<Statement> ();
			for (var i = 0; i < tsn.child_count (); i++) {
				var c = tsn.child (i);
				if (Util.get_string_value (data, c).strip () == "if") {
					while (Posix.strcmp (tsn.child (i + 1).type (), "comment") == 0) {
						i++;
					}
					var condition = tsn.child (i + 1);
					ret.conditions.add (Expression.parse (data, filename, condition.named_child (0), diagnostics));
					i++;
				} else if (Util.get_string_value (data, c).strip () == "else if") {
					ret.blocks.add (tmp);
					while (Posix.strcmp (tsn.child (i + 1).type (), "comment") == 0) {
						i++;
					}
					tmp = new Gee.ArrayList<Statement>();
					var condition = tsn.child (i + 1);
					ret.conditions.add (Expression.parse (data, filename, condition.named_child (0), diagnostics));
					i++;
				} else if (Util.get_string_value (data, c).strip () == "else") {
					ret.blocks.add (tmp);
					tmp = new Gee.ArrayList<Statement>();
				} else if (c.type () == "statement" && (c.named_child_count () == 1 && c.named_child (0).type () != "comment")) {
					tmp.add (Statement.parse (data, filename, c, diagnostics));
				}
			}
			ret.blocks.add (tmp);
			return ret;
		}
	}

	class IterationStatement : Statement {
		internal Gee.List<Expression> identifiers { get; set; default = new Gee.ArrayList<Expression> (); }

		internal Expression id;
		internal Gee.List<Statement> statements { get; set; default = new Gee.ArrayList<Expression> (); }

		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			this.id.fill_diagnostics (env, diagnostics);
			var types = this.id.deduce_types (env);
			var found_iterable = false;
			foreach (var t in types) {
				if (t is MList || t is Dictionary)
					found_iterable = true;
			}
			if (!found_iterable)
				diagnostics.add (
					new Diagnostic.error (
						id.sref,
						"Not iterable!"
					)
				);
		}

		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			foreach (var c in this.identifiers) {
				var h = c.hover (tr, file, pos, ctx);
				if (h != null)
					return h;
			}
			var h = this.id.hover (tr, file, pos, ctx);
			if (h != null)
				return h;
			foreach (var c in this.statements) {
				h = c.hover (tr, file, pos, ctx);
				if (h != null)
					return h;
			}
			return null;
		}

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			foreach (var e in this.identifiers)
				e.document_symbols (path, into);
			this.id.document_symbols (path, into);
			foreach (var e in this.statements)
				e.document_symbols (path, into);
		}

		internal override new string? jump_to_subdir (string file, Position pos) {
			foreach (var expr in this.identifiers) {
				var s = expr.jump_to_subdir (file, pos);
				if (s != null)
					return s;
			}
			foreach (var expr in this.statements) {
				var s = expr.jump_to_subdir (file, pos);
				if (s != null)
					return s;
			}
			return this.id.jump_to_subdir (file, pos);
		}

		internal override Gee.List<SymbolDefinition> find_symbol (string name) {
			var ret = new Gee.ArrayList<SymbolDefinition>();
			foreach (var s in this.statements) {
				ret.add_all (s.find_symbol (name));
			}
			foreach (var i in this.identifiers) {
				if (i is Identifier) {
					var ii = (Identifier) i;
					if (ii.name == name) {
						var sym = new SymbolDefinition ();
						sym.sref = i.sref;
						sym.is_foreach = true;
						sym.parent = this.sref;
						ret.add (sym);
					}
				}
			}
			return ret;
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			foreach (var expr in this.identifiers) {
				var s = expr.find_identifier (file, pos);
				if (s != null)
					return s;
			}
			var s = this.id.find_identifier (file, pos);
			if (s != null)
				return s;
			foreach (var expr in this.statements) {
				s = expr.find_identifier (file, pos);
				if (s != null)
					return s;
			}
			return null;
		}


		internal static new IterationStatement parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			var ret = new IterationStatement ();
			ret.sref = new SourceReference (filename, tsn);
			var ids = tsn.named_child (0);
			var s = new Gee.HashSet<string>();
			for (var i = 0; i < ids.named_child_count (); i++) {
				var x = ids.named_child (i);
				ret.identifiers.add (Expression.parse (data, filename, x, diagnostics));
				if (!(ret.identifiers[i] is Identifier)) {
					diagnostics.add (new Diagnostic.error (
										 ret.identifiers[i].sref,
										 "Expected Identifier got %s".printf (ret.identifiers[i].get_type ().name ())));
				} else {
					var name = ((Identifier) ret.identifiers[i]).name;
					if (s.contains (name)) {
						diagnostics.add (new Diagnostic.error (
											 ret.identifiers[i].sref,
											 "Duplicate variable in foreach: %s".printf (name)));
					}
					s.add (name);
				}
			}
			ret.id = Expression.parse (data, filename, tsn.named_child (1), diagnostics);
			for (var i = 2; i < tsn.named_child_count (); i++) {
				if (tsn.named_child (i).type () == "comment")
					continue;
				var stmt = tsn.named_child (i);
				if (stmt.named_child_count () == 0)
					continue;
				if (stmt.named_child_count () == 1 && stmt.named_child (0).type () == "comment")
					continue;
				ret.statements.add (Statement.parse (data, filename, tsn.named_child (i), diagnostics));
			}
			return ret;
		}
	}

	class AssignmentStatement : Statement {
		internal Expression lhs;
		internal AssignmentOperator op;
		internal Expression rhs;

		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			lhs.fill_diagnostics (env, diagnostics);
			rhs.fill_diagnostics (env, diagnostics);
			var types = rhs.deduce_types (env);
			if (lhs is Identifier) {
				if (this.op == AssignmentOperator.EQ) {
					info ("Deduced in %s (%u, %s):", this.sref.to_string (), types.size, rhs.get_type ().name ());
					foreach (var t in types)
						info ("\t%s", t.to_string ());
					env.register (((Identifier) lhs).name, this.lhs.sref, types);
				} else if (this.op == AssignmentOperator.PLUS_EQ) {
					var ret = new Gee.HashSet<MesonType>();
					var l = env.find_identifier (((Identifier) lhs).name);
					foreach (var ri in types) {
						foreach (var li in l) {
							if (li is MList) {
								var mlist = new MList (((MList) li).values.to_array ());
								mlist.values.add_all ((ri is MList) ? ((MList) ri).values : ListUtils.of (ri));
								ret.add (mlist);
							} else if (li is Dictionary && ri is Dictionary) {
								var dict = new Dictionary (((Dictionary) li).values.to_array ());
								dict.values.add_all ((ri is Dictionary) ? ((Dictionary) ri).values : ListUtils.of (ri));
								ret.add (dict);
							} else if (li is Elementary && ri is Elementary) {
								if (ri == li && li == Elementary.STR || li == Elementary.INT)
									ret.add (li);
							}
						}
					}
					env.add_types (((Identifier) lhs).name, this.lhs.sref, ret);
				} else if (this.op == AssignmentOperator.SLASH_EQ) {
					var ret = new Gee.HashSet<MesonType>();
					var l = env.find_identifier (((Identifier) lhs).name);
					foreach (var ri in types) {
						foreach (var li in l) {
							if (li is Elementary && ri is Elementary) {
								if (ri == li && li == Elementary.STR || li == Elementary.INT)
									ret.add (li);
							}
						}
					}
					env.add_types (((Identifier) lhs).name, this.lhs.sref, ret);
				} else {
					var ret = new Gee.HashSet<MesonType>();
					var l = env.find_identifier (((Identifier) lhs).name);
					foreach (var ri in types) {
						foreach (var li in l) {
							if (li is Elementary && ri is Elementary) {
								if (ri == li && li == Elementary.INT)
									ret.add (li);
							}
						}
					}
					env.add_types (((Identifier) lhs).name, this.lhs.sref, ret);
				}
			}
		}

		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			var h = this.lhs.hover (tr, file, pos, ctx);
			if (h != null)
				return h;
			h = this.rhs.hover (tr, file, pos, ctx);
			if (h != null)
				return h;
			return null;
		}

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			if (this.op == AssignmentOperator.EQ)
				this.lhs.document_symbols (path, into);
			this.rhs.document_symbols (path, into);
		}

		internal override string? jump_to_subdir (string file, Position pos) {
			var s = this.lhs.jump_to_subdir (file, pos);
			if (s != null)
				return s;
			s = this.rhs.jump_to_subdir (file, pos);
			if (s != null)
				return s;
			return null;
		}

		internal override Gee.List<SymbolDefinition> find_symbol (string name) {
			var ret = new Gee.ArrayList<SymbolDefinition>();
			// E.g. the code
			// x = [] (1)
			// x += 'foo.c' (2)
			// do_with(x)
			// Jump to (1)
			if (this.op != AssignmentOperator.EQ)
				return ret;
			if (!(this.lhs is Identifier))
				return ret;
			if (((Identifier) this.lhs).name != name)
				return ret;
			var sym = new SymbolDefinition ();
			sym.is_foreach = false;
			sym.sref = this.lhs.sref;
			ret.add (sym);
			return ret;
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			var s = this.lhs.find_identifier (file, pos);
			if (s != null)
				return s;
			s = this.rhs.find_identifier (file, pos);
			if (s != null)
				return s;
			return null;
		}


		internal static new Statement parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "assignment_statement") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected AssignmentStatement, got %s".printf (tsn.type ()));
			}
			var ret = new AssignmentStatement ();
			ret.sref = new SourceReference (filename, tsn);
			ret.lhs = Expression.parse (data, filename, tsn.named_child (0), diagnostics);
			ret.rhs = Expression.parse (data, filename, tsn.named_child (2), diagnostics);
			switch (Util.get_string_value (data, tsn.named_child (1))) {
			case "=":
				ret.op = AssignmentOperator.EQ;
				break;
			case "*=":
				ret.op = AssignmentOperator.STAR_EQ;
				break;
			case "/=":
				ret.op = AssignmentOperator.SLASH_EQ;
				break;
			case "%=":
				ret.op = AssignmentOperator.MOD_EQ;
				break;
			case "+=":
				ret.op = AssignmentOperator.PLUS_EQ;
				break;
			case "-=":
				ret.op = AssignmentOperator.MINUS_EQ;
				break;
			default:
				diagnostics.add (new Diagnostic.error (
									 new SourceReference (filename, tsn.named_child (1)),
									 "Expected assignment_operator, got %s".printf (tsn.named_child (1).type ())
				));
				break;
			}
			return ret;
		}
	}

	enum AssignmentOperator {
		EQ,
		STAR_EQ,
		SLASH_EQ,
		MOD_EQ,
		PLUS_EQ,
		MINUS_EQ
	}

	class Expression : Statement {
		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.named_child_count () == 0) {
				if (tsn.type () == "id_expression")
					return new Identifier (Util.get_string_value (data, tsn), filename, tsn);
				diagnostics.add (new Diagnostic.error (
									 new SourceReference (filename, tsn),
									 "Unexpected type: %s".printf (tsn.type ())
				));
				return new ErrorNode (new SourceReference (filename, tsn), "Expected IdExpression, got %s".printf (tsn.type ()));
			}
			switch (tsn.named_child (0).type ()) {
			case "function_expression":
				return FunctionExpression.parse (data, filename, tsn.named_child (0), diagnostics);
			case "conditional_expression":
				return ConditionalExpression.parse (data, filename, tsn.named_child (0), diagnostics);
			case "unary_expression":
				return UnaryExpression.parse (data, filename, tsn.named_child (0), diagnostics);
			case "subscript_expression":
				return ArrayAccessExpression.parse (data, filename, tsn.named_child (0), diagnostics);
			case "method_expression":
				return MethodExpression.parse (data, filename, tsn.named_child (0), diagnostics);
			case "binary_expression":
				return BinaryExpresssion.parse (data, filename, tsn.named_child (0), diagnostics);
			case "integer_literal":
				return IntegerLiteral.parse (Util.get_string_value (data, tsn.named_child (0)), filename, tsn.named_child (0), diagnostics);
			case "string_literal":
				return StringLiteral.parse (Util.get_string_value (data, tsn.named_child (0)), filename, tsn.named_child (0), diagnostics);
			case "boolean_literal":
				return BooleanLiteral.parse (Util.get_string_value (data, tsn.named_child (0)), filename, tsn.named_child (0), diagnostics);
			case "array_literal":
				return ArrayLiteral.parse (data, filename, tsn.named_child (0), diagnostics);
			case "dictionary_literal":
				return DictionaryLiteral.parse (data, filename, tsn.named_child (0), diagnostics);
			case "id_expression":
			case "function_id":
				return new Identifier (Util.get_string_value (data, tsn.named_child (0)), filename, tsn.named_child (0));
			case "primary_expression":
				if (tsn.named_child (0).child_count () == 1)
					return new Identifier (Util.get_string_value (data, tsn.named_child (0).named_child (0)), filename, tsn.named_child (0).named_child (0));
				return Expression.parse (data, filename, tsn.named_child (0).named_child (0), diagnostics);
			default:
				diagnostics.add (new Diagnostic.error (new SourceReference (filename, tsn.named_child (0)), "Unexpected child: %s".printf (tsn.named_child (0).type ())));
				return new ErrorNode (new SourceReference (filename, tsn), "Unexpected %s".printf (tsn.named_child (0).type ()));
			}
		}

		internal virtual Gee.Set<MesonType> deduce_types (MesonEnv env) {
			return ListUtils.of (Elementary.NOT_DEDUCEABLE);
		}
	}

	class Identifier : Expression {
		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			var symbol = new DocumentSymbol ();
			symbol.name = this.name;
			symbol.kind = SymbolKind.Variable;
			symbol.range = this.sref.to_lsp_range ();
			if (this.sref.file == path)
				into.add (symbol);
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			return this.name;
		}
		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			if (this.name == "meson")
				return ListUtils.of (env.registry.find_type ("meson"));
			if (this.name == "host_machine")
				return ListUtils.of (env.registry.find_type ("host_machine"));
			if (this.name == "build_machine")
				return ListUtils.of (env.registry.find_type ("build_machine"));
			if (this.name == "target_machine")
				return ListUtils.of (env.registry.find_type ("target_machine"));
			return env.find_identifier (this.name);
		}

		internal string name;
		internal Identifier (string name, string filename, TreeSitter.TSNode tsn) {
			this.sref = new SourceReference (filename, tsn);
			this.name = name;
		}
	}

	class DictionaryLiteral : Expression {
		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			foreach (var k in this.keys) {
				k.fill_diagnostics (env, diagnostics);
			}
			foreach (var v in this.values) {
				v.fill_diagnostics (env, diagnostics);
			}
		}

		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			foreach (var c in this.keys) {
				var h = c.hover (tr, file, pos, ctx);
				if (h != null)
					return h;
			}
			foreach (var c in this.values) {
				var h = c.hover (tr, file, pos, ctx);
				if (h != null)
					return h;
			}
			return null;
		}
		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			var ret = new Gee.ArrayList<MesonType>();
			foreach (var r in keys) {
				ret.add_all (r.deduce_types (env));
			}
			var mdict = new Dictionary (ret.to_array ());
			return ListUtils.of (mdict);
		}

		internal Gee.List<Expression> keys { get; set; default = new Gee.ArrayList<Expression> (); }
		internal Gee.List<Expression> values { get; set; default = new Gee.ArrayList<Expression> (); }

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			foreach (var expr in this.keys) {
				var s = expr.find_identifier (file, pos);
				if (s != null)
					return s;
			}
			foreach (var expr in this.values) {
				var s = expr.find_identifier (file, pos);
				if (s != null)
					return s;
			}
			return null;
		}
		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "dictionary_literal") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected DictionaryLiteral, got %s".printf (tsn.type ()));
			}
			var ret = new DictionaryLiteral ();
			ret.sref = new SourceReference (filename, tsn);
			for (var i = 0; i < tsn.named_child_count (); i++) {
				var kv = tsn.named_child (i);
				ret.keys.add (Expression.parse (data, filename, kv.named_child (0), diagnostics));
				ret.values.add (Expression.parse (data, filename, kv.named_child (1), diagnostics));
			}
			return ret;
		}
	}

	class ArrayLiteral : Expression {
		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			foreach (var e in this.elements) {
				e.fill_diagnostics (env, diagnostics);
			}
		}

		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			foreach (var c in this.elements) {
				var h = c.hover (tr, file, pos, ctx);
				if (h != null)
					return h;
			}
			return null;
		}
		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			var ret = new Gee.HashSet<MesonType>();
			foreach (var e in elements)
				ret.add_all (e.deduce_types (env));
			var list = new MList (ret.to_array ());
			var r = new Gee.HashSet<MesonType>();
			r.add (list);
			return r;
		}

		internal Gee.List<Expression> elements { get; set; default = new Gee.ArrayList<Expression> (); }
		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			foreach (var expr in this.elements) {
				var s = expr.find_identifier (file, pos);
				if (s != null)
					return s;
			}
			return null;
		}
		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "array_literal") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected ArrayLiteral, got %s".printf (tsn.type ()));
			}
			var ret = new ArrayLiteral ();
			ret.sref = new SourceReference (filename, tsn);
			for (var i = 0; i < tsn.named_child_count (); i++) {
				if (tsn.named_child (i).type () != "expression")
					continue;
				ret.elements.add (Expression.parse (data, filename, tsn.named_child (i), diagnostics));
			}
			return ret;
		}
	}

	class IntegerLiteral : Expression {
		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			return ListUtils.of (Elementary.INT);
		}

		internal int64 val;

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			var symbol = new DocumentSymbol ();
			symbol.kind = SymbolKind.Number;
			symbol.name = null;
			symbol.range = this.sref.to_lsp_range ();
			if (this.sref.file == path)
				into.add (symbol);
		}

		internal static new Expression parse (string str, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "integer_literal") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected IntegerLiteral, got %s".printf (tsn.type ()));
			}
			var ret = new IntegerLiteral ();
			ret.sref = new SourceReference (filename, tsn);
			if (str.has_prefix ("0x"))
				ret.val = int64.parse (str.substring (2), 16);
			else if (str.has_prefix ("0b"))
				ret.val = int64.parse (str.substring (2), 2);
			else if (str.has_prefix ("0o"))
				ret.val = int64.parse (str.substring (2), 2);
			else
				ret.val = int64.parse (str);
			return ret;
		}
	}

	class BooleanLiteral : Expression {
		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			return ListUtils.of (Elementary.BOOL);
		}

		internal bool val;

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			var symbol = new DocumentSymbol ();
			symbol.kind = SymbolKind.Boolean;
			symbol.name = null;
			symbol.range = this.sref.to_lsp_range ();
			if (this.sref.file == path)
				into.add (symbol);
		}

		internal static new Expression parse (string str, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "boolean_literal") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected BooleanLiteral, got %s".printf (tsn.type ()));
			}
			var ret = new BooleanLiteral ();
			ret.sref = new SourceReference (filename, tsn);
			ret.val = str == "true";
			return ret;
		}
	}

	class StringLiteral : Expression {
		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			return ListUtils.of (Elementary.STR);
		}

		internal string val;

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			var symbol = new DocumentSymbol ();
			symbol.kind = SymbolKind.String;
			symbol.name = null;
			symbol.range = this.sref.to_lsp_range ();
			if (this.sref.file == path)
				into.add (symbol);
		}

		internal static new Expression parse (string str, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "string_literal") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected StringLiteral, got %s".printf (tsn.type ()));
			}
			var ret = new StringLiteral ();
			ret.sref = new SourceReference (filename, tsn);
			ret.val = str.has_prefix ("'''") ? str.replace ("'''", "") : str.substring (1, str.length - 2);
			return ret;
		}
	}

	class MethodExpression : Expression {
		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			var h = obj.hover (tr, file, pos, ctx);
			if (h != null)
				return h;
			if (list != null && (h = this.list.hover (tr, file, pos, ctx)) != null)
				return h;
			if (!this.sref.contains (file, pos))
				return null;
			if (obj is Identifier) {
				var name = ((Identifier) obj).name;
				var type = tr.find_type_safe (name);
				// It is not an static object reference, but a variable reference
				if (type == null) {
					info ("No type called %s found!", name);
					return null;
				}
				if (this.obj.sref.contains (file, pos)) {
					var hover = new Hover ();
					hover.range = this.obj.sref.to_lsp_range ();
					hover.contents = new MarkupContent ();
					hover.contents.kind = "markdown";
					hover.contents.value = type.docs;
					return hover;
				}
				if (this.name_ref.contains (file, pos)) {
					var method = type.find_method_safe (this.name);
					if (method == null) {
						info ("Method %s not found", name);
						return null;
					}
					var hover = new Hover ();
					hover.range = this.name_ref.to_lsp_range ();
					hover.contents = new MarkupContent ();
					hover.contents.kind = "markdown";
					hover.contents.value = method.generate_docs ();
					return hover;
				}
				return null;
			}
			return null;
		}
		internal override void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			obj.fill_diagnostics (env, diagnostics);
			var obj_types = obj.deduce_types (env);
			var found_something = false;
			foreach (var t in obj_types) {
				info ("//>>Checking %s for method %s", t.to_string (), this.name);
				if (t is ObjectType) {
					var m = ((ObjectType) t).find_method_safe (this.name);
					found_something |= (m != null);
				} else if (t is Elementary) {
					var e = (Elementary) t;
					if (e == Elementary.STR) {
						switch (this.name) {
						case "contains":
						case "endswith":
						case "startswith":
						case "version_compare":
						case "format":
						case "join":
						case "replace":
						case "strip":
						case "substring":
						case "to_lower":
						case "to_upper":
						case "underscorify":
						case "split":
						case "to_int":
							found_something = true;
							break;
						}
					} else if (e == Elementary.INT) {
						switch (this.name) {
						case "is_even":
						case "is_odd":
						case "to_string":
							found_something = true;
							break;
						}
					} else if (e == Elementary.BOOL) {
						switch (this.name) {
						case "to_int":
						case "to_string":
							found_something = true;
							break;
						}
					}
				} else if (t is MList) {
					switch (this.name) {
					case "contains":
					case "get":
					case "length":
						found_something = true;
						break;
					}
				} else if (t is Dictionary) {
					switch (this.name) {
					case "get":
					case "has_key":
					case "keys":
						found_something = true;
						break;
					}
				}
			}
			if (!found_something) {
				var type_string = obj_types.fold<string> ((a, b) => a.to_string () + "|" + b.to_string (), "").replace ("|]", "]");
				diagnostics.add (new Diagnostic.error (this.sref, "Unable to find method %s in object of types %s".printf (this.name, type_string)));
			}
		}

		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			var object = obj.deduce_types (env);
			var ret = new Gee.HashSet<MesonType>();
			if (this.obj is Identifier) {
				var name = ((Identifier)this.obj).name;
				if (name == "meson" || name == "host_machine" || name == "build_machine" || name == "target_machine") {
					var rets = env.registry.find_type (name).find_method_safe (this.name).return_type;
					ret.add_all (rets);
					return ret;
				}
			}
			foreach (var t in object) {
				if (t is ObjectType) {
					var o = (ObjectType) t;
					var m = o.find_method_safe (this.name);
					if (m != null) {
						ret.add_all (m.return_type);
					}
				} else if (t is Elementary) {
					var e = (Elementary) t;
					if (e == Elementary.STR) {
						switch (this.name) {
						case "contains":
						case "endswith":
						case "startswith":
						case "version_compare":
							ret.add (Elementary.BOOL);
							break;
						case "format":
						case "join":
						case "replace":
						case "strip":
						case "substring":
						case "to_lower":
						case "to_upper":
						case "underscorify":
							ret.add (Elementary.STR);
							break;
						case "split":
							ret.add (new MList (new MesonType[] { Elementary.STR }));
							break;
						case "to_int":
							ret.add (Elementary.INT);
							break;
						}
					} else if (e == Elementary.INT) {
						switch (this.name) {
						case "is_even":
						case "is_odd":
							ret.add (Elementary.BOOL);
							break;
						case "to_string":
							ret.add (Elementary.STR);
							break;
						}
					} else if (e == Elementary.BOOL) {
						switch (this.name) {
						case "to_int":
							ret.add (Elementary.INT);
							break;
						case "to_string":
							ret.add (Elementary.STR);
							break;
						}
					}
				} else if (t is MList) {
					switch (this.name) {
					case "contains":
						ret.add (Elementary.BOOL);
						break;
					case "get":
						ret.add (Elementary.ANY);
						break;
					case "length":
						ret.add (Elementary.INT);
						break;
					}
				} else if (t is Dictionary) {
					switch (this.name) {
					case "get":
						ret.add (Elementary.ANY);
						break;
					case "has_key":
						ret.add (Elementary.BOOL);
						break;
					case "keys":
						ret.add (new MList (new MesonType[] { Elementary.STR }));
						break;
					}
				}
			}
			if (!ret.is_empty)
				return ret;
			return ListUtils.of (Elementary.NOT_DEDUCEABLE);
		}

		internal Expression obj;
		internal string name;
		internal SourceReference name_ref;
		internal Expression? list;

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			this.obj.document_symbols (path, into);
			if (this.list != null)
				this.list.document_symbols (path, into);
			var symbol = new DocumentSymbol ();
			symbol.kind = SymbolKind.Function;
			symbol.name = null;
			symbol.range = this.name_ref.to_lsp_range ();
			if (this.sref.file == path)
				into.add (symbol);
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			if (this.name_ref.contains (file, pos))
				return this.name;
			var s = this.obj.find_identifier (file, pos);
			if (s != null)
				return s;
			return this.list == null ? null : this.list.find_identifier (file, pos);
		}
		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "method_expression") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected MethodExpression, got %s".printf (tsn.type ()));
			}
			var ret = new MethodExpression ();
			ret.sref = new SourceReference (filename, tsn);
			ret.name_ref = new SourceReference (filename, tsn.named_child (1));
			ret.obj = Expression.parse (data, filename, tsn.named_child (0), diagnostics);
			ret.name = Util.get_string_value (data, tsn.named_child (1));
			if (tsn.named_child_count () == 3)
				ret.list = ArgumentList.parse (data, filename, tsn.named_child (2), diagnostics);
			return ret;
		}
	}

	class ConditionalExpression : Expression {
		internal Expression condition;
		internal Expression if_true;
		internal Expression if_false;

		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			var h = this.condition.hover (tr, file, pos, ctx);
			if (h != null)
				return h;
			h = this.if_true.hover (tr, file, pos, ctx);
			if (h != null)
				return h;
			return this.if_false.hover (tr, file, pos, ctx);
		}

		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			var ret = new Gee.HashSet<MesonType>();
			ret.add_all (if_true.deduce_types (env));
			ret.add_all (if_false.deduce_types (env));
			var r = new Gee.HashSet<MesonType>();
			r.add_all (ret);
			return r;
		}

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			this.condition.document_symbols (path, into);
			this.if_true.document_symbols (path, into);
			this.if_false.document_symbols (path, into);
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			var s = this.condition.find_identifier (file, pos);
			if (s != null)
				return s;
			s = this.if_true.find_identifier (file, pos);
			if (s != null)
				return s;
			return this.if_false.find_identifier (file, pos);
		}

		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "conditional_expression") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected ConditionalExpression, got %s".printf (tsn.type ()));
			}
			var ret = new ConditionalExpression ();
			ret.sref = new SourceReference (filename, tsn);
			ret.condition = Expression.parse (data, filename, tsn.named_child (0), diagnostics);
			ret.if_true = Expression.parse (data, filename, tsn.named_child (1), diagnostics);
			ret.if_false = Expression.parse (data, filename, tsn.named_child (2), diagnostics);
			return ret;
		}

		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			this.condition.fill_diagnostics (env, diagnostics);
			this.if_true.fill_diagnostics (env, diagnostics);
			this.if_false.fill_diagnostics (env, diagnostics);
			var found_it = false;
			foreach (var t in this.condition.deduce_types (env)) {
				if (t == Elementary.BOOL) {
					found_it = true;
					break;
				}
			}
			if (!found_it) {
				diagnostics.add (new Diagnostic.error (this.condition.sref, "Condition is not bool"));
			}
		}
	}
	class FunctionExpression : Expression {
		internal string name;
		internal Expression? arg_list;
		internal SourceReference name_ref;

		internal override string? jump_to_subdir (string file, Position pos) {
			if (this.arg_list == null || this.arg_list is ErrorNode)
					return null;
			var arg_list = (ArgumentList) arg_list;
			var usable_args = arg_list != null && arg_list.args.size > 0 && arg_list.args[0] is StringLiteral;
			if (this.sref.contains (file, pos) && this.name == "subdir" && usable_args) {
				var name = ((StringLiteral) arg_list.args[0]).val;
				info ("Call to subdir %s (From %s)!", name, this.sref.file);
				var f = File.new_for_path (this.sref.file).get_parent ().get_child (name + "/meson.build");
				if (f.query_exists ()) {
					return f.get_path ();
				}
			}
			return this.arg_list.jump_to_subdir (file, pos);
		}

		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			if (this.name == "import") {
				if (this.arg_list != null && this.arg_list is ArgumentList && ((ArgumentList)this.arg_list).args[0] is StringLiteral) {
					var module = ((StringLiteral)((ArgumentList)this.arg_list).args[0]).val;
					if (env.registry.find_type_safe (module + "_module") != null) {
						return ListUtils.of (env.registry.find_type_safe (module + "_module"));
					}
				}
			} else if (this.name == "get_variable") {
				if (this.arg_list != null && this.arg_list is ArgumentList && ((ArgumentList)this.arg_list).args[0] is StringLiteral) {
					var variable = ((StringLiteral)((ArgumentList)this.arg_list).args[0]).val;
					var v = env.options[variable];
					if (v != null) {
						if (v.type == "string") {
							return ListUtils.of (Elementary.STR);
						} else if (v.type == "boolean") {
							return ListUtils.of (Elementary.BOOL);
						} else if (v.type == "integer") {
							return ListUtils.of (Elementary.INT);
						} else {
							info (">> Option %s is a %s", variable, v.type ?? "<<Unknown>>");
							return ListUtils.of (Elementary.ANY);
						}
					} else {
						info (">> Option %s is missing", variable);
						return ListUtils.of (Elementary.ANY);
					}
				}
			}
			var r = env.registry.find_function (this.name);
			if (r != null) {
				var s = new Gee.HashSet<MesonType>();
				s.add_all (r.return_type);
				return s;
			}
			info ("%s not found", this.name);
			return ListUtils.of (Elementary.NOT_DEDUCEABLE);
		}

		internal override void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			if (env.registry.find_function (this.name) == null) {
				diagnostics.add (new Diagnostic.error (this.name_ref, "Unknown function %s".printf (this.name)));
			}
			if (this.arg_list != null)
				this.arg_list.fill_diagnostics (env, diagnostics);
		}

		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			if (this.name_ref.contains (file, pos) && tr.find_function (this.name) != null) {
				var hover = new Hover ();
				hover.range = this.sref.to_lsp_range ();
				hover.contents = new MarkupContent ();
				hover.contents.kind = "markdown";
				hover.contents.value = tr.find_function (this.name).generate_docs ();
				return hover;
				// TODO: Load info from TypeRegistry
			} else if (this.arg_list != null && this.arg_list is ArgumentList && this.arg_list.sref.contains (file, pos) && this.name == "get_option") {
				var args = ((ArgumentList)this.arg_list).args;
				if (args.size != 0) {
					var first_arg = args[0];
					if (first_arg is StringLiteral) {
						var option_name = ((StringLiteral) first_arg).val;
						info ("Found call get_option(%s)", option_name);
						var hover = new Hover ();
						var opt = ctx.options[option_name];
						if (opt != null) {
							hover.range = this.arg_list.sref.to_lsp_range ();
							hover.contents = new MarkupContent ();
							hover.contents.kind = "markdown";
							hover.contents.value = "Option `%s`\n\nType: %s\n\nDescription: %s\n".printf (option_name, opt.type, opt.description);
							return hover;
						} else {
							info ("Is null????");
						}
					}
				}
			}

			if (this.arg_list != null)
				return this.arg_list.hover (tr, file, pos, ctx);
			return null;
		}

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			if (this.arg_list != null)
				this.arg_list.document_symbols (path, into);
			var symbol = new DocumentSymbol ();
			symbol.kind = SymbolKind.Function;
			symbol.name = null;
			symbol.range = this.name_ref.to_lsp_range ();
			if (this.sref.file == path)
				into.add (symbol);
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			return this.arg_list == null ? null : this.arg_list.find_identifier (file, pos);
		}

		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "function_expression") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected FunctionExpression, got %s".printf (tsn.type ()));
			}
			var ret = new FunctionExpression ();
			ret.name_ref = new SourceReference (filename, tsn.named_child (0));
			ret.sref = new SourceReference (filename, tsn);
			ret.name = Util.get_string_value (data, tsn.named_child (0));
			if (tsn.named_child_count () == 2) {
				ret.arg_list = ArgumentList.parse (data, filename, tsn.named_child (1), diagnostics);
			}
			return ret;
		}
	}
	class ArgumentList : Expression {
		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			foreach (var e in this.args) {
				var h = e.hover (tr, file, pos, ctx);
				if (h != null)
					return h;
			}
			return null;
		}
		internal Gee.List<Expression> args { get; set; default = new Gee.ArrayList<Expression> (); }

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			foreach (var expr in this.args) {
				var s = expr.find_identifier (file, pos);
				if (s != null)
					return s;
			}
			return null;
		}
		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "argument_list") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected ArgumentList, got %s".printf (tsn.type ()));
			}
			var ret = new ArgumentList ();
			ret.sref = new SourceReference (filename, tsn);
			for (var i = 0; i < tsn.named_child_count (); i++) {
				var c = tsn.named_child (i);
				if (c.type () == "expression") {
					ret.args.add (Expression.parse (data, filename, c, diagnostics));
				} else {
					ret.args.add (KeywordArgument.parse (data, filename, c, diagnostics));
				}
			}
			return ret;
		}

		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			foreach (var t in this.args)
				t.fill_diagnostics (env, diagnostics);
		}
	}
	class KeywordArgument : Expression {
		internal string name;
		internal SourceReference key_ref;
		internal Expression inner;

		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			return this.inner.hover (tr, file, pos, ctx);
		}

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			this.inner.document_symbols (path, into);
			var symbol = new DocumentSymbol ();
			symbol.kind = SymbolKind.Key;
			symbol.name = null;
			symbol.range = this.key_ref.to_lsp_range ();
			if (this.sref.file == path)
				into.add (symbol);
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			return this.inner.find_identifier (file, pos);
		}

		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "keyword_item") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected KeywordItem, got %s".printf (tsn.type ()));
			}
			var ret = new KeywordArgument ();
			ret.sref = new SourceReference (filename, tsn);
			ret.key_ref = new SourceReference (filename, tsn.named_child (0));
			ret.name = Util.get_string_value (data, tsn.named_child (0));
			ret.inner = Expression.parse (data, filename, tsn.named_child (1), diagnostics);
			return ret;
		}

		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			this.inner.fill_diagnostics (env, diagnostics);
		}
	}
	class BinaryExpresssion : Expression {
		internal Expression rhs;
		internal Expression lhs;
		internal BinaryOperator op;

		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			var r = rhs.deduce_types (env);
			var l = lhs.deduce_types (env);
			switch (this.op) {
			case BinaryOperator.EQ_EQ:
			case BinaryOperator.N_EQ:
			case BinaryOperator.GE:
			case BinaryOperator.GT:
			case BinaryOperator.LE:
			case BinaryOperator.LT:
			case BinaryOperator.IN:
			case BinaryOperator.NOT_IN:
			case BinaryOperator.OR:
			case BinaryOperator.AND:
				return ListUtils.of (Elementary.BOOL);
			case BinaryOperator.PLUS:
				var ret = new Gee.HashSet<MesonType>();
				foreach (var ri in r) {
					foreach (var li in l) {
						if (li is MList) {
							var mlist = new MList (((MList) li).values.to_array ());
							mlist.values.add_all ((ri is MList) ? ((MList) ri).values : ListUtils.of (ri));
							ret.add (mlist);
						} else if (li is Dictionary && ri is Dictionary) {
							var dict = new Dictionary (((Dictionary) li).values.to_array ());
							dict.values.add_all ((ri is Dictionary) ? ((Dictionary) ri).values : ListUtils.of (ri));
							ret.add (dict);
						} else if (li is Elementary && ri is Elementary) {
							if (ri == li && li == Elementary.STR || li == Elementary.INT)
								ret.add (li);
						}
					}
				}
				if (!ret.is_empty)
					return ret;
				break;
			case BinaryOperator.SLASH:
				var ret = new Gee.HashSet<MesonType>();
				foreach (var ri in r) {
					foreach (var li in l) {
						if (ri == li)
							if (ri == Elementary.STR)
								ret.add (Elementary.STR);
							else if (ri == Elementary.INT)
								ret.add (Elementary.INT);
					}
				}
				if (!ret.is_empty)
					return ret;
				break;
			case BinaryOperator.STAR:
			case BinaryOperator.MOD:
			case BinaryOperator.MINUS:
				foreach (var ri in r) {
					foreach (var li in l) {
						if (ri == li && ri == Elementary.INT)
							return ListUtils.of (Elementary.INT);
					}
				}
				break;
			}
			return ListUtils.of (Elementary.NOT_DEDUCEABLE);
		}

		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			this.rhs.fill_diagnostics (env, diagnostics);
			this.lhs.fill_diagnostics (env, diagnostics);
		}

		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			var h = rhs.hover (tr, file, pos, ctx);
			if (h != null)
				return h;
			return this.lhs.hover (tr, file, pos, ctx);
		}

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			this.lhs.document_symbols (path, into);
			this.rhs.document_symbols (path, into);
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			var s = this.rhs.find_identifier (file, pos);
			if (s != null)
				return s;
			return this.lhs.find_identifier (file, pos);
		}

		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "binary_expression") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected BinaryExpression, got %s".printf (tsn.type ()));
			}
			var ret = new BinaryExpresssion ();
			ret.sref = new SourceReference (filename, tsn);
			ret.lhs = Expression.parse (data, filename, tsn.named_child (0), diagnostics);
			var op = tsn.named_child_count () == 2 ? tsn.child (1) : tsn.named_child (1);
			switch (Util.get_string_value (data, op).strip ()) {
			case "+":
				ret.op = BinaryOperator.PLUS;
				break;
			case "-":
				ret.op = BinaryOperator.MINUS;
				break;
			case "*":
				ret.op = BinaryOperator.STAR;
				break;
			case "/":
				ret.op = BinaryOperator.SLASH;
				break;
			case "%":
				ret.op = BinaryOperator.MOD;
				break;
			case "==":
				ret.op = BinaryOperator.EQ_EQ;
				break;
			case "!=":
				ret.op = BinaryOperator.N_EQ;
				break;
			case ">":
				ret.op = BinaryOperator.GT;
				break;
			case "<":
				ret.op = BinaryOperator.LT;
				break;
			case ">=":
				ret.op = BinaryOperator.GE;
				break;
			case "<=":
				ret.op = BinaryOperator.LE;
				break;
			case "in":
				ret.op = BinaryOperator.IN;
				break;
			case "not in":
				ret.op = BinaryOperator.NOT_IN;
				break;
			case "or":
				ret.op = BinaryOperator.OR;
				break;
			case "and":
				ret.op = BinaryOperator.AND;
				break;
			default:
				ret.op = BinaryOperator.PLUS;
				diagnostics.add (new Diagnostic.error (
									 new SourceReference (filename, op),
									 "Unexpected binary operator: %s".printf (Util.get_string_value (data, op).strip ())
				));
				break;
			}
			ret.rhs = Expression.parse (data, filename, tsn.named_child (tsn.named_child_count () == 2 ? 1 : 2), diagnostics);
			return ret;
		}
	}
	enum BinaryOperator {
		PLUS, MINUS, STAR, SLASH, MOD, EQ_EQ, N_EQ, GT, LT, GE, LE, IN, NOT_IN, OR, AND
	}
	class UnaryExpression : Expression {
		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			return this.rhs.hover (tr, file, pos, ctx);
		}
		internal Expression rhs;
		internal UnaryOperator op;

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			this.rhs.document_symbols (path, into);
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			return this.rhs.find_identifier (file, pos);
		}

		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			if (this.op == UnaryOperator.MINUS) {
				return ListUtils.of (Elementary.INT);
			}
			return ListUtils.of (Elementary.BOOL);
		}

		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			var found_required = false;
			foreach (var f in this.rhs.deduce_types (env)) {
				if (this.op == UnaryOperator.MINUS && f == Elementary.INT)
					found_required = true;
				else if (this.op != UnaryOperator.MINUS && f == Elementary.BOOL)
					found_required = true;
			}
			if (!found_required) {
				diagnostics.add (new Diagnostic.error (this.sref, "Invalid unary operator"));
			}
			this.rhs.fill_diagnostics (env, diagnostics);
		}

		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "unary_expression") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected UnaryExpression, got %s".printf (tsn.type ()));
			}
			var ret = new UnaryExpression ();
			ret.sref = new SourceReference (filename, tsn);
			ret.rhs = Expression.parse (data, filename, tsn.named_child (0), diagnostics);
			switch (Util.get_string_value (data, tsn.child (0)).strip ()) {
			case "not":
				ret.op = UnaryOperator.NOT;
				break;
			case "!":
				ret.op = UnaryOperator.EXCLAMATION_MARK;
				break;
			case "-":
				ret.op = UnaryOperator.MINUS;
				break;
			default:
				ret.op = UnaryOperator.NOT;
				diagnostics.add (new Diagnostic.error (
									 new SourceReference (filename, tsn.child (0)),
									 "Unexpected unary operator: %s".printf (Util.get_string_value (data, tsn.child (0)).strip ())
				));
				break;
			}
			return ret;
		}
	}

	enum UnaryOperator {
		NOT, EXCLAMATION_MARK, MINUS
	}

	class ArrayAccessExpression : Expression {
		// outer[inner]
		internal Expression inner;
		internal Expression outer;

		internal override Gee.Set<MesonType> deduce_types (MesonEnv env) {
			var types = outer.deduce_types (env);
			var s = new Gee.HashSet<MesonType>();
			foreach (var t in types) {
				if (t is MList) {
					s.add_all (((MList) t).values);
				}
			}
			if (s.is_empty)
				return ListUtils.of (Elementary.NOT_DEDUCEABLE);
			return s;
		}

		internal override new Hover? hover (TypeRegistry tr, string file, Position pos, HoverContext ctx) {
			var h = this.inner.hover (tr, file, pos, ctx);
			if (h != null)
				return h;
			return this.outer.hover (tr, file, pos, ctx);
		}

		internal override void document_symbols (string path, Gee.List<DocumentSymbol> into) {
			this.inner.document_symbols (path, into);
			this.outer.document_symbols (path, into);
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			var s = this.outer.find_identifier (file, pos);
			if (s != null)
				return s;
			return this.inner.find_identifier (file, pos);
		}

		internal override new void fill_diagnostics (MesonEnv env, Gee.List<Diagnostic> diagnostics) {
			var found_list = false;
			foreach (var f in this.outer.deduce_types (env)) {
				if (f is MList || f == Elementary.STR || (f is ObjectType && ((ObjectType) f).name == "custom_tgt"))
					found_list = true;
				// TODO: custom_target etc can be used, too
			}
			if (!found_list) {
				diagnostics.add (new Diagnostic.error (this.sref, "Can't access object as a list"));
			}
			this.inner.fill_diagnostics (env, diagnostics);
			this.outer.fill_diagnostics (env, diagnostics);
		}

		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn, Gee.Set<Diagnostic> diagnostics) {
			if (tsn.type () != "subscript_expression") {
				return new ErrorNode (new SourceReference (filename, tsn), "Expected SubscriptExpression, got %s".printf (tsn.type ()));
			}
			var ret = new ArrayAccessExpression ();
			ret.sref = new SourceReference (filename, tsn);
			ret.outer = Expression.parse (data, filename, tsn.named_child (0), diagnostics);
			ret.inner = Expression.parse (data, filename, tsn.named_child (1), diagnostics);
			return ret;
		}
	}

	class ListUtils {
		internal static Gee.Set<MesonType> of (MesonType t) {
			var ret = new Gee.HashSet<MesonType>();
			ret.add (t);
			if (t is Elementary && ((Elementary)t) == Elementary.NOT_DEDUCEABLE) {
				ret.add (new MList (new MesonType[]{Elementary.NOT_DEDUCEABLE}));
				ret.add (new Dictionary (new MesonType[]{Elementary.NOT_DEDUCEABLE}));
			}
			return ret;
		}
	}
}
