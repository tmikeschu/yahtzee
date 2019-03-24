module Yahtzee
  class Reader
    def self.say(message)
      puts message
    end

    def self.ask(prompt:, key:, parser: ->(x) { x })
      say(prompt)
      message = $stdin.gets.chomp.downcase
      {key: key, message: message, parsed: parser.call(message)}
    end
  end
end
