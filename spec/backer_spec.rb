require "spec_helper"

describe Backer do
  describe ".initialize" do
    it "takes a name and sets a back" do
      project = Project.create(["project", "44"])
      back = Back.create(["John", "project", "49927398716", "20"])
      backer = Backer.new(["John"])

      name = backer.name

      expect(name).to eq("John")
      expect(backer.back).to eq(back)
    end
  end

  describe "#show_info" do
    it "shows what the backer's backed and their backing_amount" do
      project = Project.create(["project", "44"])
      back = Back.create(["John", "project", "49927398716", "20"])
      backer = Backer.new(["John"])

      backer_info = backer.show_info

      expect(backer_info).to eq(
        "Backed #{project.name} for #{back.backing_amount}"
      )
    end
  end
end
