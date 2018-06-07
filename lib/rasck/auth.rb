module Rasck
  class Auth
    def initialize(env)
      @auth_header = env['HTTP_AUTHORIZATION']
    end

    def authorized?
      return true unless Rasck.config.auth_token
      return false unless token
      return false unless token == Rasck.config.auth_token
      true
    end

    def self.authorized?(env)
      new(env).authorized?
    end

    private

    def token
      return false unless @auth_header
      data = @auth_header.match(/^Bearer (.+)/)
      data &&
        data[1]
    end
  end
end
