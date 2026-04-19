module ApplicationHelper
  def map_tile_url
    ENV.fetch("MAP_TILE_URL", "https://tile.openstreetmap.org/{z}/{x}/{y}.png")
  end

  def map_attribution
    ENV.fetch("MAP_ATTRIBUTION", '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors')
  end

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
