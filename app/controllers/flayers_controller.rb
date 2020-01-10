class FlayersController < ApplicationController
  before_action :set_flayer, only: [:show, :edit, :update, :destroy]

  # GET /flayers
  # GET /flayers.json
  def index
    @flayers = Flayer.all
  end

  # GET /flayers/1
  # GET /flayers/1.json
  def show
  end

  # GET /flayers/new
  def new
    @flayer = Flayer.new
  end

  # GET /flayers/1/edit
  def edit
  end

  # POST /flayers
  # POST /flayers.json
  def create
    @flayer = Flayer.new(flayer_params)

    respond_to do |format|
      if @flayer.save
        format.html { redirect_to @flayer, notice: 'Flayer was successfully created.' }
        format.json { render :show, status: :created, location: @flayer }
      else
        format.html { render :new }
        format.json { render json: @flayer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flayers/1
  # PATCH/PUT /flayers/1.json
  def update
    respond_to do |format|
      if @flayer.update(flayer_params)
        format.html { redirect_to @flayer, notice: 'Flayer was successfully updated.' }
        format.json { render :show, status: :ok, location: @flayer }
      else
        format.html { render :edit }
        format.json { render json: @flayer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flayers/1
  # DELETE /flayers/1.json
  def destroy
    @flayer.destroy
    respond_to do |format|
      format.html { redirect_to flayers_url, notice: 'Flayer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_flayer
      @flayer = Flayer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flayer_params
      params.require(:flayer).permit(:tittle, :image)
    end
end
