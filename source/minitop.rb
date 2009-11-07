require 'rubygems'
gem "treetop"
require 'treetop'
Polyglot.load '../grammars/regexp'
Polyglot.load '../grammars/minitop'
require 'pp'
require '../misc/assert'
require 'readline'

# i    Ignore case when matching text.
# m    The pattern is to be matched against multiline text, so treat newline as an ordinary character: allow . to match newlines.
# x    Extended syntax: allow whitespace and comments in regexp.
# o     Perform #{} interpolations only once, the first time the regexp literal is evaluated.
# u,e,s,n  Interpret the regexp as Unicode (UTF-8), EUC, SJIS, or ASCII. If none of these modifiers is specified, the regular expression is assumed to use the source encoding.

map = {
    "^" => "start_of_line",
    "$" => "end_of_line",
    '\A' => "start_of_string",
    '\z' => "end_of_string",
    '\s' => "white_space",
    '\S' => "non_white_space",
    '\d' => "digit",
    '\D' => 'non_digit',
    '\w' => 'word', # letter, digit, underscope
    '\W' => 'non_word',
    }

module Minitop
  module_function

  module ParserExtension

  end

  def parse_expression(expression)
    expression
  end

  def create_grammar_for(parsed_rule, grammar_name)
    "grammar #{grammar_name}
      include RegExpParser

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

mt = MinitopParser.new

assert{ mt.parse('\d+') }
assert{ mt.parse('\d+\w') }
assert{ mt.parse('(\d+\w)') }
assert{ mt.parse('<\d+\w>') }
assert{ mt.parse('(\\d+\w)') }
assert{ mt.parse('(\\[da.]+\w)') }
assert{ mt.parse('(\\[^da.]+\w)') }



loop do
  line = Readline::readline('> ')
  Readline::HISTORY.push(line)
  if line.strip == 'reload!'
    load(__FILE__)
  elsif line.strip == 'exit'
    exit
  elsif res = mt.parse(line)
    puts res.to_s
    pp res
  else
    puts "could not parse"
  end
end