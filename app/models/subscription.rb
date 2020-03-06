class Subscription < ApplicationRecord
  has_many :change_logs, dependent: :destroy

  def expired?
    Time.current > expired_at
  end

  def active?
    !expired?
  end
end
