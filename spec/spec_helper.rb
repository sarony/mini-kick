require "rspec"
require "pry"
require "i18n"
Dir["#{Dir.pwd}/lib/*.rb"].each {|file| require file}

YAML.load_file("en.yml")
I18n.config.enforce_available_locales = false
