require 'base'

parser = Treetop.load("../grammars/minic.tt").new
tree = parser.parse(File.read("../misc/test.c").gsub(/\\\n/m, ""))
puts tree.replace("Comment", '')
tree = parser.parse('a "123456789" b')
puts tree.replace("StringLiteral"){|n| "t("+n.text_value+")"}