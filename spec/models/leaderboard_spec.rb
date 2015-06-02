require 'rails_helper'

RSpec.describe Leaderboard, :type => :model do

  let(:leaderboard) { Leaderboard.new }

  subject { leaderboard }

  it { should respond_to :name }
  it { should respond_to :score }
  it { should respond_to :rank }
end
