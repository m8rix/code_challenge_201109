class SubmissionFormatsController < ApplicationController
  before_action :set_submission_format, only: [:show, :edit, :update, :destroy]

  # GET /submission_formats
  # GET /submission_formats.json
  def index
    @submission_formats = SubmissionFormat.all
  end

  # GET /submission_formats/1
  # GET /submission_formats/1.json
  def show
  end

  # GET /submission_formats/new
  def new
    @submission_format = SubmissionFormat.new
  end

  # GET /submission_formats/1/edit
  def edit
  end

  # POST /submission_formats
  # POST /submission_formats.json
  def create
    @submission_format = SubmissionFormat.new(submission_format_params)

    respond_to do |format|
      if @submission_format.save
        format.html { redirect_to @submission_format, notice: 'Submission format was successfully created.' }
        format.json { render :show, status: :created, location: @submission_format }
      else
        format.html { render :new }
        format.json { render json: @submission_format.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submission_formats/1
  # PATCH/PUT /submission_formats/1.json
  def update
    respond_to do |format|
      if @submission_format.update(submission_format_params)
        format.html { redirect_to @submission_format, notice: 'Submission format was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission_format }
      else
        format.html { render :edit }
        format.json { render json: @submission_format.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submission_formats/1
  # DELETE /submission_formats/1.json
  def destroy
    @submission_format.destroy
    respond_to do |format|
      format.html { redirect_to submission_formats_url, notice: 'Submission format was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission_format
      @submission_format = SubmissionFormat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def submission_format_params
      params.require(:submission_format).permit(:name, :code)
    end
end
