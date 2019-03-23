module Yahtzee
  module Responder
    # only "ask" one question per status
    STATUSES = {
      not_started: [
        [:say, ->(_) { "Welcome to Yahtzee!" }],
        [:ask, ->(_) {{prompt: "Press enter to begin!", key: :enter_start}}],
      ],
      roll_1: [
        [:say, ->(state) { "Roll 1: #{state.fetch(:hands)}}" }],
        [:ask, ->(_) {{prompt: "Which ones do you want?", key: :roll_selection}}],
      ],
    }

    def self.respond(state)
      STATUSES.fetch(
        state.fetch(:status),
        [[:ask, ->(_) {{prompt: "Sorry, didn't catch that", key: :error_response}}]]
      ).map { |(type, response)| [type, response.call(state)] }
    end
  end
end
