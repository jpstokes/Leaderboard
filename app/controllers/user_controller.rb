class UserController < ApplicationController

  def index
    name = user_params[:name]
    size = user_params[:size].try(:to_i) || 10
    offset = user_params[:offset].try(:to_i) || 0
    users =
      if name
        [User.score_and_rank(name)]
      else
        User.get_range(offset, offset + size - 1)
      end

    if size > 100 || offset > User.count - 1
      render nothing: true, status: 404
    else
      render json: users
    end
  end

  def create
    user = User.find_or_create_by(name: user_params[:name])
    user.score =  user_params[:score]
    render nothing: true, status: 200
  end

  def destroy
    user = User.where(name: user_params[:name]).first
    if user
      user.remove_user
      user.destroy
      render nothing: true, status: 200
    else
      render nothing: true, status: 404
    end
  end

  private

  def user_params
    params.permit [:name, :score, :size, :offset]
  end
end
