class BundlesController < ApplicationController
  before_action :set_bundle, only: [:show, :edit, :update, :destroy]

  # GET /bundles
  # GET /bundles.json
  def index
    @bundles = Bundle.all
  end

  # GET /bundles/1
  # GET /bundles/1.json
  def show
  end

  # GET /bundles/new
  def new
    @bundle = Bundle.new
  end

  # GET /bundles/1/edit
  def edit
  end

  # POST /bundles
  # POST /bundles.json
  def create
    @bundle = Bundle.new(bundle_params)

    respond_to do |format|
      if @bundle.save
        format.html { redirect_to @bundle, notice: 'Bundle was successfully created.' }
        format.json { render :show, status: :created, location: @bundle }
      else
        format.html { render :new }
        format.json { render json: @bundle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bundles/1
  # PATCH/PUT /bundles/1.json
  def update
    respond_to do |format|
      if @bundle.update(bundle_params)
        format.html { redirect_to @bundle, notice: 'Bundle was successfully updated.' }
        format.json { render :show, status: :ok, location: @bundle }
      else
        format.html { render :edit }
        format.json { render json: @bundle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bundles/1
  # DELETE /bundles/1.json
  def destroy
    @bundle.destroy
    respond_to do |format|
      format.html { redirect_to bundles_url, notice: 'Bundle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bundle
      @bundle = Bundle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bundle_params
      params.require(:bundle).permit(:size, :price, :submission_format_id)
    end
end
