class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create_oauth
    login = env["omniauth.auth"]["extra"]["raw_info"]["login"]

    if login
      user = User.find_by username: login

      if user && user.github
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      elsif user && !user.github
        redirect_to signin_path, notice: "username is already taken"
      else
        githubUser = User.new(username: login, enabled: true, github: true)
        githubUser.save(validate: false)
        session[:user_id] = githubUser.id
        redirect_to user_path(githubUser), notice: "Thank you for registering!"
      end
    end
  end

  def create
    user = User.find_by username: params[:username]

    if user && user.disabled
      redirect_to :back, notice: "your account is froze, plase contact an admin"
    elsif user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to :root
  end

end