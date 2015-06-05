require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user) { User.new }

  subject { user }

  it { should respond_to :name }
  it { should respond_to :score }
  it { should respond_to :rank }

  describe '#rank_users' do
    it 'returns rank of 2 for user' do
      User.create(name: 'John Doe', score: 20)
      User.create(name: 'Jane Doe', score: 20)
      User.create(name: 'Bob Doe', score: 22)
      User.create(name: 'Joe Doe', score: 21)
      User.rank_users

      expect(User.where(name: 'Joe Doe').first.rank).to eq 2
    end

    it 'returns the rank of 1 for user' do
      User.create(name: 'John Doe', score: 20)
      User.create(name: 'Jane Doe', score: 20)
      User.create(name: 'Bob Doe', score: 22)
      User.create(name: 'Joe Doe', score: 21)
      User.rank_users

      expect(User.where(name: 'Bob Doe').first.rank).to eq 1
    end

    it 'returns the rank of 3 for users' do
      User.create(name: 'John Doe', score: 20)
      User.create(name: 'Jane Doe', score: 20)
      User.create(name: 'Bob Doe', score: 22)
      User.create(name: 'Joe Doe', score: 21)
      User.rank_users

      expect(User.where(name: 'John Doe').first.rank).to eq 3
      expect(User.where(name: 'Jane Doe').first.rank).to eq 3
    end
  end
end
