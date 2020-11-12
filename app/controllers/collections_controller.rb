class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show edit update destroy]
  # run the increment method for each page load (show)
  before_action :increment, only: %i[show]
  load_and_authorize_resource

  layout '_base'
  # GET /collections
  def index
    # All collections
    # @collections = Collection.all
    # All collections which aren't expired or aren't sold, for the index map
    @all_active_unsold_collections = Collection.joins(:payment).where('payments.collection_id': @collections.ids).not_expired
    # All the collections which belong to the current user
    @current_user_collections = Collection.where(seller_id: current_user.id)
    # All the collections which the current user has sold
    @current_user_sold_collections = Collection.joins(:payment).where('payments.seller_id': current_user.id)
    # The last 10 collections in the database
    @latest_collections = Collection.where('available_until >= ?', Time.now).last(10).reverse

    if can? :update, Collection
      # All the current users active collections, which are not sold and are not expired
      @active_collections = @current_user_collections.where.not(id: @current_user_sold_collections.ids).where('available_until >= ?', Time.now)
      # All the current users collections, which have expired but have not been sold
      @expired_unpaid_collections = @current_user_collections.where.not(id: @current_user_sold_collections.ids).where('available_until <= ?', Time.now)
    end

    # get the values from the database and convert them to geojson for the map layer
    @geojson = build_geojson
    # set the gon variable to the geojson object to pass to the index map js file
    gon.geocollection = @geojson
  end

  # GET /collections/1
  def show
    @category = Category.all
    @available_until = @collection.available_until
    # format the available until datetime to the short style for better readability
    @time = @available_until.to_formatted_s(:short)

    # stripe session implementation
    if @collection.price != 0
      if user_signed_in?
        @session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          customer_email: current_user.email,
          line_items: [{
            name: @collection.name,
            description: @collection.description,
            images: [@collection.image],
            amount: (@collection.price * 100).to_i,
            currency: 'aud',
            quantity: 1
          }],
          payment_intent_data: {
            metadata: {
              collection_id: @collection.id,
              buyer_id: current_user.id,
              seller_id: @collection.seller_id
            }
          },
          success_url: "#{root_url}payments/success?collectionId=#{@collection.id}",
          cancel_url: "#{root_url}collections"
        )
        @session_id = @session.id
      end
    end
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
  def create
    @collection = current_user.collections.new(collection_params)

    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: 'Collection was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /collections/1
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /collections/1
  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to collections_url, notice: 'Collection was successfully destroyed.' }
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
