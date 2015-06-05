require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user) { User.new }

  subject { user }

  it { should respond_to :name }
  it { should respond_to :score }
  it { should respond_to :rank }
end
