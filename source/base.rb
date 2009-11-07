require 'rubygems'
require 'treetop'
require 'pp'

class Treetop::Runtime::SyntaxNode
  def node_types
    types = extension_modules + [self.class]
    types.map{|type| type.to_s.split("::").last.gsub(/\d+$/, "")}
  end

  def serialize
    terminal? ? text_value : elements.map{|e| e.serialize}.join("")
  end

  def all_elements
    result = elements.dup
    result.each{|e| result.push(*e.elements) if e.nonterminal?}
  end

  def gsub(node, with=nil, &block)
    raise ArgumentError, "You have to provide either a block or walue to replace", caller unless with || block
    if terminal?
      text_value
    elsif node_types.include?(node)
      with || block.call(self)
    else
      elements.map{|e| e.gsub(node, with, &block)}.join("")
    end
  end

  def to_s
    text_value
  end
end
module Comment; end
module StringLiteral; end
class Code < Treetop::Runtime::SyntaxNode;end
