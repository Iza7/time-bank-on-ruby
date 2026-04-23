module ApplicationHelper
  STATUS_BADGE = {
    "pending"   => "warning",
    "accepted"  => "primary",
    "completed" => "success",
    "rejected"  => "danger",
    "cancelled" => "secondary"
  }.freeze

  def status_badge_class(status)
    STATUS_BADGE.fetch(status, "secondary")
  end
end
