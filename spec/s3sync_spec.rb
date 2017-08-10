require "spec_helper"

RSpec.describe S3sync do
  it "has a version number" do
    expect(S3sync::VERSION).not_to be nil
  end

  describe '.synchronise' do
    context 'when a file in source bucket does not exist in destination bucket' do
      it 'copies the file to destination bucket' do
        source = Fake::Bucket.new(objects: Fake::Objects('test/file'))
        destination = Fake::Bucket.new

        expect(S3sync).to receive(:copy_object).with(source, destination, 'test/file')
        S3sync.synchronise(source, destination)
      end
    end

    context 'when a file in source bucket exists in destination bucket' do
      it 'does not copy the file to destination bucket' do
        source = Fake::Bucket.new(objects: [Fake::Object.new(key: 'test/file', size: 30)])
        destination = Fake::Bucket.new(objects: [Fake::Object.new(key: 'test/file', size: 30)])

        expect(S3sync).to_not receive(:copy_object).with(source, destination, 'test/file')
        S3sync.synchronise(source, destination)
      end
    end

    context 'when multiple files need to be synced' do
      it 'does not copy the matching files to destination bucket' do
        existing_file = Fake::Object.new(key: 'test/file', size: 30)
        source = Fake::Bucket.new(objects: [
          Fake::Object.new(key: 'missing/file/1', size: 50),
          Fake::Object.new(key: 'test/file', size: 30),
          Fake::Object.new(key: 'another/folder/with/missing/file', size: 20)
        ])
        destination = Fake::Bucket.new(objects: [Fake::Object.new(key: 'test/file', size: 30)])

        expect(S3sync).to receive(:copy_object).with(source, destination, 'missing/file/1')
        expect(S3sync).to receive(:copy_object).with(source, destination, 'another/folder/with/missing/file')
        expect(S3sync).to_not receive(:copy_object).with(source, destination, existing_file.key)
        S3sync.synchronise(source, destination)
      end
    end

    context 'when a file exists in both buckets but has different sizes' do
      it 'copies the file to destination bucket' do
        source = Fake::Bucket.new(objects: [Fake::Object.new(key: 'test/file', size: 10)])
        destination = Fake::Bucket.new(objects: [Fake::Object.new(key: 'test/file', size: 20)])

        expect(S3sync).to receive(:copy_object).with(source, destination, 'test/file')
        S3sync.synchronise(source, destination)
      end
    end
  end

  describe '.copy_object' do
    let(:path) { 'test/file' }
    let(:local_path) { 'local/path' }
    let(:source) { Fake::Bucket.new(objects: [path])}
    let(:destination) { Fake::Bucket.new }

    it 'downloads the file locally and uploads to destination' do
      expect(source).to receive(:download).with(path).and_yield(local_path)
      expect(destination).to receive(:upload).with(local_path, path)
      S3sync.copy_object(source, destination, path)
    end
  end
end
