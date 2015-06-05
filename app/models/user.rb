class User < ActiveRecord::Base

  def set_score(score)
    Leadboard.add_member(id, score)
  end

  def remove_user
    Leaderboard.remove_member(id)
  end

  def self.score_and_rank(name)
    user = User.where(name: name).first
    if user
      rank = Leaderboard.get_member_rank(user.id).to_i
      score = Leaderboard.get_score(user.id).to_i
      return { 'rank': rank, 'score': score }
    end
  end

end
