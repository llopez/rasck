module Rasck
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      path = env['PATH_INFO']

      if path == '/rasck/status'
        response = Rasck.run_checks.to_json

        [200, {}, [response]]
      else
        @app.call(env)
      end
    end
  end
end
