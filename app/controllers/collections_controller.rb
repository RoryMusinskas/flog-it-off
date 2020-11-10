class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show edit update destroy]
  # run the increment method for each page load (show)
  before_action :increment, only: %i[show]
  load_and_authorize_resource

  layout '_base'
  # GET /collections
  # GET /collections.json
  def index
    # collections which aren't expired
    @collections = Collection.where('available_until  >= ?', Time.now)
    @expired_collections = current_user.collections.where('available_until <= ?', Time.now)
    @latest_collections = @collections.last(10)

    gon.collections = @collections
    # get the values from the database and convert them to geojson for the map layer
    @geojson = build_geojson
    # set the gon variable to the geojson object to pass to the index map js file
    gon.geocollection = @geojson
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    @category = Category.all
    @available_until = @collection.available_until
    # format the available until datetime to the short style for better readability
    @time = @available_until.to_formatted_s(:short)
  end

  # GET /collections/new
  def new
    @collection = Collection.new
    authorize! :create, @collection
  end

  # GET /collections/1/edit
  def edit
    gon.coordinates = [@collection.longitude, @collection.latitude]
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = current_user.collections.new(collection_params)

    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: 'Collection was successfully created.' }
        format.json { render :show, status: :created, location: @collection }
      else
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to collections_url, notice: 'Collection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_collection
    @collection = Collection.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def collection_params
    params.require(:collection).permit(:user_id, :name, :description, :price, :quantity, :available_hours_morning, :available_hours_night, :available_until, :longitude, :latitude, :image, category_ids: [])
  end

  def build_geojson
    {
      type: 'FeatureCollection',
      features: @collections.map(&:to_feature)
    }
  end

  # increment the visit count column each time the show method is called
  def increment
    @collection.increment!(:visit_count)
  end
end
