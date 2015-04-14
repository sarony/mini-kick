require_relative "list"
require_relative "back"
require_relative "backer"
require_relative "project"
require_relative "parse_input"
require "i18n"
require "yaml"

I18n.config.enforce_available_locales = false
I18n.load_path = Dir['*.yml']
I18n.backend.load_translations
YAML.load_file("en.yml")

class MiniKick
  def run
    welcome_message
    call
  end

  def call
    print ">> "
    input = gets.strip
    ParseInput.new(input)
  end

  def welcome_message
    print "Welcome to MiniKick! You can start a project, back a project, check out what projects backers have backed, and more!\n"
  end
end

MiniKick.new.run
