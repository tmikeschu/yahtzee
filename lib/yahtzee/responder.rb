require "yahtzee/response_parser"
require "yahtzee/utils"

module Yahtzee
  module Responder
    MAKE_SELECTION = {
      prompt: "Which ones do you want?",
      key: :select_dice,
      parser: ResponseParser.digits,
    }
    GET_STATE = ->(prop, state) { state.fetch(prop) }.curry
    GET_CURRENT_HAND = GET_STATE.call(:current_hand)
    GET_HELD_DICE = GET_STATE.call(:held_dice)
    ROLL = ->(num, hand) { "Roll #{num}: #{hand}"}.curry
    YOUR_HAND = ->(dice) { "Your hand: #{dice}" }

    # only "ask" one question per status
    STATUSES = {
      not_started: [
        [:say, ->(_) { "Welcome to Yahtzee!" }],
        [:ask, ->(_) {{prompt: "Press enter to begin!", key: :start_game}}],
      ],
      roll_1: [
        [:say, GET_CURRENT_HAND >> ROLL.call(1)],
        [:say, GET_HELD_DICE >> YOUR_HAND],
        [:ask, ->(_) {MAKE_SELECTION}],
      ],
      roll_2: [
        [:say, GET_CURRENT_HAND >> ROLL.call(2)],
        [:say, GET_HELD_DICE >> YOUR_HAND],
        [:ask, ->(_) {MAKE_SELECTION}],
      ],
      roll_3: [
        [:say, GET_CURRENT_HAND >> ROLL.call(3)],
        [:say, GET_HELD_DICE >> YOUR_HAND],
        [:ask, ->(_) {MAKE_SELECTION}],
      ],
      play_hand: [
        [:say, GET_HELD_DICE >> ->(dice) { "Play your hand: #{dice}" }],
        [:say, GET_CURRENT_HAND >> ->(hand) { "Roll: #{hand}" }],
        [:say, ->(state) {
          state.fetch(:hands)
            .map { |(h, p)| p ? Utils.green.call("#{h}: #{p}") : "#{h}: _" }.join("\n")
        },],
        [:ask, ->(_) {
          {
            prompt: "Which hand do you want to play?",
            key: :select_hand,
          }
        },],
      ],
    }

    def self.respond(state)
      [state.fetch(:error)]
        .reject(&:nil?)
        .map { |error| [:say, error, type: :error] }
        .concat(
          STATUSES.fetch(
            state.fetch(:status),
            [[:ask, ->(_) {{prompt: "Sorry, didn't catch that", key: :error_response}}]]
          ).map { |(type, response)| [type, response.call(state)] }
        )
    end
  end
end
