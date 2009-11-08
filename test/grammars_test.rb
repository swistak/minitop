require 'test_helper'

class GrammarsTest < Test::Unit::TestCase
  context "Grammar" do
    %w{arithmetic common list minic minitop}.each do |grammar|
      context grammar do
        should "be valid" do
          assert_nothing_raised(RuntimeError, "Grammar '#{grammar}.tt' is not valid") {
            Treetop.load(File.join(ROOT, 'grammars', grammar+'.tt'))
          }
        end
      end
    end
  end
end