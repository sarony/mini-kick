require "spec_helper"

describe Back do
  before(:each) { Back.destroy_all }
  before(:each) { Project.destroy_all }
  before(:each) { Back.clear_cc_numbers }

  describe "#project" do
    it "returns the associated project" do
      project = Project.create(["Backed", "30"])
      back = Back.create(["backer", "Backed", "79927398713", "40"])

      expect(back.project).to be_a(Project)
    end
  end

  describe ".all" do
    it "returns all the backs" do
      project = Project.create(["Backed", "30"])
      back = Back.create(["backer", "Backed", "79927398713", "40"])

      all_backs = Back.all

      expect(all_backs).to include(back)
    end
  end

  describe ".destroy_all" do
    it "destroys all the backs" do
      project = Project.create(["Backed", "30"])
      back = Back.new(["backer", "Backed", "79927398713", "40"])

      Back.destroy_all
      all_backs = Back.all

      expect(all_backs).to be_empty
    end
  end

  describe ".find_all_by_project" do
    it "returns all backs the belongs to a project" do
      project = Project.create(["Backed", "30"])
      back = Back.create(["backer", "Backed", "79927398713", "40"])

      found_back = Back.find_all_by_project(back.project)

      expect(found_back).to include(back)
    end
  end

  describe ".find_by_name" do
    it "returns all backs for a given backer name" do
      project = Project.create(["Backed", "30"])
      back = Back.create(["backer", "Backed", "79927398713", "40"])

      found_back = Back.find_by_name("backer")

      expect(found_back).to eq(back)
    end
  end

  describe "#valid?" do
    it "returns true if args are valid" do
      project = Project.create(["Backed", "30"])
      back = Back.new(["backer", "Backed", "79927398713", "40"])

      expect(back.valid?).to eq(true)
    end

    it "returns false and has an error if name has forbidden characters" do
      project = Project.create(["Backed", "30"])
      back = Back.new(["backer$", "Backed", "79927398713", "40"])

      expect(back.valid?).to eq(false)
      expect(back.errors).to include(I18n.t("back.errors.backer_name.invalid_format"))
    end

    it "returns false and has an error if name is not correct length" do
      project = Project.create(["Backed", "30"])
      back = Back.new(["hi", "Backed", "79927398713", "40"])

      expect(back.valid?).to eq(false)
      expect(back.errors).to include(I18n.t("back.errors.backer_name.invalid_length"))
    end

    it "returns false and has an error if credit card isn't all numerical" do
      project = Project.create(["Backed", "30"])
      back = Back.new(["Backer", "Backed", "A9", "40"])

      expect(back.valid?).to eq(false)
      expect(back.errors).to include(I18n.t("back.errors.credit_card.invalid_format"))
    end

    it "returns false and has an error if credit card is too long" do
      project = Project.create(["Backed", "30"])
      back = Back.new(["Backer", "Backed", "9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999", "40"])

      expect(back.valid?).to eq(false)
      expect(back.errors).to include(I18n.t("back.errors.credit_card.invalid_length"))
    end

    it "returns false and has an error if credit card doesn't pass luhn-10" do
      project = Project.create(["Backed", "30"])
      back = Back.new(["Backer", "Backed", "79927398714", "40"])

      expect(back.valid?).to eq(false)
      expect(back.errors).to include(I18n.t("back.errors.credit_card.invalid_luhn"))
    end

    it "returns false and has an error if credit card isn't unique" do
      project = Project.create(["Backed", "30"])
      back = Back.create(["Backer", "Backed", "79927398713", "40"])
      back_duplicate = Back.new(["Backer_Duplicate", "Backed", "79927398713", "40"])

      expect(back_duplicate.valid?).to eq(false)
      expect(back_duplicate.errors).to include(I18n.t("back.errors.credit_card.duplicate"))
    end

    it "returns false and has an error if backing dollars have invalid characters" do
      project = Project.create(["Backed", "30"])
      back = Back.new(["Baackk", "Backed", "79927398713", "$#40"])

      expect(back.valid?).to eq(false)
      expect(back.errors).to include(I18n.t("back.errors.backing_amount.invalid_format"))
    end
  end
end
