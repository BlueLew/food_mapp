module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice
      "border-emerald-200 bg-emerald-50 text-emerald-900"
    when :alert
      "border-rose-200 bg-rose-50 text-rose-900"
    else
      "border-stone-200 bg-white text-stone-900"
    end
  end
end
