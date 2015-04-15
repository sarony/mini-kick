class Backer
  attr_reader :name, :back

  def initialize(args)
    @name = args.first
    @back = set_back
  end

  def self.create(args)
    backer = new(args)
    puts backer.show_info
  end

  def show_info
    I18n.t(
      "backer.show_info",
      project_name: back.project.name,
      backing_amount: back.backing_amount
    )
  end

  private

  def set_back
    Back.find_by_name(name)
  end
end
