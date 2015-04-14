require "pry"
require_relative "back"
require_relative "backer"
require_relative "list"
require_relative "minikick"
require_relative "project"
require_relative "parse_input"

class MiniKick
  def run
    @input = gets.strip
    ParseInput.new(@input)
  end
end

# MiniKick.new.run
