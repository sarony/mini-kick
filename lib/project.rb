class Project
  attr_reader :name, :target_amount, :errors
  NAME_FORMAT = /^[a-zA-Z0-9-_]+$/
  TARGET_AMOUNT_FORMAT = /^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$/

  @@all=[]

  def initialize(args)
    @name = args[0]
    @target_amount = args[1]
    @errors = []
  end

  def self.create(args)
    project = new(args)
    project.tap do |p|
      p.save
    end
  end

  def self.all
    @@all
  end

  def self.destroy_all
    @@all = []
  end

  def self.find_by_name(name)
    @@all.find do |project|
      project.name == name
    end
  end

  def save
    if valid?
      @@all << self
      puts I18n.t("projects.success", name: name, target_amount: target_amount)
    else
      puts errors.join(". ")
    end
  end

  def valid?
    valid_name? && valid_target_amount?
  end

  def status
    if has_reached_goal
      successful_message
    else
      in_progress_message
    end
  end

  def backs
    Back.find_all_by_project(self)
  end

  def total_backing_amount
    backs.collect do |back|
      back.backing_amount.to_i
    end.inject(&:+)
  end

  private

  def in_progress_message
    "#{name} needs #{amount_needed} more dollars to be successful"
  end

  def successful_message
    "#{name} is successful!"
  end

  def has_reached_goal
    amount_needed <= 0
  end

  def amount_needed
    target_amount.to_i - total_backing_amount
  end

  def valid_name?
    valid_name_format? && valid_name_length?
  end

  def valid_name_format?
    if name =~ NAME_FORMAT
      true
    else
      errors << I18n.t("projects.errors.name.invalid_format")
      false
    end
  end

  def valid_name_length?
    if (name.length >= 4) && (name.length <= 20)
      true
    else
      errors << I18n.t("projects.errors.name.invalid_length")
      false
    end
  end

  def valid_target_amount?
    if valid_target_amount_format
      true
    else
      errors << I18n.t("projects.errors.target_amount.invalid_format")
      false
    end
  end

  def valid_target_amount_format
    target_amount =~ TARGET_AMOUNT_FORMAT
  end

  def success_message
    I18n.t("projects.success", name: name, target_amount: target_amount)
  end
end
