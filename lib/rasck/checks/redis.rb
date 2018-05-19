module Rasck
  module Checks
    class Redis
      def self.check
        res = ::Redis.new(url: Rasck.config.redis_url).ping
        res == 'PONG'
      rescue StandardError
        false
      end
    end
  end
end
