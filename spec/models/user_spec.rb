require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user) { User.new }

  subject { user }

  it { should respond_to :name }

  before { Redis.current.flushdb }

  describe '#rank_users' do
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
end
