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

    xit "returns a valid game with a valid API key" do
      endpoint = "/api/v1/games/1/shots"
      payload = {target: "B1"}.to_json

      response = post_json(endpoint, payload)

      expect(response.status).to eq(200)

      validate_game_response(game_data: response.body, board_size: board_size)
      expect(response.body[:message]).to include("Your shot resulted in a")
    end

    xit "prevents a player from playing a game they are part of" do
    end

    xit "prevents a player from making two moves in a row" do
    end
  end
end
