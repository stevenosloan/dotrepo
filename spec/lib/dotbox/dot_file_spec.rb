require 'spec_helper'

describe Dotbox::DotFile do

  describe "#initialize" do

    let(:manager_double) {
      instance_double("Dotbox::DotFileManager",
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
      instance_double("Dotbox::DotFileManager",
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

  describe "#symlink_to_destination!" do

    let(:manager_double) {
      double("Manager",
              source: "/source",
              destination: "/destination" )
    }
    let(:subject) { Dotbox::DotFile.new("/foo/bar", manager_double) }

    it "symlinks source to destination" do
      expect( File ).to receive(:symlink)
                    .with("/source/foo/bar","/destination/foo/bar")

      subject.symlink_to_destination!
    end
  end

  describe "#symlink_to_destination" do

    let(:manager_double) {
      double("Manager",
              source: "/source",
              destination: "/destination" )
    }
    let(:subject) {
      described_class.new "foo/bar", manager_double
    }

    context "when already linked" do
      it "skips linking" do
        subject = described_class.new ".path", manager_double
        allow( subject ).to receive(:linked?)
                        .and_return(true)

        expect( subject ).not_to receive(:symlink_to_destination!)
        subject.symlink_to_destination
      end
    end

    context "when destination exists as file" do

      before :each do
        allow( File ).to receive(:exist?).and_call_original
        allow( File ).to receive(:exist?)
                     .with("/destination/foo/bar")
                     .and_return(true)
        allow( subject ).to receive(:symlink_to_destination!) # just to kill it from trying to actually symlink anything
      end

      it "asks to backup or skip" do
        out = CatchAndRelease::Catch.stdout do
          CatchAndRelease::Release.stdin 'n' do
            subject.symlink_to_destination
          end
        end

        expect( out ).to match /^#{"/destination/foo/bar exists. backup existing file and link?"}/
      end

      context "user says skip" do
        it "skips linking" do
          expect( subject ).not_to receive(:symlink_to_destination!)

          CatchAndRelease::Release.stdin 'n' do
            subject.symlink_to_destination
          end
        end
      end

      context "user says backup" do
        it "backs up destination file" do
          expect( subject ).to receive(:backup_destination)

          CatchAndRelease::Release.stdin 'y' do
            subject.symlink_to_destination
          end
        end
        it "symlinks to destination" do
          allow( subject ).to receive(:backup_destination)
          expect( subject ).to receive(:symlink_to_destination!)

          CatchAndRelease::Release.stdin 'y' do
            subject.symlink_to_destination
          end
        end
      end
    end

    context "when destination doesn't exist" do

      before :each do
        allow( File ).to receive(:exist?)
                     .with("/destination/foo/bar")
                     .and_return(false)
      end

      it "symlinks file to destination" do
        expect( subject ).to receive(:symlink_to_destination!)
        subject.symlink_to_destination
      end

    end
  end

end