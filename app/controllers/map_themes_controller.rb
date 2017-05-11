class MapThemesController < ApplicationController
  before_action :set_map_theme, only: [:show, :edit, :update, :destroy]

  # GET /map_themes
  # GET /map_themes.json
  def index
    @map_themes = MapTheme.all
  end

  # GET /map_themes/1
  # GET /map_themes/1.json
  def show
  end

  # GET /map_themes/new
  def new
    @map_theme = MapTheme.new
  end

  # GET /map_themes/1/edit
  def edit
  end

  # POST /map_themes
  # POST /map_themes.json
  def create
    @map_theme = MapTheme.new(map_theme_params)

    respond_to do |format|
      if @map_theme.save
        format.html { redirect_to @map_theme, notice: 'Map theme was successfully created.' }
        format.json { render action: 'show', status: :created, location: @map_theme }
      else
        format.html { render action: 'new' }
        format.json { render json: @map_theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /map_themes/1
  # PATCH/PUT /map_themes/1.json
  def update
    respond_to do |format|
      if @map_theme.update(map_theme_params)
        format.html { redirect_to @map_theme, notice: 'Map theme was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @map_theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /map_themes/1
  # DELETE /map_themes/1.json
  def destroy
    @map_theme.destroy
    respond_to do |format|
      format.html { redirect_to map_themes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_map_theme
      @map_theme = MapTheme.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def map_theme_params
      params.require(:map_theme).permit(:map, :song_id)
    end
end
