class PlacesController < ApplicationController

  def index
    if params[:search].present?
      @places = Place.perform_search(params[:search])
    else
      @places = Place.all
    end
    @place = Place.new
  end

  def show
    @place = Place.find(params[:id])
    @likes = @place.likes
    @users = User.all
    @locations = @users.map(&:locations).flatten
    #@frequency = location_frequency(@locations)
    @likes_by_cities = likes_by(:city)
    @likes_by_states = likes_by(:state)
    @likes_by_countries = likes_by(:country)
  end

  def update
  end

  def edit
  end

  def new
    @place = Place.new
  end

  def create
    #before_action :authenticate_user!
    Place.find_or_create_by(
      name: params[:place][:name],
      address: params[:place][:address],
      phone_number: params[:place][:phone_number],
      category: params[:place][:category]
      )
    redirect_to places_path
  end

  def location_frequency(locations)
    {}.tap do |locations_by_frequency|
      locations.each do |location|
        location_city = "#{location.city}"
        location_state = "#{location.state}"
        location_country = "#{location.country}" 
        
         location_name = "#{location.city}, #{location.state} #{location.country}"
          if locations_by_frequency[location_city]
           locations_by_frequency[location_city] += 1
          else
           locations_by_frequency[location_city]= 1
          end
          if locations_by_frequency[location_state]
           locations_by_frequency[location_state] += 1
          else
           locations_by_frequency[location_state]= 1
          end
          if locations_by_frequency[location_country]
           locations_by_frequency[location_country] += 1
          else
           locations_by_frequency[location_country]= 1
          end
      end
    end
  end

private

  def likes_by(geography)
    @place.locations.group_by(&geography).map { |group, locations|
      unless group.blank?
        {
          name: group,
          likes: locations.count 
        } 
      end
    }.compact.sort_by { |group| 
      group[:likes]
    }.reverse
  end
end
