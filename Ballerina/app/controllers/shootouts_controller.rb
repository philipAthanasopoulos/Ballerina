class ShootoutsController < ApplicationController
  before_action :set_shootout, only: %i[ show edit update destroy ]

  # GET /shootouts or /shootouts.json
  def index
    @shootouts = Shootout.all
  end

  # GET /shootouts/1 or /shootouts/1.json
  def show
  end

  # GET /shootouts/new
  def new
    @shootout = Shootout.new
  end

  # GET /shootouts/1/edit
  def edit
  end

  # POST /shootouts or /shootouts.json
  def create
    @shootout = Shootout.new(shootout_params)

    respond_to do |format|
      if @shootout.save
        format.html { redirect_to @shootout, notice: "Shootout was successfully created." }
        format.json { render :show, status: :created, location: @shootout }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shootout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shootouts/1 or /shootouts/1.json
  def update
    respond_to do |format|
      if @shootout.update(shootout_params)
        format.html { redirect_to @shootout, notice: "Shootout was successfully updated." }
        format.json { render :show, status: :ok, location: @shootout }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shootout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shootouts/1 or /shootouts/1.json
  def destroy
    @shootout.destroy!

    respond_to do |format|
      format.html { redirect_to shootouts_path, status: :see_other, notice: "Shootout was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shootout
      @shootout = Shootout.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def shootout_params
      params.fetch(:shootout, {})
    end
end
