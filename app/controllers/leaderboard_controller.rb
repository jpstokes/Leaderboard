class LeaderboardController < ApplicationController

  def index
    leaderboard = Leaderboard.find_by_name(params[:name])
    if leaderboard
      render json: leaderboard
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
    params.permit [:name, :score]
  end
end
