module ApplicationHelper
  def likes_unit(total)
    total == 1 ? "like" : "likes"
  end
end
