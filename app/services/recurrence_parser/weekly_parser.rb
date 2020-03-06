module RecurrenceParser
  class WeeklyParser < BaseParser
    protected

    def calculate_rule
      append_rule('weekly', pattern[:interval], pattern[:firstDayOfWeek].to_sym)
      append_rule('day', pattern[:daysOfWeek].map(&:to_sym))
    end
  end
end
