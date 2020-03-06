module RecurrenceParser
  class DailyParser < BaseParser
    protected

    def calculate_rule
      append_rule('daily', pattern[:interval])
    end
  end
end
