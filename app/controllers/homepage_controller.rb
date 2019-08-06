class HomepageController < ApplicationController
  def index
    if(params[:lat].present? and params[:lng].present?)
      @lat = params[:lat]&.to_f
      @lng = params[:lng]&.to_f
      @radius = params[:radius]&.to_i || 3000
      @locations = Location.within(@lat, @lng, @radius)
    else
      @locations = Location.all
    end    
  end

  def search
    @categories = Location.select(:category).map(&:category).uniq
    p @categories
    render 'homepage/search'
  end
end
