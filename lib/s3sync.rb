require "s3sync/version"

module S3sync

  def self.synchronise(source, destination)
    source.files.each do |file|
      next if destination.files.find { |f| f.path == file.path && f.size == file.size }
      copy_path source, destination, file.path
    end
  end

  def self.copy_path(source, destination, path)

  end
end
