module Yahtzee
  module Utils
    class << self
      def identity(x = nil)
        if x.nil?
          ->(y) { y }
        else
          x
        end
      end

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

      def colorize
        ->(color_code, text) { "#{color_code}#{text}\e[0m" }.curry
      end

      def red
        colorize.call("\e[31m")
      end

      def green
        colorize.call("\e[32m")
      end
    end
  end
end
