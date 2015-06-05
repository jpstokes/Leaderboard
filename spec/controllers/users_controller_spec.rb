require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  before { Redis.current.flushdb }

  describe '#index' do
    it 'return the score and rank of the user' do
      user = User.create(name: 'John Doe')
      Leaderboard.add_member(user.id, 20)
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
      create_users 11
      get :index
      result = JSON.parse(response.body)
      expect(result.count).to eq 10
    end

    it 'returns 5 records as specified' do
      create_users 11
      get :index, size: 5
      result = JSON.parse(response.body)
      expect(result.count).to eq 5
    end

    it 'returns default size with an offset of 1 records as specified' do
      create_users 11
      get :index, offset: 1
      result = JSON.parse(response.body)
      expect(result.count).to eq 10
      expect(result[0]['rank']).to eq 2
      expect(result[9]['rank']).to eq 11
    end

    it 'returns 404 when size greater than 100' do
      create_users 101
      get :index, size: 101
      expect(response.status).to eq 404
    end

    it 'returns 404 when offset out of range' do
      create_users 50
      get :index, offset: 50
      expect(response.status).to eq 404
    end
  end

  describe '#create' do
    it 'will record the score of the named entity' do
      expect(User.count).to eq 0
      post :create, { name: 'John Doe', score: 20 }
      expect(User.count).to eq 1
      expect(User.first.name).to eq 'John Doe'
      expect(Leaderboard.get_score(User.first.id).to_i).to eq 20
      expect(response.status).to eq 200
    end

    it 'will update the named entity if the user already exists' do
      User.create(name: 'Janice Doe', score: 20)
      expect(User.count).to eq 1
      post :create, { name: 'Janice Doe', score: 25 }
      expect(User.count).to eq 1
      expect(User.first.name).to eq 'Janice Doe'
      expect(Leaderboard.get_score(User.first.id).to_i).to eq 25
      expect(response.status).to eq 200
    end
  end

  describe '#destroy' do
    it 'removes item from system' do
      User.create(name: 'Janice Doe', score: 20)
      expect(User.count).to eq 1
      post :destroy, name: 'Janice Doe'
      expect(User.count).to eq 0
      expect(response.status).to eq 200
    end

    it 'returns a 404 when not found' do
      post :destroy, name: 'John Doe'
      expect(User.count).to eq 0
      expect(response.status).to eq 404
    end
  end

  def create_users(num)
    (1..num).each do |i|
      user = User.create(name: "Foo#{i}")
      user.score = i
    end
  end
end
