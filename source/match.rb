require 'base'

parser = Treetop.load("../grammars/minic.tt").new
file = File.read("../misc/test.c").gsub(/\\\n/m, "")
if tree = parser.parse(file)
  puts "YES! Finally!"
  first_comment = tree.all_elements.
    detect{|e| e.has_type?("comment") }

  puts first_comment.interval
else
  puts "argh, not again"
end

