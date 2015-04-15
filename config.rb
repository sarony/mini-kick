require "./lib/list"
require "./lib/back"
require "./lib/backer"
require "./lib/project"
require "./lib/parse_input"
require "./lib/minikick.rb"

require "yaml"
require "i18n"

YAML.load_file("en.yml")
I18n.config.enforce_available_locales = false
I18n.load_path = Dir['*.yml']
I18n.backend.load_translations
