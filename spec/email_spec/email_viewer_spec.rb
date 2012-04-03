require 'spec_helper'
require 'launchy'

describe EmailSpec::EmailViewer do
  describe ".open_in_browser" do
    it "should open with launchy" do
      expected_uri = URI("file://#{File.expand_path("a_file")}")
      Launchy.should_receive(:open).with(expected_uri)
      EmailSpec::EmailViewer.open_in_browser("a_file")
    end
  end

  describe ".open_in_text_editor" do
    it "should open with launchy" do
      expected_uri = URI("file://#{File.expand_path("a_file")}")
      Launchy.should_receive(:open).with(expected_uri, {application: :editor})
      EmailSpec::EmailViewer.open_in_text_editor("a_file")
    end
  end
end
