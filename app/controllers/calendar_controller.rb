class CalendarController < ApplicationController
  include SessionHelper
  include CalendarHelper

  skip_forgery_protection only: :change_callback

  def index
    @is_subscribed = subscription&.active?
    subscription.destroy! if subscription&.expired?

    current_time = Time.current
    @start_date = Date.parse(params[:from]).beginning_of_day rescue current_time.beginning_of_month
    @end_date = Date.parse(params[:to]).end_of_day rescue current_time.end_of_month
    @events = query_events(
      startdatetime: @start_date.iso8601,
      enddatetime: @end_date.iso8601,
    )
  end

  def subscribe
    response = subscribe_to_change_notification
    Subscription.create!(
      email: current_user.email,
      external_id: response['id'],
      expired_at: response['expirationDateTime'],
    )

    redirect_to calendar_index_path
  end

  def unsubscribe
    if subscription
      unsubscribe_from_change_notification(subscription.external_id) unless subscription.expired?
      subscription.destroy!
    end

    redirect_to calendar_index_path
  end

  def change_callback
    return render(plain: params[:validationToken]) if params[:validationToken]

    params[:value].each do |value|
      subs = Subscription.find_by(external_id: value[:subscriptionId])
      next unless subs

      subs.change_logs.create!(
        event_id: value[:resourceData][:id],
        change_type: value[:changeType],
      )
    end

    render plain: 'Success'
  end

  private

  def subscription
    @subscription ||= Subscription.find_by(email: current_user.email)
  end

  def query_events(queries = {})
    events = get_calendar_view(queries)
    recurring_event_ids = Set.new
    events.each do |item|
      next if item['type'] != 'occurrence'
      recurring_event_ids << item['seriesMasterId']
    end
    events += recurring_event_ids.map { |event_id| get_calendar_event(event_id) }
    events.sort_by { |event| DateTime.parse(event['start'].values.join(' ')).iso8601 }
  end
end
