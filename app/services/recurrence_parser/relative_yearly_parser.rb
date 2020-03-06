module RecurrenceParser
  class RelativeYearlyParser < BaseParser
    protected

    def calculate_rule
      append_rule('yearly', pattern[:interval])
      append_rule('day_of_week', days_of_week_with_index)
      append_rule('month_of_year', pattern[:month])
    end
  end
end
