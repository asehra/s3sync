require 'spec_helper'

module S3sync
  RSpec.describe Bucket do
    describe "#objects" do
      def s3_objects(*keys)
        keys.map { |k| {key: k} }
      end

      let(:s3_client) do
        ::Aws::S3::Client.new(stub_responses: {
          list_objects: {contents: s3_objects(*object_keys)}
        })
      end

      let(:object_keys) { ["path/to/object", "ajf/ofj"] }

      subject { Bucket.new(client: s3_client, name: "test") }

      it "returns a list of files in the bucket" do
        expect(subject.objects.map(&:key)).to eq(object_keys)
      end
    end
  end
end
