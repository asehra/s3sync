require "s3sync/version"
require "s3sync/bucket"

module S3sync

  def self.synchronise(source, destination)
    source.objects.each do |object|
      next if destination.objects.find { |o| o.key == object.key && o.etag == object.etag }
      copy_object source, destination, object.key
    end
  end

  def self.copy_object(source, destination, key)
    source.download(key) do |local_file|
      destination.upload(local_file, key)
    end
  end
end
