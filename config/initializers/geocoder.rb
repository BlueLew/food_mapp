user_agent = ENV["GEOCODER_USER_AGENT"].to_s.presence

Geocoder.configure(
  lookup: :nominatim,
  timeout: 5,
  http_headers: user_agent.present? ? { "User-Agent" => user_agent } : {}
)
