require 'spec_helper'

module S3sync
  RSpec.describe Bucket do
    def s3_objects(*keys)
      keys.map { |k| {key: k} }
    end

    def s3_client(responses)
      ::Aws::S3::Client.new(stub_responses: responses)
    end

    describe "#objects" do
      let(:list_objects_response) do
        { list_objects: {contents: s3_objects(*object_keys)} }
      end

      let(:object_keys) { ["path/to/object", "ajf/ofj"] }

      subject(:bucket) { Bucket.new(client: s3_client(list_objects_response), name: "test") }

      it "returns a list of files in the bucket" do
        expect(bucket.objects.map(&:key)).to eq(object_keys)
      end
    end

    describe "#download" do
      let(:object_contents) { "Contents of remote file" }
      let(:get_object_response) do
        { get_object: {body: object_contents} }
      end

      subject(:bucket) { Bucket.new(client: s3_client(get_object_response), name: "test") }

      it "downloads the object as a local file that can be accessed within a block" do
        block_executed = false
        bucket.download("some/key") do |file|
          contents = file.read
          expect(contents).to eq(object_contents)
          block_executed = true
        end
        expect(block_executed).to be(true)
      end

      it "deletes the file once once block is done executing" do
        file_reference = nil
        bucket.download("some/key") do |file|
          file_reference = file
        end
        expect { file_reference.read }.to raise_error(IOError)
      end
    end
  end
end
