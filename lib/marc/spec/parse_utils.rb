require 'parslet'

module MARC
  module Spec
    module ParseUtils
      MARC_MAX_OCTETS = 99_999

      class IntRange < Parslet::Atoms::Base
        INT_RANGE_RE = /^(0|[1-9][0-9]*)-(0|[1-9][0-9]*)/.freeze

        def try(source, context, _consume_all)
          source_str = source.instance_variable_get(:@str) # TODO: something less hacky
          return context.err(self, source, 'Not a non-negative integer range') unless (range_str = source_str.check(INT_RANGE_RE))

          s, e = range_str.match(INT_RANGE_RE)[1, 2]
          return context.err(self, source, "#{s} !<= #{e}") unless s.to_i <= e.to_i

          sv, _, ev = [s.size, 1, e.size].map { |l| source.consume(l) } # discard hyphen
          succ(start: sv, end: ev)
        end

        def to_s_inner(_prec)
          'IntRange'
        end
      end

    end
  end
end
