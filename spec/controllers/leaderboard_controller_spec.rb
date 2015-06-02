require 'rails_helper'

RSpec.describe LeaderboardController, :type => :controller do

  describe '#index' do
    it 'return the score and rank of the user' do
      Leaderboard.create(name: 'John Doe', score: 20, rank: 1)
      get :index, name: 'John Doe'
      result = JSON.parse(response.body)
      expect(result[0]['score']).to eq 20
      expect(result[0]['rank']).to eq 1
    end

    it 'returns 404 if user is not found' do
      get :index, name: 'Jane Doe'
      expect(response.status).to eq 404
    end

    it 'returns the default number of records (10)' do
      (1..11).each { |i| Leaderboard.create(name: "Foo#{i}", score: i) }
      get :index
      result = JSON.parse(response.body)
      expect(result.count).to eq 10
    end

    it 'returns 5 records as specified' do
      (1..11).each { |i| Leaderboard.create(name: "Foo#{i}", score: i) }
      get :index, size: 5
      result = JSON.parse(response.body)
      expect(result.count).to eq 5
    end

    it 'returns default size with an offset of 1 records as specified' do
      (1..11).each { |i| Leaderboard.create(name: "Foo#{i}", score: i) }
      get :index, offset: 1
      result = JSON.parse(response.body)
      expect(result.count).to eq 9
    end

    it 'returns 404 when size greater than 100' do
      (1..101).each { |i| Leaderboard.create(name: "Foo#{i}", score: i) }
      get :index, size: 101
      expect(response.status).to eq 404
    end

    it 'returns items in order' do
    end

    it 'returns 404 when offset is greater or equal to size' do
      (1..101).each { |i| Leaderboard.create(name: "Foo#{i}", score: i) }
      get :index, size: 12, offset: 13
      expect(response.status).to eq 404
    end
  end

  describe '#create' do
    it 'will record the score of the named entity' do
      expect(Leaderboard.count).to eq 0
      post :create, { name: 'John Doe', score: 20 }
      expect(Leaderboard.count).to eq 1
      expect(Leaderboard.first.name).to eq 'John Doe'
      expect(Leaderboard.first.score).to eq 20
      expect(response.status).to eq 200
    end

    it 'will update the named entity if the user already exists' do
      Leaderboard.create(name: 'Janice Doe', score: 20)
      expect(Leaderboard.count).to eq 1
      post :create, { name: 'Janice Doe', score: 25 }
      expect(Leaderboard.count).to eq 1
      expect(Leaderboard.first.name).to eq 'Janice Doe'
      expect(Leaderboard.first.score).to eq 25
      expect(response.status).to eq 200
    end
  end

  describe '#destroy' do
    it 'removes item from system' do
      Leaderboard.create(name: 'Janice Doe', score: 20)
      expect(Leaderboard.count).to eq 1
      post :destroy, name: 'Janice Doe'
      expect(Leaderboard.count).to eq 0
      expect(response.status).to eq 200
    end

    it 'returns a 404 when not found' do
      post :destroy, name: 'John Doe'
      expect(Leaderboard.count).to eq 0
      expect(response.status).to eq 404
    end
  end
end
