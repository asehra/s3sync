require 'aws-sdk'

module S3sync
  class Bucket
    attr_reader :name, :client

    def initialize(client:,name:)
      @client = client
      @name = name
    end

    def objects
      client.list_objects(bucket: name).map do |object|
        object.contents
      end.flatten
    end

    def download(key, &block)
      file = Tempfile.new(File.basename(key))
      client.get_object(bucket: name, key: key) do |chunk|
        file.write(chunk)
      end
      file.rewind
      block.call file
    ensure
      file.close
      file.unlink
    end

    def upload(file, key)
      client.put_object(body: file, bucket: name, key: key)
    end

    def self.connect(url:,access_key_id:,secret_access_key:, region: "eu-west-1", bucket_name:)
      client = Aws::S3::Client.new(
        endpoint: url,
        credentials: Aws::Credentials.new(access_key_id, secret_access_key),
        region: region
      )
      Bucket.new(client: client, name: bucket_name)
    end
  end
end
