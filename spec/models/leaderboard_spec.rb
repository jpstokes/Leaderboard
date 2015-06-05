require 'rails_helper'

RSpec.describe Leaderboard, :type => :model do

  let(:user) { User.new }

  subject { user }

  before { Redis.current.flushdb }

  describe '#get_score' do
    it 'sets the score properly' do
      user = User.create(name: 'John Doe')
      user.score = 21
      expect(Leaderboard.get_score(user.id).to_i).to eq 21
    end
  end

  describe '#get_member_rank' do
    it 'returns rank of 1 for user' do
      user = User.create(name: 'John Doe')
      user.score = 20
      expect(Leaderboard.get_member_rank(user.id)).to eq 1
    end
  end

  describe '#remove_member' do
    it 'removes the user' do
      user = User.create(name: 'John Doe')
      user.score = 21
      Leaderboard.remove_member(user.id)
      expect(user.score).to eq nil
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
      expect(Leaderboard.get_range(0, 2).count).to eq 6
    end
  end
end
