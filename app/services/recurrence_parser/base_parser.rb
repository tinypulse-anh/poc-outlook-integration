module RecurrenceParser
  class BaseParser
    ORDINAL_VALUE = {
      'first' => 1,
      'second' => 2,
      'third' => 3,
      'fourth' => 4,
      'last' => -1,
    }.freeze

    attr_reader :pattern, :range, :rule

    def initialize(pattern, range)
      @pattern = pattern
      @range = range
      @rule = IceCube::Rule
    end

    def to_ical
      return @ical if @ical

      calculate_rule if @rule.is_a?(Class)
      @ical = @rule.to_ical
    end

    protected

    def append_rule(option, *params)
      @rule = rule.send(option, *params)
    end

    def week_index
      @week_index ||= ORDINAL_VALUE[pattern[:index]]
    end

    def days_of_week_with_index
      @days_of_week_with_index||= pattern[:daysOfWeek].map(&:to_sym).product([[week_index]]).to_h
    end

    def calculate_rule
      raise NotImplementedError
    end
  end
end
