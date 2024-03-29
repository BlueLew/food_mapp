class PlacesController < ApplicationController
  before_action :authenticate_user!, only: %i[create edit update]

  def index
    @places = if params[:search].present?
                Place.perform_search(params[:search])
              else
                Place.all.order(name: :asc)
              end
    @place = Place.new
  end

  def show
    @place = Place.find(params[:id])
    @likes = @place.likes
    @users = User.all
    @locations = @users.map(&:locations).flatten
    # @frequency = location_frequency(@locations)
    @likes_by_cities = likes_by(:city)
    @likes_by_states = likes_by(:state)
    @likes_by_countries = likes_by(:country)
  end

  def likes
    @place = Place.find(params[:id])
    @likes = @place.likes
    @likes_by_cities = likes_by(:city)
    @likes_by_states = likes_by(:state)
    @likes_by_countries = likes_by(:country)
  end

  def update; end

  def edit; end

  def new
    @place = Place.new
  end

  def create
    if already_added?
      flash[:notice] = 'This restaurant has already been added!'
    else
      Place.find_or_create_by(
        name: params[:place][:name],
        address: params[:place][:address],
        phone_number: params[:place][:phone_number],
        category: params[:place][:category]
      )
      flash[:notice] = 'You have successfully added this restaurant to Food Mapp!'
    end
    redirect_to places_path
  end

  # def location_frequency(locations)
  #   {}.tap do |locations_by_frequency|
  #     locations.each do |location|
  #       location_city = "#{location.city}"
  #       location_state = "#{location.state}"
  #       location_country = "#{location.country}"

  #        location_name = "#{location.city}, #{location.state} #{location.country}"
  #         if locations_by_frequency[location_city]
  #          locations_by_frequency[location_city] += 1
  #         else
  #          locations_by_frequency[location_city]= 1
  #         end
  #         if locations_by_frequency[location_state]
  #          locations_by_frequency[location_state] += 1
  #         else
  #          locations_by_frequency[location_state]= 1
  #         end
  #         if locations_by_frequency[location_country]
  #          locations_by_frequency[location_country] += 1
  #         else
  #          locations_by_frequency[location_country]= 1
  #         end
  #     end
  #   end
  # end

  private

  def already_added?
    Place.where(id: params[:id]).exists?
  end

  def likes_by(geography)
    @place.locations.group_by(&geography).map do |group, locations|
      next if group.blank?

      {
        name: group,
        likes: locations.count
      }
    end.compact.sort_by do |group|
      group[:likes]
    end.reverse
  end
end
