require "bundler/setup"
require "s3sync"

class Fake
  class Bucket
    attr_accessor :files

    def initialize(files: [])
      @files = files
    end
  end

  class File
    attr_accessor :path, :size

    def initialize(path:, size:)
      @path = path
      @size = size
    end
  end

  def self.Files(*paths)
    paths.map { |path| File.new(path: path, size: rand(20)) }
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
