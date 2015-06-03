class LeaderboardController < ApplicationController

  def index
    name = leaderboard_params[:name]
    size = leaderboard_params[:size].try(:to_i) || 10
    offset = leaderboard_params[:offset].try(:to_i) || 0

    if name
      leaderboards = [Leaderboard.find_by_name(name)].compact
    else
      leaderboards = Leaderboard.all.offset(offset).limit(size).order(rank: :asc)
    end

    if size > 100 || offset > Leaderboard.count - 1
      render nothing: true, status: 404
    else
      render json: leaderboards
    end
  end

  def create
    leaderboard = Leaderboard.find_or_create_by(name: leaderboard_params[:name])
    leaderboard.score = leaderboard_params[:score]
    leaderboard.save
    render nothing: true, status: 200
  end

  def destroy
    leaderboard = Leaderboard.where(name: leaderboard_params[:name]).first
    if leaderboard && leaderboard.destroy
      render nothing: true, status: 200
    else
      render nothing: true, status: 404
    end
  end

  private

  def leaderboard_params
    params.permit [:name, :score, :size, :offset]
  end
end
