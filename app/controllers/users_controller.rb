class UsersController < ApplicationController
  def index
    @users = User.all
    @user = current_user
    @book = Book.new

  end

  def show
    @user = User.find(params[:id])
    @books = @user.books
  end

  def edit
  end

end
