require "spec_helper"

describe Project do
  before(:each) { Project.destroy_all }
  before(:each) { Back.destroy_all }
  before(:each) { Back.clear_cc_numbers }

  describe ".all" do
    it "returns all projects" do
      project = Project.create(["project_name", "60"])

      all_projects = Project.all

      expect(all_projects).to include(project)
    end
  end

  describe ".destroy_all" do
    it "destroys all projects" do
      project = Project.create(["project_name", "60"])

      Project.destroy_all
      all_projects = Project.all

      expect(all_projects).to be_empty
    end
  end

  describe ".find_by_name" do
    it "returns a project by name if it exists" do
      project = Project.create(["Potato_Salad", "60"])

      found_project = Project.find_by_name("Potato_Salad")

      expect(found_project).to eq(project)
    end
  end

  describe "#backs" do
    it "shows the corresponding back for a project" do
      project = Project.create(["Potato_Salad", "60"])
      back = Back.create(["backer", "Potato_Salad", "79927398713", "40"])

      project_backs = project.backs

      expect(project_backs).to include(back)
    end
  end

  describe "#status" do
    it "tells us how much more the project needs to be successful" do
      project = Project.create(["Potato_Salad", "80"])
      back = Back.create(["backer", "Potato_Salad", "79927398713", "40"])

      status = project.status

      expect(status).to eq("#{project.name} needs 40 more dollars to be successful")
    end

    it "tells us when the project is successful" do
      project = Project.create(["Potato_Salad", "60", "80"])
      back = Back.create(["backer", "Potato_Salad", "79927398713", "140"])

      status = project.status

      expect(status).to eq("#{project.name} is successful!")
    end
  end

  describe "#total_backing_amount" do
    it "calculates how much total backing a project has" do
      project = Project.create(["Potato_Salad", "60", "80"])
      back = Back.create(["backer", "Potato_Salad", "79927398713", "40"])
      back_2 = Back.create(["backer_two", "Potato_Salad", "49927398716", "10"])

      total_backing_amount = project.total_backing_amount

      expect(total_backing_amount).to eq(50)
    end
  end

  describe ".valid?" do
    it "returns true for a valid name" do
      project = Project.create(["Potato_Salad", "30.00"])

      expect(project.valid?).to eq(true)
    end

    it "returns an error for a name that has invalid symbols" do
      project = Project.create(["Potato Salad$"])

      expect(project.valid?).to eq(false)
      expect(project.errors).to include(I18n.t("projects.errors.name.invalid_format"))
    end

    it "returns an error for a name that is too long" do
      project = Project.create(["Potato_Salad_That_Is_Way_Too_Long_Look_How_Long"])

      expect(project.valid?).to eq(false)
      expect(project.errors).to include(I18n.t("projects.errors.name.invalid_length"))
    end

    it "returns an error for a target amount with invalid characters" do
      project = Project.create(["Potato_Salad", "$%30"])

      expect(project.valid?).to eq(false)
      expect(project.errors).to include(I18n.t("projects.errors.target_amount.invalid_format"))
    end
  end
end
