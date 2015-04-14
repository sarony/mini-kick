class Backer
  attr_reader :name, :back

  def initialize(args)
    @name = args.first
    @back = set_back
    show_info
  end

  def show_info
    puts "-- Backed #{back.project.name} for #{back.backing_amount}"
  end

  private

  def set_back
    Back.find_by_name(name)
  end
end
