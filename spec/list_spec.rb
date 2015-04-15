require "spec_helper"

describe List do
  before(:each) { Project.destroy_all }
  before(:each) { Back.destroy_all }
  before(:each) { Back.clear_cc_numbers }

  describe ".initialize" do
    it "should take a project_name and set to corresponding project" do
      project = Project.create(["project", "44"])
      back = Back.create(["backer", "project", "49927398716", "20"])
      list = List.new(["project"])

      list_project = list.project

      expect(list_project).to eq(project)
    end
  end

  describe ".project_info" do
    # TODO: needs to test output
    it "lists backers and backed amounts for a project" do
      project = Project.create(["project", "44"])
      back = Back.create(["backer", "project", "49927398716", "20"])

      list = List.new(["project"])
      project_info = list.project_info

      expect(project_info).to eq(
        "#{I18n.t(
          "list.backer_info",
          backer_name: back.backer,
          project_name: project.name,
          backing_amount: back.backing_amount,
        )} #{project.status}"
      )
    end
  end
end
