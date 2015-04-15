class List
  attr_reader :project

  def initialize(args)
    @project = set_project(args.first)
  end

  def self.create(args)
    list = new(args)
    puts list.project_info
  end

  def project_info
    backers = project.backs.collect do |back|
      I18n.t(
        "list.backer_info",
        backer: back.backer,
        project_name: project.name,
        backing_amount: back.backing_amount,
      )
    end.join("")

    "#{backers} #{project.status}"
  end

  private

  def set_project(project_name)
    Project.find_by_name(project_name)
  end
end
