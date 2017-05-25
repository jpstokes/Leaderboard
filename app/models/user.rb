class User < ActiveRecord::Base

  validates :name, presence: true

  def score=(score)
    Leaderboard.add_member(id, score)
  end

  def remove_user
    Leaderboard.remove_member(id)
  end

  def rank
    Leaderboard.get_member_rank(id).to_i
  end

  def self.score_and_rank(name)
    user = User.where('lower(name) = ?', name.downcase).first
    return unless user
    rank = Leaderboard.get_member_rank(user.id).try(:to_i)
    score = Leaderboard.get_score(user.id).try(:to_i)
    return unless rank && score
    { rank: rank, score: score }
  end

  def self.get_range(start, stop)
    user_score_array = Leaderboard.get_range(start, stop)
    Hash[*user_score_array].map do |key, value|
      user = User.find(key).slice(:name)
      user['score'] = value
      user['rank'] = Leaderboard.get_member_rank(key).to_i
      user
    end.to_json
  end
end
