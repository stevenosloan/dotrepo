require 'spec_helper'

describe Dotbox::DotFileManager do

  after :each do
    Given.cleanup!
  end

  describe "#initialize" do
    it "sets given source & destination" do
      subject = Dotbox::DotFileManager.new "source", "destination"

      expect( subject.source ).to eq "source"
      expect( subject.destination ).to eq "destination"
    end
  end

  describe "#dotfiles" do
    it "returns DotFiles" do
      Given.file '.bashrc'
      subject = Dotbox::DotFileManager.new Given::TMP, "destination"

      expect( subject.dotfiles.first ).to be_a Dotbox::DotFile
    end

    it "returns an array of only dotfiles from source" do
      Given.file '.bashrc'
      Given.file 'foo_bar'
      Given.file 'dir/.dot'
      Given.file 'dir/file'
      subject = Dotbox::DotFileManager.new Given::TMP, "destination"

      expect( subject.dotfiles.map { |df| df.path } ).to match_array [".bashrc","dir/.dot"]
    end
  end

  describe "#symlink_dotfiles" do
    it "calls symlink_to_destination on each dotfile" do
      dotfile_one = instance_double("Dotbox::DotFile")
      dotfile_two = instance_double("Dotbox::DotFile")

      subject = Dotbox::DotFileManager.new "source", "destination"
      allow( subject ).to receive(:dotfiles)
                      .and_return [dotfile_one, dotfile_two]

      expect( dotfile_one ).to receive(:symlink_to_destination)
      expect( dotfile_two ).to receive(:symlink_to_destination)

      subject.symlink_dotfiles
    end
  end

end