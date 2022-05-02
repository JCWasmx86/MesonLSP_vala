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
	class SourceReference {
		internal uint start_line;
		internal uint start_column;
		internal uint end_line;
		internal uint end_column;
		internal string file;

		internal SourceReference (string filename, TreeSitter.TSNode node) {
			this.file = filename;
			this.start_line = node.start_point().row;
			this.start_column = node.start_point().column;
			this.end_line = node.end_point().row;
			this.end_column = node.end_point().column;
		}

		internal bool contains (string file, Position pos) {
			//info ("Is %s(%u:%u) in %s(%u:%u->%u:%u)?", file, pos.line, pos.character, this.file, this.start_line, this.start_column, this.end_line, this.end_column);
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
	}

	class SourceFile {
		internal string filename;
		internal Gee.List<Statement> statements { get; set; default = new Gee.ArrayList<Statement> (); }

		internal static SourceFile build_ast (string data, string filename, TreeSitter.TSNode root) {
			var ret = new SourceFile ();
			ret.filename = filename;
			if (root.named_child_count() == 0) {
				info ("No build_definition found!");
				return ret;
			}
			var build_def = root.named_child (0);
			if (build_def.type () != "build_definition") {
				return ret;
			}
			for (var i = 0; i < build_def.named_child_count (); i++) {
				var stmt = build_def.named_child (i);
				if (stmt.type() == "comment")
					continue;
				if (stmt.named_child_count () == 1 && stmt.named_child (0).type() == "comment")
					continue;
				if (stmt.named_child_count() == 0)
					continue;
				ret.statements.add (Statement.parse (data, filename, stmt));
			}
			return ret;
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
	}
	class SymbolDefinition {
		internal SourceReference sref;
		internal bool is_foreach;
		internal SourceReference? parent;
	}

	class JumpStatement : Statement {
		internal bool is_break;
	}

	class Statement : CodeNode {
		internal static Statement parse (string data, string filename, TreeSitter.TSNode tsn) {
			if (tsn.type () != "statement" && tsn.type() != "comment") {
				var js = new JumpStatement ();
				js.sref = new SourceReference (filename, tsn);
				js.is_break = Util.get_string_value (data, tsn).strip () == "break";
				return js;
			}
			var child = tsn.named_child (0);
			switch (child.type ()) {
			case "expression":
				return Expression.parse (data, filename, child);
			case "assignment_statement":
				return AssignmentStatement.parse (data, filename, child);
			case "selection_statement":
				return SelectionStatement.parse (data, filename, child);
			case "iteration_statement":
				return IterationStatement.parse (data, filename, child);
			case "comment":
				info ("COMMENT: %s", child.to_string ());
				info ("COMMENT: %s", tsn.to_string ());
				break;
			}
			critical ("Unknown thing: %s", child.type());
			return null;
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
	}

	class SelectionStatement : Statement {
		Gee.List<Expression> conditions {get; set; default = new Gee.ArrayList<Expression>(); }
		Gee.List<Gee.List<Statement>> blocks {get; set; default = new Gee.ArrayList<Gee.ArrayList<Statement>> (); }

		internal override Gee.List<SymbolDefinition> find_symbol (string name) {
			var ret = new Gee.ArrayList<SymbolDefinition>();
			foreach (var b in this.blocks) {
				foreach (var s in b)
					ret.add_all (s.find_symbol (name));
			}
			return ret;
		}

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
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

		internal static new SelectionStatement parse (string data, string filename, TreeSitter.TSNode tsn) {
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
					ret.conditions.add (Expression.parse (data, filename, condition.named_child (0)));
					i++;
				} else if (Util.get_string_value (data, c).strip () == "else if") {
					ret.blocks.add (tmp);
					while (Posix.strcmp (tsn.child (i + 1).type (), "comment") == 0) {
						i++;
					}
					tmp = new Gee.ArrayList<Statement>();
					var condition = tsn.child (i + 1);
					ret.conditions.add (Expression.parse (data, filename, condition.named_child (0)));
					i++;
				} else if (Util.get_string_value (data, c).strip () == "else") {
					ret.blocks.add (tmp);
					tmp = new Gee.ArrayList<Statement>();
				} else if (c.type () == "statement" && (c.named_child_count () == 1 && c.named_child (0).type() != "comment")) {
					tmp.add (Statement.parse (data, filename, c));
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

		internal override Gee.List<SymbolDefinition> find_symbol (string name) {
			var ret = new Gee.ArrayList<SymbolDefinition>();
			foreach (var s in this.statements) {
				ret.add_all (s.find_symbol (name));
			}
			foreach (var i in this.identifiers) {
				if (i is Identifier) {
					var ii = (Identifier)i;
					if (ii.name == name) {
						var sym = new SymbolDefinition();
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


		internal static new IterationStatement parse (string data, string filename, TreeSitter.TSNode tsn) {
			var ret = new IterationStatement ();
			ret.sref = new SourceReference (filename, tsn);
			var ids = tsn.named_child (0);
			for (var i = 0; i < ids.named_child_count (); i++) {
				var x = ids.named_child (i);
				ret.identifiers.add (Expression.parse (data, filename, x));
			}
			ret.id = Expression.parse (data, filename, tsn.named_child (1));
			for (var i = 2; i < tsn.named_child_count (); i++) {
				if (tsn.named_child (i).type () == "comment")
					continue;
				var stmt = tsn.named_child (i);
				if (stmt.named_child_count () == 1 && stmt.named_child (0).type() == "comment")
					continue;
				ret.statements.add (Statement.parse (data, filename, tsn.named_child (i)));
			}
			return ret;
		}
	}

	class AssignmentStatement : Statement {
		internal Expression lhs;
		internal AssignmentOperator op;
		internal Expression rhs;

		internal override Gee.List<SymbolDefinition> find_symbol (string name) {
			var ret = new Gee.ArrayList<SymbolDefinition>();
			if (!(this.lhs is Identifier))
				return ret;
			if (((Identifier)this.lhs).name != name)
				return ret;
			// E.g. the code
			// x = [] (1)
			// x += 'foo.c' (2)
			// do_with(x)
			// Jump to (1)
			if (this.op != AssignmentOperator.EQ)
				return ret;
			var sym = new SymbolDefinition();
			sym.is_foreach = false;
			sym.sref = this.lhs.sref;
			ret.add(sym);
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


		internal static new AssignmentStatement parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "assignment_statement");
			var ret = new AssignmentStatement ();
			ret.sref = new SourceReference (filename, tsn);
			ret.lhs = Expression.parse (data, filename, tsn.named_child (0));
			ret.rhs = Expression.parse (data, filename, tsn.named_child (2));
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
		internal static new Expression parse (string data, string filename, TreeSitter.TSNode tsn) {
			if (tsn.named_child_count () == 0) {
				if (tsn.type () == "id_expression")
					return new Identifier (Util.get_string_value (data, tsn), filename, tsn);
				critical ("%s %s (%u %u)", filename, tsn.type(), tsn.start_point().row, tsn.start_point().column );
				assert_not_reached ();
			}
			switch (tsn.named_child (0).type ()) {
				case "function_expression":
					return FunctionExpression.parse (data, filename, tsn.named_child (0));
				case "conditional_expression":
					return ConditionalExpression.parse (data, filename, tsn.named_child (0));
				case "unary_expression":
					return UnaryExpression.parse (data, filename, tsn.named_child (0));
				case "subscript_expression":
					return ArrayAccessExpression.parse (data, filename, tsn.named_child (0));
				case "method_expression":
					return MethodExpression.parse (data, filename, tsn.named_child (0));
				case "binary_expression":
					return BinaryExpresssion.parse (data, filename, tsn.named_child (0));
				case "integer_literal":
					return IntegerLiteral.parse (Util.get_string_value (data, tsn.named_child (0)), filename, tsn.named_child (0));
				case "string_literal":
					return StringLiteral.parse (Util.get_string_value (data, tsn.named_child (0)), filename, tsn.named_child (0));
				case "boolean_literal":
					return BooleanLiteral.parse (Util.get_string_value (data, tsn.named_child (0)), filename, tsn.named_child (0));
				case "array_literal":
					return ArrayLiteral.parse (data, filename, tsn.named_child (0));
				case "dictionary_literal":
					return DictionaryLiteral.parse (data, filename, tsn.named_child (0));
				case "id_expression":
				case "function_id":
					return new Identifier (Util.get_string_value (data, tsn.named_child (0)), filename, tsn.named_child (0));
				case "primary_expression":
					if (tsn.named_child (0).child_count () == 1)
						return new Identifier (Util.get_string_value (data, tsn.named_child (0).named_child (0)), filename, tsn.named_child (0).named_child (0));
					return Expression.parse (data, filename, tsn.named_child (0).named_child (0));
				default:
					critical ("Unexpected: %s [%s; %u %u]", tsn.named_child (0).type (), tsn.named_child (0).to_string (), tsn.named_child (0).start_point ().row, tsn.named_child (0).start_point ().column);
					assert_not_reached ();
			}
		}
	}

	class Identifier : Expression {
		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			return this.name;
		}
		internal string name;
		internal Identifier (string name, string filename, TreeSitter.TSNode tsn) {
			this.sref = new SourceReference (filename, tsn);
			this.name = name;
		}
	}

	class DictionaryLiteral : Expression {
		internal Gee.List<Expression> keys {get; set; default = new Gee.ArrayList<Expression> (); }
		internal Gee.List<Expression> values {get; set; default = new Gee.ArrayList<Expression> (); }

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
		internal static new DictionaryLiteral parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "dictionary_literal");
			var ret = new DictionaryLiteral();
			ret.sref = new SourceReference (filename, tsn);
			for (var i = 0; i < tsn.named_child_count (); i++) {
				var kv = tsn.named_child (i);
				ret.keys.add (Expression.parse (data, filename, kv.named_child (0)));
				ret.values.add (Expression.parse (data, filename, kv.named_child (1)));
			}
			return ret;
		}
	}

	class ArrayLiteral : Expression {
		internal Gee.List<Expression> elements {get; set; default = new Gee.ArrayList<Expression> (); }
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
		internal static new ArrayLiteral parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "array_literal");
			var ret = new ArrayLiteral ();
			ret.sref = new SourceReference (filename, tsn);
			for (var i = 0; i < tsn.named_child_count (); i++) {
				if (tsn.named_child (i).type () != "expression")
					continue;
				ret.elements.add (Expression.parse (data, filename, tsn.named_child (i)));
			}
			return ret;
		}
	}

	class IntegerLiteral : Expression {
		internal int64 val;
		internal static new IntegerLiteral parse (string str, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "integer_literal");
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
		internal bool val;
		internal static new BooleanLiteral parse (string str, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "boolean_literal");
			var ret = new BooleanLiteral ();
			ret.sref = new SourceReference (filename, tsn);
			ret.val = str == "true";
			return ret;
		}
	}

	class StringLiteral : Expression {
		internal string val;
		internal static new StringLiteral parse (string str, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "string_literal");
			var ret = new StringLiteral ();
			ret.sref = new SourceReference (filename, tsn);
			ret.val = str.has_prefix ("'''") ? str.replace ("'''", "") : str.substring (1, str.length - 2);
			return ret;
		}
	}

	class MethodExpression : Expression {
		internal Expression obj;
		internal string name;
		internal ArgumentList? list;

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			var s = this.obj.find_identifier (file, pos);
			if (s != null)
				return s;
			return this.list == null ? null : this.list.find_identifier (file, pos);
		}
		internal static new MethodExpression parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "method_expression");
			var ret = new MethodExpression ();
			ret.sref = new SourceReference (filename, tsn);
			ret.obj = Expression.parse (data, filename, tsn.named_child (0));
			ret.name = Util.get_string_value (data, tsn.named_child (1));
			if (tsn.named_child_count () == 3)
				ret.list = ArgumentList.parse (data, filename, tsn.named_child (2));
			return ret;
		}
	}

	class ConditionalExpression : Expression {
		internal Expression condition;
		internal Expression if_true;
		internal Expression if_false;

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

		internal static new ConditionalExpression parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "conditional_expression");
			var ret = new ConditionalExpression ();
			ret.sref = new SourceReference (filename, tsn);
			ret.condition = Expression.parse (data, filename, tsn.named_child (0));
			ret.if_true = Expression.parse (data, filename, tsn.named_child (1));
			ret.if_false = Expression.parse (data, filename, tsn.named_child (2));
			return ret;
		}
	}
	class FunctionExpression : Expression {
		internal string name;
		internal ArgumentList? arg_list;

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			return this.arg_list == null ? null : this.arg_list.find_identifier (file, pos);
		}

		internal static new FunctionExpression parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "function_expression");
			var ret = new FunctionExpression ();
			ret.sref = new SourceReference (filename, tsn);
			ret.name = Util.get_string_value (data, tsn.named_child (0));
			if (tsn.named_child_count () == 2) {
				ret.arg_list = ArgumentList.parse (data, filename, tsn.named_child (1));
			}
			return ret;
		}
	}
	class ArgumentList : Expression {
		internal Gee.List<Expression> args {get; set; default = new Gee.ArrayList<Expression> (); }

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
		internal static new ArgumentList parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "argument_list");
			var ret = new ArgumentList ();
			ret.sref = new SourceReference (filename, tsn);
			for (var i = 0; i < tsn.named_child_count (); i++) {
				var c = tsn.named_child (i);
				if (c.type () == "expression") {
					ret.args.add (Expression.parse (data, filename, c));
				} else {
					ret.args.add (KeywordArgument.parse (data, filename, c));
				}
			}
			return ret;
		}
	}
	class KeywordArgument : Expression {
		internal string name;
		internal Expression inner;

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			return this.inner.find_identifier (file, pos);
		}

		internal static new KeywordArgument parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "keyword_item");
			var ret = new KeywordArgument ();
			ret.sref = new SourceReference (filename, tsn);
			ret.name = Util.get_string_value (data, tsn.named_child (0));
			ret.inner = Expression.parse (data, filename, tsn.named_child (1));
			return ret;
		}
	}
	class BinaryExpresssion : Expression {
		internal Expression rhs;
		internal Expression lhs;
		internal BinaryOperator op;

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			var s = this.rhs.find_identifier (file, pos);
			if (s != null)
				return s;
			return this.lhs.find_identifier (file, pos);
		}

		internal static new BinaryExpresssion parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "binary_expression");
			var ret = new BinaryExpresssion ();
			ret.sref = new SourceReference (filename, tsn);
			ret.lhs = Expression.parse (data, filename, tsn.named_child (0));
			var op = tsn.named_child_count () == 2 ? tsn.named_child (1) : tsn.child (1);
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
			}
			ret.rhs = Expression.parse (data, filename, tsn.named_child (tsn.named_child_count() == 2 ? 1 : 2));
			return ret;
		}
	}
	enum BinaryOperator {
		PLUS, MINUS, STAR, SLASH, MOD, EQ_EQ, N_EQ, GT, LT, GE, LE, IN, NOT_IN, OR, AND
	}
	class UnaryExpression : Expression {
		internal Expression rhs;
		internal UnaryOperator op;

		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			return this.rhs.find_identifier (file, pos);
		}

		internal static new UnaryExpression parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "unary_expression");
			var ret = new UnaryExpression ();
			ret.sref = new SourceReference (filename, tsn);
			ret.rhs = Expression.parse (data, filename, tsn.named_child (0));
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
		
		internal override string? find_identifier (string file, Position pos) {
			if (!this.sref.contains (file, pos))
				return null;
			var s = this.outer.find_identifier (file, pos);
			if (s != null)
				return s;
			return this.inner.find_identifier (file, pos);
		}

		internal static new ArrayAccessExpression parse (string data, string filename, TreeSitter.TSNode tsn) {
			assert (tsn.type() == "subscript_expression");
			var ret = new ArrayAccessExpression ();
			ret.sref = new SourceReference (filename, tsn);
			ret.outer = Expression.parse (data, filename, tsn.named_child (0));
			ret.inner = Expression.parse (data, filename, tsn.named_child (1));
			return ret;
		}
	}
}
