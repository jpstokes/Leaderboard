class LeaderboardController < ApplicationController

  def index
    name = leaderboard_params[:name]
    size = leaderboard_params[:size].try(:to_i)
    offset = leaderboard_params[:offset].try(:to_i)

    if name
      leaderboards = [Leaderboard.find_by_name(name)]
    else
      size = 10 if size.nil?
      size = size - offset if offset

      leaderboards = Leaderboard.all.limit(size)
    end

    if leaderboards.any? && (size.nil? || size <= 100)
      render json: leaderboards
    else
      render nothing: true, status: 404
    end
  end

  def create
    leaderboard = Leaderboard.find_or_create_by(name: leaderboard_params[:name])
    leaderboard.score = leaderboard_params[:score]
    leaderboard.save
    render nothing: true, status: 200
  end

  private

  def leaderboard_params
    params.permit [:name, :score, :size, :offset]
  end
end
