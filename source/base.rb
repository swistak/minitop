require 'rubygems'
require 'treetop'
require 'pp'

class Treetop::Runtime::SyntaxNode
  def node_types
    types = extension_modules + [self.class]
    types.map{|type| type.to_s.split("::").last.gsub(/\d+$/, "")}
  end

  def has_type?(type)
    node_types.include?(type) || node_types.include?(type.treetop_camelize)
  end

  def serialize
    terminal? ? text_value : elements.map{|e| e.serialize}.join("")
  end

  def all_elements
    result = elements.dup
    result.each{|e| result.push(*e.elements) if e.nonterminal?}
  end

  def gsub(node, with=nil, &block)
    raise ArgumentError, "You have to provide either a block or value to replace", caller unless with || block
    if has_type?(node)
      with || block.call(self)
    elsif terminal?
      serialize
    else
      elements.map{|e| e.gsub(node, with, &block)}.join("")
    end
  end

  def to_s
    serialize
  end
end

module Comment; end
module StringLiteral; end
class Code < Treetop::Runtime::SyntaxNode; end
