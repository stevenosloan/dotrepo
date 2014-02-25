require 'spec_helper'

describe Dotbox::DotFile do

  describe "#initialize" do

    let(:manager_double) {
      double("Manager",
              source: "/source",
              destination: "/destination" )
    }
    let(:subject) { Dotbox::DotFile.new("/foo/bar", manager_double) }

    it "sets the given path" do
      expect( subject.path ).to eq "/foo/bar"
    end

    it "sets up source & destination" do
      expect( subject.source ).to eq "/source/foo/bar"
      expect( subject.destination ).to eq "/destination/foo/bar"
    end

  end

  describe "#source_exists?" do

    let(:manager_double) {
      double("Manager",
              source: "/source",
              destination: "/destination" )
    }
    let(:subject) { Dotbox::DotFile.new("/foo/bar", manager_double) }

    it "is true if source exists" do
      allow( File ).to receive(:exist?).with("/source/foo/bar")
                   .and_return(true)

      expect( subject.source_exists? ).to be_truthy
    end
    it "is false if source doesn't exist" do
      allow( File ).to receive(:exist?).with("/source/foo/bar")
                   .and_return(false)

      expect( subject.source_exists? ).to be_falsy
    end
  end

  describe "#destination_exists?" do

    let(:manager_double) {
      double("Manager",
              source: "/source",
              destination: "/destination" )
    }
    let(:subject) { Dotbox::DotFile.new("/foo/bar", manager_double) }

    it "is true if destination exists" do
      allow( File ).to receive(:exist?).with("/destination/foo/bar")
                   .and_return(true)

      expect( subject.destination_exists? ).to be_truthy
    end
    it "is false if destination doesn't exist" do
      allow( File ).to receive(:exist?).with("/destination/foo/bar")
                   .and_return(false)

      expect( subject.destination_exists? ).to be_falsy
    end
  end

  describe "#backup_destination" do
    let(:manager_double) {
      double("Manager",
              source: "/source",
              destination: "/destination" )
    }
    let(:subject) { Dotbox::DotFile.new("/foo/bar", manager_double) }

    it "moves destination file to backup name" do
      expect( File ).to receive(:rename)
                         .with("/destination/foo/bar", "/destination/foo/bar.bak")

      subject.backup_destination
    end
  end

  describe "linked?" do
    let(:manager_double) {
      double("Manager",
              source: "/source",
              destination: "/destination" )
    }
    let(:subject) { Dotbox::DotFile.new("/foo/bar", manager_double) }


    it "is false if destination doesn't exist" do
      allow( File ).to receive(:exist?)
                   .with("/destination/foo/bar")
                   .and_return(false)

      expect( subject.linked? ).to be_falsy
    end

    it "is true if destination is linked to source" do
      allow( File ).to receive(:exist?)
                   .with("/destination/foo/bar")
                   .and_return(true)
      allow( File ).to receive(:symlink?)
                   .with("/destination/foo/bar")
                   .and_return(true)
      allow( File ).to receive(:readlink)
                   .with("/destination/foo/bar")
                   .and_return("/source/foo/bar")

      expect( subject.linked? ).to be_truthy
    end

    it "is false if destination is a file" do
      allow( File ).to receive(:exist?)
                   .with("/destination/foo/bar")
                   .and_return(true)
      allow( File ).to receive(:symlink?)
                   .with("/destination/foo/bar")
                   .and_return(false)

      expect( subject.linked? ).to be_falsy
    end

    it "is false if destination is linked not to source" do
      allow( File ).to receive(:exist?)
                   .with("/destination/foo/bar")
                   .and_return(true)
      allow( File ).to receive(:symlink?)
                   .with("/destination/foo/bar")
                   .and_return(true)
      allow( File ).to receive(:readlink)
                   .with("/destination/foo/bar")
                   .and_return("/not/source/path")

      expect( subject.linked? ).to be_falsy
    end
  end

  describe "#symlink_to_destination" do

    let(:manager_double) {
      double("Manager",
              source: "/source",
              destination: "/destination" )
    }
    let(:subject) { Dotbox::DotFile.new("/foo/bar", manager_double) }

    it "symlinks source to destination" do
      expect( File ).to receive(:symlink)
                    .with("/destination/foo/bar","/source/foo/bar")

      subject.symlink_to_destination
    end
  end

end