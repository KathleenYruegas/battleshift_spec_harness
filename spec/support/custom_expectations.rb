module CustomExpectations
  def validate_game_response(game_data:, board_size:)
    expect(game_data[:id]).to eq(1)
    expect(game_data[:current_turn]).to be_a String
    expect(game_data[:player_1_board][:rows].count).to eq(board_size)
    expect(game_data[:player_2_board][:rows].count).to eq(board_size)
    expect(game_data[:player_1_board][:rows][0][:name]).to eq("row_a")
    expect(game_data[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
    expect(game_data[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
    expect(game_data[:player_1_board][:rows][3][:data][0][:status]).to be_a String
  end
end
