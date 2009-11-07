require 'rubygems'
gem "treetop"
require 'treetop'
require 'pp'
require '../misc/assert'
require 'readline'
require 'base'

module InlineRule
  def serialize
    "\nrule #{name}\n  #{definition}\nend\n"
  end
end

module SpecialCharacter
  MAP = {
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

  def serialize
    MAP[text_value] || ""
  end
end

Treetop.load('../grammars/common.tt')

grammar = <<START
grammar MinitopParser
  include Common

  rule expression
    (inline_rule / special_character / string)+ {}
  end

  rule inline_rule
    name:(character word+) white_space? ':' white_space? definition:(!'\\n' .)+ '\\n' <InlineRule>
  end

  rule special_character
    ('\\S' / '\\s' / '\\W' / '\\w' / '\\A' / '\\D' / '\\d' / '\\z' / '$' / '^') <SpecialCharacter>
  end

  rule string
    (![\n\\\\] .)+ { def serialize; ' "'+text_value+'" '; end }
  end
end
START

mt = Treetop.load_from_string(grammar).new
tree = mt.parse('foo\d+\W')
puts tree.serialize