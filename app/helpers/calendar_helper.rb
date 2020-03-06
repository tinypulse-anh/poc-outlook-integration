module CalendarHelper
  GRAPH_HOST = 'https://graph.microsoft.com'.freeze

  def call_graph_api(http_method, endpoint, params = {})
    options = {
      headers: {
        Authorization: "Bearer #{access_token}",
        'Content-Type': 'application/json',
      },
    }
    if http_method == :get
      options[:query] = params
    else
      options[:body] = params.to_json
    end

    HTTParty.send(http_method, "#{GRAPH_HOST}#{endpoint}", options)
  end

  %i[get post delete].each do |http_method|
    define_method "graph_api_#{http_method}" do |endpoint, params = {}|
      call_graph_api(http_method, endpoint, params)
    end
  end

  def get_calendar_event(event_id)
    response = graph_api_get("/v1.0/me/events/#{event_id}")
    return response.parsed_response if response.code == 200
    raise response.parsed_response.to_s || "Request returned #{response.code}"
  end

  def get_calendar_view(params = {})
    response = graph_api_get(
      '/v1.0/me/calendar/calendarView',
      params.merge('$orderby': 'createdDateTime DESC')
    )
    return response.parsed_response['value'] if response.code == 200
    raise response.parsed_response.to_s || "Request returned #{response.code}"
  end

  def subscribe_to_change_notification
    response = graph_api_post(
      '/v1.0/subscriptions',
      changeType: 'created,updated,deleted',
      notificationUrl: "#{ENV['CHANGE_NOTIFICATION_ENDPOINT']}/calendar/change_callback",
      resource: '/me/events',
      expirationDateTime: 4230.minutes.from_now.iso8601,
    )
    return response.parsed_response if (200..299) === response.code
    raise response.parsed_response.to_s || "Request returned #{response.code}"
  end

  def unsubscribe_from_change_notification(subscription_id)
    graph_api_delete("/v1.0/subscriptions/#{subscription_id}")
  end

  def parse_recurrence(hash)
    return unless hash

    hash.deep_symbolize_keys!
    pattern = hash[:pattern]
    range = hash[:range]

    "RecurrenceParser::#{pattern[:type].classify}Parser".constantize
      .new(pattern, range).to_ical
  end
end
