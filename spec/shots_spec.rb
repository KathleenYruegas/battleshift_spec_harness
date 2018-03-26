require 'spec_helper'

describe "Game Shots" do
  context "POST /api/v1/games/1/shots" do
    xit "protects against invalid API keys" do
      endpoint = "/api/v1/games/1/shots"
      payload = {target: "B1"}.to_json

      response = post_json(endpoint, payload, "NotARealAPIKey")
      expect(response.status).to eq(401)
      expect(response.body[:message]).to eq("Unauthorized")
    end

    xit "prevents a player from playing a game they are part of" do
      # Write tests within your app to accomplish this
    end
  end
end
