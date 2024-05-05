class RedisSubscriberJob
  include Sidekiq::Job

  def perform(ip_address, query)
    if ip_address.present? && query.present?
      redis = Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/0')
      Rails.logger.info "\n\nRedis subscriber job started\n\n"
      
      redis.psubscribe("__keyevent@0__:expired") do |on|
        on.pmessage do |pattern, channel, message|
          Rails.logger.info "Expired Key: #{message}\nIP address: #{ip_address}\nQuery: #{query}"
        end
      end
    end
  end
end
