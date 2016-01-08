require 'spec_helper'

describe(AvatarOMatic::Config) do

  subject { described_class }

  describe '.image_lib' do
    it { is_expected.to respond_to :image_lib }

    # FIXME: test setting image lib, and see it's being used
  end

  describe '.properties' do
    it 'returns array of image properties' do
      expect(subject.properties).to eq [:background, :face, :clothes, :head, :eye, :mouth]
    end
  end

  describe '.types' do
    it 'returns array of possible types' do
      expect(subject.types).to eq [:male, :female]
    end
  end

  describe '.options_for' do
    described_class.properties.each do |p|
      described_class.types.each do |g|
        re_file = /\A
            #{described_class.image_lib} # Library path
          \/
          (?:.+\/)?
            #{p}    # Property
            \d+     # Serial
            \.png
          \Z/x

        it "returns list of images for #{g} #{p}" do
          expect( subject.options_for(g, p) ).to all match re_file
        end
      end
    end
  end

  context '.image_data' do
    subject { described_class.image_data }

    before(:each) {
      described_class.instance_variable_set(:'@_data', nil)
    }

    it 'data is populated on first access' do
      expect {
        subject
      }.to change {
        described_class.instance_variable_get(:'@_data')
      }.from nil
    end

    described_class.properties.each do |p|
      it { is_expected.to include :male   => a_hash_including( { p => kind_of(Array) } ) }
      it { is_expected.to include :female => a_hash_including( { p => kind_of(Array) } ) }
    end
  end
end