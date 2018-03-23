require 'spec_helper'

describe "Games endpoints" do
  context "GET /api/v1/games/1" do
    it "returns valid game data" do
      endpoint = "/api/v1/games/1"
      response = get_json(endpoint)
      expect(response[:id]).to eq 1
    end
  end
end

