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
    attr_accessor :key, :size

    def initialize(key:, size:)
      @key = key
      @size = size
    end
  end

  def self.Objects(*keys)
    keys.map { |key| Object.new(key: key, size: rand(20)) }
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
