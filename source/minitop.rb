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
mt = Treetop.load('../grammars/minitop.tt').new
tree = mt.parse('foo\d+\W')
puts tree.serialize