module DatetimeHelper
  def format_datetime(str)
    DateTime.parse(str).strftime('%D %T %Z')
  end

  def format_datetime_hash(hash)
    format_datetime(hash.values.join(' '))
  end
end
