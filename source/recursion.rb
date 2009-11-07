require 'base'

class Treetop::Runtime::SyntaxNode
  include Enumerable
end

list_grammar = <<TOP
grammar List
  rule list
    atom more_atoms:(',' atom)*
  end
  rule atom
    '(' list ')' / number
  end
  rule number
    ('-'? [1-9] [0-9]* / '0')
  end
end
TOP

parser = Treetop.load_from_string(list_grammar).new
if tree = parser.parse('(11,(12,13,14),(15,16))')
  reverser = lambda{|n|
    atoms = [n.atom] + n.more_atoms.elements.map{|m| m.atom} 
    atoms.map{|m|
      m.gsub("list", &reverser)
    }.reverse.join(",")
  }
  puts tree.gsub("list", &reverser)
else
  puts "buu"
end