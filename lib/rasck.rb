require 'rasck/version'
require 'rasck/checks/redis'
require 'rasck/checks/s3'
require 'rasck/middleware'

module Rasck
  mattr_accessor :redis_url
  self.redis_url = nil

  mattr_accessor :path
  self.path = '/rasck/status'

  mattr_accessor :built_in_checks
  self.built_in_checks = %w[redis s3]

  mattr_accessor :custom_checks
  self.custom_checks = {}

  def self.add_check(name, &block)
    custom_checks[name] = block
  end

  def self.run_checks
    all_checks.inject({}) do |m, v|
      case v
      when 'redis'
        m.merge v => Rasck::Checks::Redis.check if defined?(::Redis)
      when 's3'
        m.merge v => Rasck::Checks::S3.check if defined?(::Aws)
      else
        m.merge v => custom_checks[v].call(self)
      end
    end
  end

  def self.all_checks
    (built_in_checks + custom_checks.keys).map(&:to_s)
  end

  def self.config
    yield self
  end
end
