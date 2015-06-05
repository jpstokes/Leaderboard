class Leaderboard
  def self.add_member(user_id, score)
    Redis.current.zadd("leaderboard", score, user_id)
  end

  def self.get_member_rank(user_id)
    Redis.current.zrevrank("leaderboard", user_id) + 1
  end

  def self.get_score(user_id)
    Redis.current.zscore("leaderboard", user_id)
  end

  def self.remove_member(user_id)
    Redis.current.zrem("leaderboard", user_id)
  end

  def self.get_range(start, stop)
    Redis.current.zrange("leaderboard", start, stop)
  end
end
