class CollectionsController < ApplicationController
  before_action :set_collection, only: %i[show edit update destroy]
  before_action :set_payment, only: %i[index show]
  before_action :set_category, only: %i[show create update]
  # run the increment method for each page load (show)
  before_action :increment, only: %i[show]
  load_and_authorize_resource

  layout '_base'
  # GET /collections
  def index
    # All collections which aren't expired or aren't sold, these are displayed on the index map for users to see
    @all_active_unsold_collections = Collection.where.not(id: Payment.pluck(:collection_id)).not_expired
    # The last 10 collections in the database, these are displayed for the latest activity section
    @latest_collections = @all_active_unsold_collections.last(10).reverse

    if can? :update, Collection
      # All the collections which belong to the current user, these are shown for the user table
      @current_user_collections = Collection.where(seller_id: current_user.id)
      # All the collections which the current user has sold, these are shown in the profile section
      @current_user_sold_collections = Collection.joins(:payment).where('payments.seller_id': current_user.id)
      # All the current users active collections, which are not sold and are not expired, these shown on the index table
      @active_collections = @current_user_collections.where.not(id: @current_user_sold_collections.ids).where('available_until >= ?', Time.now)
      # All the current users collections, which have expired but have not been sold, also shown on the index table
      @expired_unpaid_collections = @current_user_collections.where.not(id: @payments).where('available_until <= ?', Time.now)
    end

    # get the all the collections from the database and convert them to geojson for the map layer
    @geojson = build_geojson
    # set the gon variable to the geojson object to pass to the index map js file
    gon.geocollection = @geojson
  end

  # GET /collections/1
  def show
    # Passing the collection variable to JS for the free button
    gon.collection = @collection
    # Passing the current user to JS for the free button
    gon.current_user = current_user
    # Get the available until data for the collection
    @available_until = @collection.available_until
    # format the available_until datetime to the short style for better readability
    @time = @available_until.to_formatted_s(:short)
    # Seller stripe account, this is used for the destination. Get the seller id from the collection, then get the first (as it return an active record association), then get the sellers stripe id.
    @seller_stripe_id = User.where(id: @collection.seller_id).first.stripe_user_id

    # stripe session implementation
    if @collection.price > 0
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
            },
            transfer_data: {
              destination: @seller_stripe_id.to_s
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
        # Send off email notification to user
        UserNotifierMailer.send_collection_new_mail(current_user, @collection, @category).deliver
        # Reverse geocode the lat long selected in the collection and then add the address to the collection
        address = Geocoder.search([@collection.latitude, @collection.longitude])
        @collection.update_attribute(:address, address.first.address)

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
        # Send off email notification to user
        UserNotifierMailer.send_collection_update_mail(current_user, @collection, @category).deliver
        # Reverse geocode the lat long selected in the collection and then add the address to the collection
        address = Geocoder.search([@collection.latitude, @collection.longitude])
        @collection.update_attribute(:address, address.first.address)

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
      UserNotifierMailer.send_collection_new_mail(current_user, @collection, @category).deliver
      format.html { redirect_to collections_url, notice: 'Collection was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_collection
    @collection = Collection.find(params[:id])
  end

  def set_payment
    @payments = Payment.all
  end

  def set_category
    @category = Category.all
  end

  # Only allow a list of trusted parameters through.
  def collection_params
    params.require(:collection).permit(:user_id, :name, :description, :price, :quantity, :available_hours_morning, :available_hours_night, :available_until, :longitude, :latitude, :address, :image, category_ids: [])
  end

  # Ths is a helper method which will call the to_feature method in the model and produce the geoJSON object for the map
  def build_geojson
    {
      type: 'FeatureCollection',
      features: @all_active_unsold_collections.map(&:to_feature)
    }
  end

  # increment the visit count column each time the show method is called
  def increment
    @collection.increment!(:visit_count)
  end
end
