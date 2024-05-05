class SearchAnalyticsController < ApplicationController
  before_action :set_search_analytic, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def index
    SearchAnalyticJob.perform_async
    @job_started = true
  end

  def results 
    analytics = Rails.cache.read("search_analytics")
    if analytics
      render json: {status: :ok, analytics: analytics}
    else
      render json: {status: :processing, status: :accepted}
    end
  end

  def show
  end

  def new
    @search_analytic = SearchAnalytic.new
  end

  def edit
  end

  def create
    @search_analytic = SearchAnalytic.new(search_analytic_params)

    respond_to do |format|
      if @search_analytic.save
        format.html { redirect_to search_analytic_url(@search_analytic), notice: "Search analytic was successfully created." }
        format.json { render :show, status: :created, location: @search_analytic }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @search_analytic.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @search_analytic.update(search_analytic_params)
        format.html { redirect_to search_analytic_url(@search_analytic), notice: "Search analytic was successfully updated." }
        format.json { render :show, status: :ok, location: @search_analytic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @search_analytic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @search_analytic.destroy!

    respond_to do |format|
      format.html { redirect_to search_analytics_url, notice: "Search analytic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_search_analytic
      @search_analytic = SearchAnalytic.find(params[:id])
    end

    def search_analytic_params
      params.require(:search_analytic).permit(:ip_address, :query)
    end
end
