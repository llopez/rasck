require 'rasck/version'
require 'rasck/checks/redis'
require 'rasck/checks/s3'
require 'rasck/middleware'
require 'rasck/config'

module Rasck
  class << self
    attr_accessor :config

    def run_checks
      all_checks.inject({}) do |m, v|
        case v
        when 'redis'
          m[v] = Rasck::Checks::Redis.check if defined?(::Redis)
        when 's3'
          m[v] = Rasck::Checks::S3.check if defined?(::Aws)
        else
          m[v] = config.custom_checks[v].call(self)
        end
        m
      end
    end

    def all_checks
      (
        config.built_in_checks +
        config.custom_checks.keys
      ).map(&:to_s)
    end

    def configure
      self.config ||= Config.new
      yield(config)
    end
  end
end
