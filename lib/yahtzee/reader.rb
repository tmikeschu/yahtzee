require "yahtzee/utils"

module Yahtzee
  class Reader
    COLORIZERS = {
      error: :red,
      success: :green,
      default: :identity,
    }

    def self.say(message, type: :default)
      puts colorize(type, message)
    end

    def self.ask(prompt:, key:, parser: Utils.identity, type: :default)
      say(colorize(type, prompt))

      $stdin.gets.chomp.downcase.then { |message|
        {
          key: key,
          message: message,
          parsed: parser.call(message),
        }
      }
    end

    private_class_method

    def self.colorize(type, message)
      Utils.send(COLORIZERS.fetch(type)).call(message)
    end
  end
end
