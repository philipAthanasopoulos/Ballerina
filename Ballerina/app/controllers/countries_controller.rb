class CountriesController < ApplicationController
  before_action :set_country, only: %i[ show edit update destroy ]

  # GET /countries or /countries.json
  def index
    @countries = Country.all
  end

  # GET /countries/1 or /countries/1.json
  def show
    start_year = params[:start_year].to_i
    end_year = params[:end_year].to_i

    @games = Game.joins('INNER JOIN countries AS home_countries ON games.home_team_id = home_countries.id')
                 .joins('INNER JOIN countries AS away_countries ON games.away_team_id = away_countries.id')
                 .where('games.home_team_id = :country_id OR games.away_team_id = :country_id', country_id: @country.id)
                 .where('EXTRACT(YEAR FROM games.date) BETWEEN :start_year AND :end_year', start_year: start_year, end_year: end_year)
    puts @games
  end

  # GET /countries/new
  def new
    @country = Country.new
  end

  # GET /countries/1/edit
  def edit
  end

  # POST /countries or /countries.json
  def create
    @country = Country.new(country_params)

    respond_to do |format|
      if @country.save
        format.html { redirect_to @country, notice: "Country was successfully created." }
        format.json { render :show, status: :created, location: @country }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /countries/1 or /countries/1.json
  def update
    respond_to do |format|
      if @country.update(country_params)
        format.html { redirect_to @country, notice: "Country was successfully updated." }
        format.json { render :show, status: :ok, location: @country }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1 or /countries/1.json
  def destroy
    @country.destroy!

    respond_to do |format|
      format.html { redirect_to countries_path, status: :see_other, notice: "Country was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_country
    @country = Country.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def country_params
    params.fetch(:country, {})
  end
end
