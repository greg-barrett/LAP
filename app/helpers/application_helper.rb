module ApplicationHelper
  def is_admin?(reserver)
    reserver.admin
  end
end
