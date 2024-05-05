class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def index
    query = params[:search]
    if (query.present?)
      @articles = Article.where("title LIKE ?", "%#{params[:search]}%")
      # ip_address = "IP:#{request.remote_ip}"
      user_key = "User:#{current_user.email}"
      timed_query = "#{query}:#{DateTime.now.to_i}"

      # Rails.cache.write(user_key, timed_query, expires_in: 30.seconds)
      Rails.cache.write(user_key, timed_query)

      # SearchAnalyticJob.perform_async(user_key, query)
      # RedisSubscriberJob.perform_async(user_key, query)
    else
      @articles = Article.all
    end

    respond_to do |format|
      format.html do
        if request.xhr?
          render partial: "articles", locals: { articles: @articles }
        else
          render :index
        end
      end
    end
  end

  def show
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy!

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :body)
    end
end
