module Yahtzee
  module Utils
    class << self
      def remove(xs, ys)
        ys.reduce(frequencies(xs)) { |acc, el|
          acc.merge(el => acc.fetch(el, 0) - 1)
        }.reduce([]) { |acc, (k, v)|
          [0, v]
            .max
            .then { |count| acc + Array.new(count) { k } }
        }
      end

      def frequencies(xs)
        xs.reduce({}) { |acc, el|
          acc.merge(el => acc.fetch(el, 0) + 1)
        }
      end
    end
  end
end
