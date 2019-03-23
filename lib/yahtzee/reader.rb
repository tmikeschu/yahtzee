module Yahtzee
  class Reader
    def self.say(message)
      puts message
    end

    def self.ask(prompt:, key:)
      say(prompt)

      {key: key, message: $stdin.gets.chomp.downcase}
    end
  end
end
