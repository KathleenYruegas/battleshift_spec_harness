module HTTPHelpers
  def base_url
    ENV["BATTLESHIFT_BASE_URL"] || "http://localhost:3000"
  end

  def conn
    Faraday.new(base_url) do |faraday|
      faraday.headers["X-API-Key"] = ENV["API_KEY"]
      faraday.adapter  Faraday.default_adapter
    end
  end

  def get_json(endpoint)
    request = conn.get(endpoint)
    parse_json(request.body)
  end

  def parse_json(json)
    JSON.parse(json, symbolize_names: true)
  end
end
