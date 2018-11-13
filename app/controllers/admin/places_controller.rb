class Admin::PlacesController < ApplicationController
  before_action :authenticate_admin!
  def index
    @places = Place.all
  end

  def edit
    @place = Place.find(params[:id])
    @likes = @place.likes
  end

  def show
    @place = Place.find(params[:id])
    @likes = @place.likes
    @users = User.all
    @locations = @users.map(&:locations).flatten
    @frequency = location_frequency(@locations)
    @likes_by_cities = likes_by(:city)
    @likes_by_states = likes_by(:state)
    @likes_by_countries = likes_by(:country)
  end

  def create
  #   Place.find_or_create_by(
  #   name: params[:place][:name],
  #   address: params[:place][:address],
  #   phone_number: params[:place][:phone_number],
  #   category: params[:place][:category]
  #   )
    redirect_to admin_places_path
  end

  def delete
    @place = Place.find(params[:id])
    @place.destroy
    flash[:success] = "Place deleted"
    redirect_to admin_places_path
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    flash[:success] = "Place deleted"
    redirect_to admin_places_path
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

  def authenticate_admin!
    authenticate_user!
    redirect_to root_path, status: :forbidden unless current_user.admin?
  end

end
