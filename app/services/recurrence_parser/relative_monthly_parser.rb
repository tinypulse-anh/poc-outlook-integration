module RecurrenceParser
  class RelativeMonthlyParser < BaseParser
    protected

    def calculate_rule
      append_rule('monthly', pattern[:interval])
      append_rule('day_of_week', days_of_week_with_index)
    end
  end
end
