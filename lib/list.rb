class List
  attr_reader :project

  def initialize(args)
    @project = set_project(args.first)
    project_info
  end

  def project_info
    backers = project.backs.collect do |back|
      "-- #{back.backer} backed #{project.name} for #{back.backing_amount}\n"
    end.join("")

    puts "#{backers} #{project.status}"
  end

  private

  def project_needs
    puts "#{project.name} needs #{project.amount_needed} more dollars to be successful"
  end

  def set_project(project_name)
    Project.find_by_name(project_name)
  end
end
