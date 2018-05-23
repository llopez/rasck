require 'rasck/version'
require 'rasck/checks/redis'
require 'rasck/checks/s3'
require 'rasck/middleware'
require 'rasck/config'

module Rasck
  class << self
    attr_accessor :config

    def run_checks
      all_checks.each_with_object({}) do |(name, prok), m|
        m[name] = prok.call(self)
      end
    end

    def all_checks
      config.built_in_checks.merge(config.custom_checks)
    end

    def configure
      self.config ||= Config.new
      yield(config)
    end
  end
end
