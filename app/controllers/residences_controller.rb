class ResidencesController < ApplicationController
  before_action :set_residence, only: %i[edit update destroy]

  def index
    @residences = current_user.residences.ordered
  end

  def new
    @residence = current_user.residences.new
  end

  def edit
  end

  def create
    @residence = current_user.residences.new(residence_params)

    if @residence.save
      redirect_to residences_path, notice: "Residence added to your profile."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @residence.update(residence_params)
      redirect_to residences_path, notice: "Residence updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @residence.destroy!
    redirect_to residences_path, notice: "Residence removed.", status: :see_other
  end

  private
    def set_residence
      @residence = current_user.residences.find(params.expect(:id))
    end

    def residence_params
      params.expect(residence: [ :city, :state, :country, :latitude, :longitude ])
    end
end
