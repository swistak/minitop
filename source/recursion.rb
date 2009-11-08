require 'base'

list_grammar = <<TOP
grammar List
  rule list
    atom more_atoms:(',' atom)* {
      def atoms; [atom] + more_atoms.elements.map{|m| m.atom}; end
    }
  end
  rule atom
    '(' list ')' / number
  end
  rule number
    ('-'? [1-9] [0-9]* / '0')
  end
end
TOP

Treetop::Runtime::SyntaxNode.send(:include, Enumerable)
parser = Treetop.load_from_string(list_grammar).new
if tree = parser.parse('(11,(12,13,14),(15,16))')
  reverser = lambda{|n|
    n.atoms.map{|m|
      m.gsub("list", &reverser)
    }.reverse.join(",")
  }
  puts tree.gsub("list", &reverser)
end