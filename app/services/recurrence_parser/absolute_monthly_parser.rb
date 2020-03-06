module RecurrenceParser
  class AbsoluteMonthlyParser < BaseParser
    protected

    def calculate_rule
      append_rule('monthly', pattern[:interval])
      append_rule('day_of_month', pattern[:dayOfMonth])
    end
  end
end
