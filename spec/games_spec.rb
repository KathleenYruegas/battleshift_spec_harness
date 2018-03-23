require 'spec_helper'

describe "Games endpoints" do
  let(:board_size) { 4 }

  context "GET /api/v1/games/1" do
    it "returns valid game data" do
      endpoint = "/api/v1/games/1"
      response = get_json(endpoint)

      validate_game_response(game_data: response.body, board_size: board_size)
    end
  end

  context "POST /api/v1/games" do
    xit "creates a game with valid credentials and defaults to a 4x4 grid" do
      endpoint = "/api/v1/games"
      payload = {opponent_email: "josh@turing.io"}.to_json

      response = post_json(endpoint, payload)

      expect(response.status).to eq(200)
      expect(response.body[:message]).to include("Game was successfully created.")

      # Your test suite should test that the response includes the
      # email address associated with the game creator
      expect(response.body[:current_turn]).to_not include("josh@turing.io")

      validate_game_response(game_data: response.body, board_size: board_size)
    end

    xit "does not create a game with invalid credentials" do
      endpoint = "/api/v1/games"
      payload = {opponent_email: "josh@turing.io"}.to_json

      response = post_json(endpoint, payload, "NotARealAPIKey")

      expect(response.status).to eq(401)
      expect(response.body[:message]).to eq("Unauthorized")
    end
  end
end

