module RecurrenceParser
  class AbsoluteYearlyParser < BaseParser
    protected

    def calculate_rule
      append_rule('yearly', pattern[:interval])
      append_rule('day_of_month', pattern[:dayOfMonth])
      append_rule('month_of_year', pattern[:month])
    end
  end
end
