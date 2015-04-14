require "pry"
class Back
  attr_reader :args, :backer, :project, :cc_number, :backing_amount, :errors
  BACKER_FORMAT = /^[a-zA-Z0-9-_]+$/
  BACKING_AMOUNT_FORMAT = /^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$/
  CREDIT_CARD_FORMAT = /^[0-9]+$/
  @@all = []
  @@credit_cards = []

  def initialize(args)
    @args = args
    @backer = args[0]
    @project = set_project
    @cc_number = args[2]
    @backing_amount = args[3]
    @errors = []
  end

  def save
    if valid?
      @@all << self
      @@credit_cards << cc_number
      puts success_message
    else
      puts errors.join(". ")
    end
  end

  def self.create(args)
    back = self.new(args)
    back.tap do |b|
      b.save
    end
  end

  def self.all
    @@all
  end

  def self.credit_cards
    @@credit_cards
  end

  def self.destroy_all
    @@all = []
  end

  def self.clear_cc_numbers
    @@credit_cards = []
  end

  def self.find_all_by_project(project)
    all.select do |back|
      back.project == project
    end
  end

  def self.find_by_name(name)
    all.find do |back|
      back.backer == name
    end
  end

  def valid?
    valid_backer? && valid_cc_number? && valid_backing_amount?
  end

  private

  def set_project
    Project.find_by_name(args[1])
  end

  def valid_backer?
    valid_backer_length && valid_backer_format
  end

  def valid_backer_length
    if (backer.length >= 4) && (backer.length <= 20)
      true
    else
      errors << I18n.t("back.errors.backer_name.invalid_length")
      false
    end
  end

  def valid_backer_format
    if backer =~ BACKER_FORMAT
      true
    else
      errors << I18n.t("back.errors.backer_name.invalid_format")
      false
    end
  end

  def valid_cc_number?
    unique && valid_cc_number_format && valid_cc_number_length && valid_luhn
  end

  def unique
    if cc_unique?
      true
    else
      errors << I18n.t("back.errors.credit_card.duplicate")
      false
    end
  end

  def cc_unique?
    !@@credit_cards.include?(cc_number)
  end

  def valid_luhn
    if cc_valid?
      true
    else
      errors << I18n.t("back.errors.credit_card.invalid_luhn")
      false
    end
  end

  def cc_valid?
    digits = cc_number.scan(/./).map(&:to_i)
    check = digits.pop

    sum = digits.reverse.each_slice(2).map do |x, y|
      [(x * 2).divmod(10), y || 0]
    end.flatten.inject(:+)

    (10 - sum % 10) == check
  end

  def valid_cc_number_format
    if cc_number =~ CREDIT_CARD_FORMAT
      true
    else
      errors << I18n.t("back.errors.credit_card.invalid_format")
      false
    end
  end

  def valid_cc_number_length
    if cc_number.length <= 20
      true
    else
      errors << I18n.t("back.errors.credit_card.invalid_length")
      false
    end
  end

  def valid_backing_amount?
    if valid_backing_amount_format
      true
    else
      errors << I18n.t("back.errors.backing_amount.invalid_format")
      false
    end
  end

  def valid_backing_amount_format
    backing_amount =~ BACKING_AMOUNT_FORMAT
  end

  def error_message
    "This back isn't valid. Please use the following format: "
  end

  def success_message
    "#{backer} backed project #{project.name} for $#{backing_amount}"
  end
end
