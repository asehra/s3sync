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

    def self.connect(url:,access_key_id:,secret_access_key:, region: "eu-west-1", bucket_name:)
      client = Aws::S3::Client.new(
        endpoint: url,
        credentials: Aws::Credentials.new(access_key_id, secret_access_key),
        region: region)
      Bucket.new(client: client, name: bucket_name)
    end
  end
end
