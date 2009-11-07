require 'base'

if __FILE__ == $0
  parser = Treetop.load("../grammars/minic.tt").new
  tree = parser.parse(File.read("../misc/test.c").gsub(/\\\n/m, ""))
  puts tree.gsub("Comment", '')
  tree = parser.parse('a "123456789" b')
  puts tree.gsub("StringLiteral"){|n| "t("+n.text_value+")"}
end