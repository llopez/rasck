module Rasck
  class Config
    attr_accessor :endpoint
    attr_accessor :redis_url
    attr_accessor :built_in_checks
    attr_accessor :custom_checks

    def initialize
      @endpoint = '/rasck/status'
      @redis_url = nil
      @built_in_checks = %w[redis s3]
      @custom_checks = {}
    end

    def add_custom_check(name, &block)
      @custom_checks[name] = block
    end
  end
end
