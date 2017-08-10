require 'aws-sdk'

module S3sync
  class Bucket
    def initialize(client:,name:)
      @client = client
      @name = name
    end

    def objects
      @client.list_objects(bucket: @name).map do |object|
        object.contents
      end.flatten
    end
  end
end
