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
    MiniKick.new.call
  end

  def create_object
    COMMAND_TYPES[object].create(args)
  end

  private

  attr_reader :object, :args

end
