require 'spec_helper'
require 'tempfile'

describe(AvatarOMatic::Generator) do
  let(:config) { AvatarOMatic::Config }

  context 'initialization' do
    subject { described_class }

    AvatarOMatic::Config.properties.each do |prop|
      it "accepts #{prop} as a named argument" do
        expect(subject.new(prop => 1).send(prop)).to eq 1
      end
    end

    it 'accepts size as a named argument' do
      expect(subject.new(size: 24).size).to eq 24
    end

    it 'sets size to a default of 400' do
      expect(subject.new.size).to eq 400
    end

    it 'ignores non-valid arguments' do
      instance = subject.new(whatever: 20)
      expect(instance).to_not respond_to :whatever
    end

    it 'ignores non-symbol arguments' do
      expect(subject.new("size" => 1).size).to eq 400
    end
  end

  AvatarOMatic::Config.properties.each do |prop|
    context "##{prop} accessor" do
      let(:options) { config.options_for(subject.gender, prop) }

      it "defaults to a random value" do
        expect(subject.send(prop)).to be_between(0, options.size - 1)
      end

      it "is allowed to be set to an existing option" do
        subject.send(:"#{prop}=", 1)
        expect(subject.send(prop)).to eq 1
      end

      it "raises exception if set to an option that does not exist" do
        expect {
          subject.send(:"#{prop}=", 10000)
        }.to raise_error AvatarOMatic::InvalidPropertyError
      end
    end
  end

  context '#gender accessor' do
    it 'defaults to a random value' do
      expect(config.genders).to include subject.gender
    end

    it 'can be set to valid value' do
      subject.gender = :female
      expect(subject.gender).to eq :female
    end

    it 'raises exception if set to unsupported gender' do
      expect {
        subject.gender = :unsupported
      }.to raise_error AvatarOMatic::InvalidPropertyError
    end
  end


  describe '.generate!' do
    it 'returns itself' do
      allow(MiniMagick::Image).to receive(:new).and_return double.as_null_object
      expect(subject.generate!).to be subject
    end

    it 'generates a MiniMagick::Image object' do
      expect {
        subject.generate!
      }.to change {
        subject.image
      }.from(nil)
       .to(kind_of MiniMagick::Image)
    end

    it 'resizes resulting avatar to configured value' do
      subject.size = 64
      subject.generate!
      expect(subject.image.dimensions).to eq [64, 64]
    end
  end

  describe '.save' do
    let(:test_path) { Tempfile.new( "#{File.basename(__FILE__)}.png" ) }

    before(:each) do
      allow(subject).to receive(:generate!) do
        subject.instance_variable_set(:@image, MiniMagick::Image.new( File.expand_path(File.join('..', '..', 'data', 'test.png'), __FILE__)))
      end
    end

    it 'raises error if no image has been generated' do
      expect {
        subject.save test_path
      }.to raise_error AvatarOMatic::NoImageYetError
    end

    it 'saves generated image to specified location' do
      subject.generate!
      subject.save test_path
      stat = File.stat test_path

      expect(stat.size).to eq subject.image.size
      expect(stat).to be_file
    end
  end
end
