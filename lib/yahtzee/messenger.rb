module Yahtzee
  module Messenger
    KEYWORDS = {
      "exit" => {message: :exit},
      "restart" => {message: :restart},
    }

    def self.interpret(status, payload)
      KEYWORDS.fetch(
        payload.fetch(:message),
        make_message(status, payload)
      )
    end

    private_class_method

    def self.make_message(status, payload)
      case status
      when :not_started
        {message: :start_game, payload: payload}
      else
        {message: :noop}
      end
    end
  end
end
