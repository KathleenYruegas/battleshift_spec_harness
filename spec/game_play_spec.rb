require 'spec_helper'

describe "Game creation and sequence" do
  let(:board_size) { 4 }

  it "can create and play a game" do
    # Create the game
    response = create_game
    game_id = response.body[:id]

    # Place the first ship
    ship_1_payload = {
      ship_size: 3,
      start_space: "A1",
      end_space: "A3"
    }.to_json

    response = post_json("/api/v1/games/#{game_id}/ships", ship_1_payload)

    expect(response.status).to eq(200)

    validate_game_response(game_data: response.body, board_size: board_size)
    expect(response.body[:message]).to include("Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.")

    # Place the second ship
    ship_2_payload = {
      ship_size: 2,
      start_space: "B1",
      end_space: "C1"
    }.to_json

    response = post_json("/api/v1/games/#{game_id}/ships", ship_2_payload)

    expect(response.status).to eq(200)

    validate_game_response(game_data: response.body, board_size: board_size)
    expect(response.body[:message]).to include("Successfully placed ship with a size of 2. You have 0 ship(s) to place.")

    # Place the opponent's ships
    post_json("/api/v1/games/#{game_id}/ships", ship_1_payload, opponent_key)
    post_json("/api/v1/games/#{game_id}/ships", ship_2_payload, opponent_key)

    # Player 1 fires first HIT on ship 1
    endpoint = "/api/v1/games/#{game_id}/shots"
    payload = {target: "A1"}.to_json

    response = post_json(endpoint, payload)
    game = response.body

    expect(response.status).to eq(200)
    validate_game_response(game_data: game, board_size: 4)
    expect(game[:message]).to include("Your shot resulted in a Hit")
    status_space = game[:player_2_board][:rows].first[:data].first[:status]
    expect(status_space).to eq("Hit")
    expect(game[:winner]).to be_nil

    # Player 2 fires a MISS
    payload = {target: "D1"}.to_json

    response = post_json(endpoint, payload, opponent_key)
    game = response.body
    expect(response.status).to eq(200)
    validate_game_response(game_data: game, board_size: 4)
    expect(game[:message]).to include("Your shot resulted in a Miss")
    status_space = game[:player_1_board][:rows][3][:data].first[:status]
    expect(status_space).to eq("Miss")

    # Player 2 attempts to fire again but it isn't their turn
    payload = {target: "D2"}.to_json

    response = post_json(endpoint, payload, opponent_key)
    game = response.body
    expect(response.status).to eq(400)
    validate_game_response(game_data: game, board_size: 4)
    expect(game[:message]).to include("Invalid move. It's your opponent's turn")

    # Player 1 fires second HIT on ship 1
    payload = {target: "A2"}.to_json

    response = post_json(endpoint, payload)
    game = response.body

    expect(response.status).to eq(200)
    expect(game[:message]).to include("Your shot resulted in a Hit")

    # Player 2 fires on an invalid space
    payload = {target: "D5"}.to_json

    response = post_json(endpoint, payload, opponent_key)
    game = response.body
    expect(response.status).to eq(400)
    validate_game_response(game_data: game, board_size: 4)
    expect(game[:message]).to include("Invalid coordinates")

    # Player 1 attempts to fire a shot but receives an error message
    payload = {target: "A3"}.to_json

    response = post_json(endpoint, payload)
    game = response.body
    expect(response.status).to eq(400)
    validate_game_response(game_data: game, board_size: 4)
    expect(game[:message]).to include("Invalid move. It's your opponent's turn")

    # Player 2 fires a HIT on ship 2
    payload = {target: "B1"}.to_json

    response = post_json(endpoint, payload, opponent_key)
    game = response.body
    expect(game[:message]).to include("Your shot resulted in a Hit")

    # Player 1 fires a HIT on ship 1 and sinks it
    payload = {target: "A3"}.to_json

    response = post_json(endpoint, payload)
    game = response.body
    expect(game[:message]).to include("Your shot resulted in a Hit. Battleship sunk.")

    # Player 2 fires a HIT on ship 2 and sinks it
    payload = {target: "C1"}.to_json

    response = post_json(endpoint, payload, opponent_key)
    game = response.body
    expect(game[:message]).to include("Your shot resulted in a Hit. Battleship sunk.")

    # Player 1 fires a HIT on ship 2
    payload = {target: "B1"}.to_json

    response = post_json(endpoint, payload)
    game = response.body
    expect(game[:message]).to include("Your shot resulted in a Hit")

    # Player 2 fires a HIT on ship 1
    payload = {target: "A1"}.to_json

    response = post_json(endpoint, payload, opponent_key)
    game = response.body
    expect(game[:message]).to include("Your shot resulted in a Hit")

    # Player 1 fires a HIT on ship 2 and sinks it. Game ends.
    payload = {target: "C1"}.to_json

    response = post_json(endpoint, payload)
    game = response.body
    expect(game[:message]).to include("Your shot resulted in a Hit. Battleship sunk. Game over.")
    expect(game[:winner]).to eq(ENV["BATTLESHIFT_EMAIL"])

    # Player 2 attempts to fire on ship 1 but is notified the game is over
    payload = {target: "A1"}.to_json

    response = post_json(endpoint, payload, opponent_key)
    game = response.body
    expect(response.status).to eq(400)
    expect(game[:message]).to include("Invalid move. Game over.")
    expect(game[:winner]).to eq(ENV["BATTLESHIFT_EMAIL"])
  end
end
