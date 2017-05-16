class WelcomeController < ApplicationController
  def index
    flash[:notice] = "Goodmorning!"
  end
end
