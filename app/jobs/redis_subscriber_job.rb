class RedisSubscriberJob
  include Sidekiq::Job

  def perform()
    Rails.logger.info "\n\nRedis subscriber job started\n\n"

    $redis.scan_each(match: "IP:*") do |key|
      cached_data = Rails.cache.read(key)
      next unless cached_data

      query, timestamp_str = cached_data.split(':')
      timestamp = timestamp_str.to_i
      current_time = Time.now.to_i

      if current_time - timestamp >= 30
        ip_address = key.gsub('IP:', "")
        Rails.logger.info "\n\nFOUND! #{ip_address}\n\n"
        SearchAnalytic.create(ip_address: ip_address, query: query)
        
        Rails.cache.delete(key)
        Rails.logger.info "\n\nDELETED! #{ip_address}\n\n"
      end
    end

    # redis.psubscribe("__keyevent@0__:expired") do |on|
    #   on.pmessage do |pattern, channel, message|
    #     Rails.logger.info "Expired Key: #{message}\nIP address: #{ip_address}\nQuery: #{query}"
    #   end
    # end
  end
end
