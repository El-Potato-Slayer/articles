class SearchAnalyticJob
  include Sidekiq::Job

  def perform()
    analytics = SearchAnalytic.select("MIN(id) as ID, query, COUNT(*) AS count").group("query").order("count DESC")    

    Rails.cache.write("search_analytics", analytics.to_a, expires_in: 10.minutes)
  end
end