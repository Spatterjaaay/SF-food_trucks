class FoodtruckController < ApplicationController
  def index
    @foodtrucks = FoodtruckApiWrapper.new
  end
end
