require 'json'

module Rasck
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      path = env['PATH_INFO']

      if path == Rasck.config.endpoint
        response = Rasck.run_checks.to_json

        [200, { 'Content-Type' => 'application/json' }, [response]]
      else
        @app.call(env)
      end
    end
  end
end
