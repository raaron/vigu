require 'spec_helper'
include ApplicationHelper

describe "ApplicationHelper" do
  describe "test split_text" do
    let(:text)  { lorem(300) }

    it {
      result = split_text(text, 1, 200)
      result.length.should == 1
    }

    it {
      result = split_text(text, 2, 200)
      result.length.should == 2
      result[0] == text[0 .. 200]
    }

    it {
      result = split_text(text, 7, 20)
      result.length.should == 3
      result[0] == text[0 .. 200]
    }

    it {
      result = split_text("aa. bb.", 7, 1)
      result.length.should == 2
      result.should == ["aa. ", "bb."]
    }
  end

  describe "test split_after_sentence" do
    let(:text)  { "aa. bb." }
    describe "sign not present" do
      it {
        result = split_after_sentence(text, ["! "], 1)
        result.should == [text]
      }
    end

    describe "sign present" do
      it {
        result = split_after_sentence(text, [". ", "? "], 1)
        result.should == [text[0..2], text[3..-1]]
      }
    end

    describe "signs empty" do
      it {
        result = split_after_sentence(text, [], 1)
        result.should == [text]
      }
    end
  end

  describe "test show_text_with_links" do
    describe "when having two links" do
      it {
        result = show_text_with_links("asdf link    (d, www.google.com) qwerasdf link    (d, www.google.com) qwer", false)
        result.should == ["asdf ", ["d", "www.google.com"], "qwerasdf ", ["d", "www.google.com"], "qwer"]
      }
    end

    describe "when having no links" do
      it {
        result = show_text_with_links("asdf link", false)
        result.should == ["asdf link"]
      }
    end

    describe "when having links at the beginning" do
      it {
        result = show_text_with_links("link    (d, www.google.com) link    (d, www.google.com) qwer", false)
        result.should == [["d", "www.google.com"], ["d", "www.google.com"], "qwer"]
      }
    end

    describe "when having links at the end" do
      it {
        result = show_text_with_links("asdfasdf     link    (d, www.google.com) link    (d, www.google.com)", false)
        result.should == ["asdfasdf ", ["d", "www.google.com"], ["d", "www.google.com"]]
      }
    end

    describe "when having links at the end" do
      it {
        result = show_text_with_links("asdfasdf     link    (d, www.google.com) link    (d, www.google.com)qwer", false)
        result.should == ["asdfasdf ", ["d", "www.google.com"], ["d", "www.google.com"], "qwer"]
      }
    end
  end
end