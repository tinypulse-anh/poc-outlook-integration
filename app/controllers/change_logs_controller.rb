class ChangeLogsController < ApplicationController
  def index
    @change_logs = ChangeLog.order(created_at: :desc)
  end
end
