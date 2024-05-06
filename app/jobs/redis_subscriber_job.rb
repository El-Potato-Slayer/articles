class RedisSubscriberJob
  include Sidekiq::Job

  def perform()
    Rails.logger.info "\n\nRedis subscriber job started\n\n"
    to_create = []

    $redis.scan_each(match: "User:*") do |key|
      cached_data = Rails.cache.read(key)
      next unless cached_data

      query, timestamp_str = cached_data.split(':')
      timestamp = timestamp_str.to_i
      current_time = Time.now.to_i

      if current_time - timestamp >= 30
        user_email = key.gsub('User:', "")
        Rails.logger.info "\n\nFOUND! #{user_email}\n\n"
        to_create << { email: user_email, query: query }
        
        Rails.cache.delete(key)
        Rails.logger.info "\n\nDELETED! #{user_email}\n\n"
      end
    end

    SearchAnalytic.create(to_create) unless to_create.empty?
  end
end
