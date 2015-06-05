require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user) { User.new }

  subject { user }

  it { should respond_to :name }

  before { Redis.current.flushdb }

  describe '#score' do
    it 'sets the score properly' do
      user = User.create(name: 'John Doe')
      user.score = 21
      expect(Leaderboard.get_score(user.id).to_i).to eq 21
    end
  end

  describe '#remove_user' do
    it 'removes the user' do
      user = User.create(name: 'John Doe')
      user.score = 21
      user.remove_user
      expect(user.score).to eq nil
    end
  end

  describe '#rank' do
    before do
      user = User.create(name: 'John Doe')
      user.score = 20
      user = User.create(name: 'Jane Doe')
      user.score = 20
      user = User.create(name: 'Bob Doe')
      user.score = 22
      user = User.create(name: 'Joe Doe')
      user.score = 21
    end

    it 'returns rank of 2 for user' do
      expect(User.where(name: 'Joe Doe').first.rank).to eq 2
    end

    it 'returns the rank of 1 for user' do
      expect(User.where(name: 'Bob Doe').first.rank).to eq 1
    end

    it 'returns the rank of 3 for users' do
      expect(User.where(name: 'John Doe').first.rank).to eq 4
      expect(User.where(name: 'Jane Doe').first.rank).to eq 3
    end
  end

  describe '#score_and_rank' do
    it 'returns rank and score' do
      user = User.create(name: 'John Doe')
      user.score = 21
      expect(User.score_and_rank(user.name)).to eq({ rank: 1, score: 21 })
    end
  end

  describe '#get_range' do
    before do
      user = User.create(name: 'John Doe')
      user.score = 20
      user = User.create(name: 'Jane Doe')
      user.score = 20
      user = User.create(name: 'Bob Doe')
      user.score = 22
      user = User.create(name: 'Joe Doe')
      user.score = 21
    end

    it 'returns all user in the given range' do
      expect(User.get_range(0, 2))
        .to eq "[{\"name\":\"Bob Doe\",\"score\":\"22\",\"rank\":1},{\"name\":\"Joe Doe\",\"score\":\"21\",\"rank\":2},{\"name\":\"Jane Doe\",\"score\":\"20\",\"rank\":3}]"
    end
  end
end
