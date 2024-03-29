require 'spec_helper'

describe Dotrepo::DotFileManager do

  after :each do
    Given.cleanup!
  end

  describe "#initialize" do
    it "sets given expanded source & destination" do
      subject = Dotrepo::DotFileManager.new "source", "destination"

      expect( subject.source ).to eq File.expand_path("source")
      expect( subject.destination ).to eq File.expand_path("destination")
    end
  end

  describe "#dotfiles" do
    it "returns DotFiles" do
      Given.file '.bashrc'
      subject = Dotrepo::DotFileManager.new Given::TMP, "destination"

      expect( subject.dotfiles.first ).to be_a Dotrepo::DotFile
    end

    it "returns an array of only dotfiles from source" do
      Given.file '.bashrc'
      Given.file 'foo_bar'
      Given.file 'dir/.dot'
      Given.file 'dir/file'
      subject = Dotrepo::DotFileManager.new Given::TMP, "destination"

      expect( subject.dotfiles.map { |df| df.path } ).to match_array [".bashrc","dir/.dot"]
    end

    it "ignores git related files" do
      Given.file '.git/config'
      Given.file '.gitignore'
      subject = Dotrepo::DotFileManager.new Given::TMP, "destination"

      expect( subject.dotfiles.map { |df| df.path } ).to be_empty
    end
  end

  describe "#symlink_dotfiles" do
    it "calls symlink_to_destination on each dotfile" do
      dotfile_one = instance_double("Dotrepo::DotFile")
      dotfile_two = instance_double("Dotrepo::DotFile")

      subject = Dotrepo::DotFileManager.new "source", "destination"
      allow( subject ).to receive(:dotfiles)
                      .and_return [dotfile_one, dotfile_two]

      expect( dotfile_one ).to receive(:symlink_to_destination)
      expect( dotfile_two ).to receive(:symlink_to_destination)

      subject.symlink_dotfiles
    end
  end

end