require 'spec_helper'

describe Dotrepo::ConfigFile do

  before :each do
    allow( File ).to receive(:exists?)
                 .with( Dotrepo::ConfigFile::FILE_PATH )
                 .and_return( false )
  end

  describe "#initialize" do
    it "uses data from config file if present" do
      allow( File ).to receive(:exists?)
                   .with( Dotrepo::ConfigFile::FILE_PATH )
                   .and_return( true )

      allow( YAML ).to receive(:load_file)
                   .with( Dotrepo::ConfigFile::FILE_PATH )
                   .and_return( { "source" => "source",
                                  "destination" => "destination" })

      expect( described_class.new.data ).to eq({ "source" => "source",
                                                 "destination" => "destination" })
    end

    it "uses default data w/ no config file" do
      expect( described_class.new.data ).to eq({ "source" => "~/.dotbox/box",
                                                 "destination" => "~/" })
    end
  end

  describe "#source" do
    it "returns the 'source' from #data" do
      expect( described_class.new.source ).to eq "~/.dotbox/box"
    end
  end

  describe "#destination" do
    it "returns the 'destination' from #data" do
      expect( described_class.new.destination ).to eq "~/"
    end
  end

end