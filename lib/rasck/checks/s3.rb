module Rasck
  module Checks
    class S3
      def self.check
        s3 = ::Aws::S3::Client.new
        s3.list_buckets.successful?
      rescue StandardError
        false
      end
    end
  end
end
