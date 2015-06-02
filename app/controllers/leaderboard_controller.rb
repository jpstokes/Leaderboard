class LeaderboardController < ApplicationController
  def index
    leaderboard = Leaderboard.find_by_name(params[:name])
    if leaderboard
      render json: leaderboard
    else
      render nothing: true, status: 404
    end
  end

  private

  def leaderboard_params
    params.require(:leaderbaord).permit [:name, :score]
  end
end
