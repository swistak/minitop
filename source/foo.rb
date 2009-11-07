
# i    Ignore case when matching text.
# m    The pattern is to be matched against multiline text, so treat newline as an ordinary character: allow . to match newlines.
# x    Extended syntax: allow whitespace and comments in regexp.
# o     Perform #{} interpolations only once, the first time the regexp literal is evaluated.
# u,e,s,n  Interpret the regexp as Unicode (UTF-8), EUC, SJIS, or ASCII. If none of these modifiers is specified, the regular expression is assumed to use the source encoding.


module Minitop
  module_function

  module ParserExtension

  end

  def parse_expression(expression)
    expression.gsub()
  end

  def create_grammar_for(parsed_rule, grammar_name)
    "grammar #{grammar_name}
      include Common

      rule match
        #{parsed_rule}
      end
    end".gsub(/^ {4}/, '')
  end

  def get_mini_parser(expression)
    parsed_expression = parse_expression(expression)
    name = "GeneratedParser#{expression.hash.to_i.abs}"
    grammar = create_grammar_for(parsed_expression, name)
    File.open("last_generated_parser.tt", "w"){|f| f.write(grammar)}

    Treetop.load_from_string(grammar)

    parser_class = Kernel.const_get(name+"Parser")
    parser = parser_class.new
    parser.extend(Minitop::ParserExtension)
    parser
  end
end


def P(expression)
  Minitop.get_mini_parser(expression)
end