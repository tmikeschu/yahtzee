require "yahtzee/reader"
require "yahtzee/store"
require "yahtzee/responder"
require "yahtzee/messenger"

module Yahtzee
  class Game
    def self.start
      new.start
    end

    attr_reader :store
    def initialize
      @store = Store.new
    end

    def start
      while store.get_state(:status) != :game_over
        Responder.respond(store.get_state)
          .map { |response| Reader.send(*response) }
          .reject(&:nil?)
          .reduce({}) { |acc, el| el.merge(acc) }
          .then { |payload| Messenger.interpret(store.get_state(:status), payload) }
          .then { |message| store.dispatch(message) }
      end

      finish
    end

    def finish
      puts "Thanks for playing!"
    end
  end
end
