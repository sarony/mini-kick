class ParseInput
  COMMAND_TYPES = {
    "project" => Project,
    "back" => Back,
    "list" => List,
    "backer" => Backer,
  }

  def initialize(input)
    input = input.split(" ")
    @object = input.shift
    @args = input
    create_object
    puts "Nice! Next command?"
    MiniKick.new.run
  end

  def create_object
    COMMAND_TYPES[object].new(args)
  end

  private

  attr_reader :object, :args
end
