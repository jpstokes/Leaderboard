require 'rails_helper'

RSpec.describe LeaderboardController, :type => :controller do

  describe '#index' do
    it 'return the score and rank of the user' do
      Leaderboard.create(name: 'John Doe', score: 20)
      get :index, name: 'John Doe'
      result = JSON.parse(response.body)
      expect(result['score']).to eq 20
    end

    it 'returns 404 if user is not found' do
      get :index, name: 'Jane Doe'
      expect(response.status).to eq 404
    end
  end
end
