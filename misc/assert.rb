require 'parse_tree'
require 'parse_tree_extensions'
require 'ruby2ruby'
require 'set'

module Assert
  def self.failures
    @failures ||= Array.new
  end

  def Assert.write(text)
    $stderr.puts(text)
  end

  def assert(value=true, &block)
    comment = block.to_ruby[7..-2].strip
    variables = Hash.new
    block_sexp = block.to_sexp.to_a.flatten
    block_sexp.each_with_index{|s,i|
      next unless s == :lvar
      vname = block_sexp[i+1].to_s
      variables[vname] = eval(vname, block.binding)
    }

    if match = (/^\|(.+?)\|(.+)/m).match(comment)
      comment = match[2].strip
    end

    passed = true
    begin
      result = block.call()

      if (result == value)
        Assert.write("[\033[32mPASSED\033[0m] #{comment} == #{value}")
      elsif (value == true && result)
        Assert.write("[\033[32mPASSED\033[0m] #{comment} is true")
      else
        passed = false
        Assert.write(
          "[\033[31mFAILED\033[0m] #{comment}\n"+
            "  got: #{result.inspect}\n"+
            "  expected: #{value.inspect}"
        )
      end
    rescue Exception => e
      passed = false; result = e
      Assert.write("[\033[31mRAISED\033[0m] #{comment} raised #{e.to_s}(#{e.class})")
    end

    variables.each_pair do |k,v|
      Assert.write("  %s was: %s" % [k[0..9], v.inspect[0..99]])
    end

    unless passed
      Assert.failures << {
        :backtrace   => caller,
        :call_result => result,
        :expected    => value,
        :exception   => e,
        :variables   => variables,
        :block_code  => block.to_ruby[7..-2].strip,
        :block_sexp  => block.to_sexp,
        :time        => Time.now,
      }
    end

    result.is_a?(Exception) ? raise(result) : result
  end
end

class Object
  include Assert
  extend Assert
end
