require "bundler/setup"
require "s3sync"

class Fake
  class Bucket
    attr_accessor :objects

    def initialize(objects: [])
      @objects = objects
    end
  end

  class Object
    attr_accessor :key, :etag

    def initialize(key:, etag:)
      @key = key
      @etag = etag
    end
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
