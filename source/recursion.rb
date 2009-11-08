require 'base'

Treetop::Runtime::SyntaxNode.send(:include, Enumerable)
parser = Treetop.load('../grammars/list.tt').new
if tree = parser.parse('(11,(12,13,14),(15,16))')
  reverser = lambda{|n|
    n.atoms.map{|m|
      m.replace("list", &reverser)
    }.reverse.join(",")
  }
  puts tree.replace("list", &reverser)
end