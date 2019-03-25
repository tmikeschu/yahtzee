require "yahtzee/response_parser"

module Yahtzee
  module Responder
    # only "ask" one question per status
    STATUSES = {
      not_started: [
        [:say, ->(_) { "Welcome to Yahtzee!" }],
        [:ask, ->(_) {{prompt: "Press enter to begin!", key: :start_game}}],
      ],
      roll_1: [
        [:say, ->(state) { "Roll 1: #{state.fetch(:current_hand)}" }],
        [:say, ->(state) { "Your hand: #{state.fetch(:held_dice)}" }],
        [:ask, ->(_) {{prompt: "Which ones do you want?", key: :roll_selection, parser: ResponseParser.digits}}],
      ],
      roll_2: [
        [:say, ->(state) { "Roll 2: #{state.fetch(:current_hand)}" }],
        [:say, ->(state) { "Your hand: #{state.fetch(:held_dice)}" }],
        [:ask, ->(_) {{prompt: "Which ones do you want?", key: :roll_selection, parser: ResponseParser.digits}}],
      ],
      roll_3: [
        [:say, ->(state) { "Roll 3: #{state.fetch(:current_hand)}" }],
        [:say, ->(state) { "Your hand: #{state.fetch(:held_dice)}" }],
        [:ask, ->(_) {{prompt: "Which ones do you want?", key: :roll_selection, parser: ResponseParser.digits}}],
      ],
      play_hand: [
        [:say, ->(state) { "Play your hand: #{state.fetch(:held_dice)}" }],
        [:say, ->(state) {
          state.fetch(:hands)
            .map { |(h, p)| "#{h}: #{p}" }.join("\n")
        },],
        [:ask, ->(_) {
          {
            prompt: "Which hand do you want to play",
            key: :select_hand,
          }
        },],
      ],
    }

    def self.respond(state)
      [state.fetch(:error)]
        .reject(&:nil?)
        .map { |error| [:say, error] }
        .concat(
          STATUSES.fetch(
            state.fetch(:status),
            [[:ask, ->(_) {{prompt: "Sorry, didn't catch that", key: :error_response}}]]
          ).map { |(type, response)| [type, response.call(state)] }
        )
    end
  end
end
