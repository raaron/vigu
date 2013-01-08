require 'spec_helper'
include ApplicationHelper

describe Paragraph do
  let(:home_page)  { Page.find_by_name("home") }

  def should_change_translations_by(count)
    expect {yield}.to(change(Translation, :count).by(count))
  end

  def check_change_all_text
    should_change_translations_by(0) { @paragraph.update_attributes(default_title: new_default_title) }
    @paragraph.get_default_title.should == new_default_title
    should_change_translations_by(0) { @paragraph.update_attributes(default_body: new_default_body) }
    @paragraph.get_default_body.should == new_default_body

    should_change_translations_by(0) { @paragraph.update_attributes(title: new_title) }
    should_change_translations_by(0) { @paragraph.update_attributes(body: new_body) }

    if is_default_locale
      @paragraph.get_title.should == ""
      @paragraph.get_body.should == ""
    else
      @paragraph.get_title.should == new_title
      @paragraph.get_body.should == new_body
    end
  end

  before do
    @paragraph = Paragraph.new(paragraph_collection: home_page.paragraph_collections.find_by_section(:main),
                               default_title: "title spanish",
                               title: "title deutsch",
                               default_body: "body spanish",
                               body: "body deutsch",
                               date: Date.today)
  end

  subject { @paragraph }

  it { should respond_to(:default_title) }
  it { should respond_to(:title) }
  it { should respond_to(:default_body) }
  it { should respond_to(:body) }
  it { should respond_to(:paragraph_collection) }
  it { should respond_to(:images) }
  it { should respond_to(:date) }
  it { should respond_to(:get_title) }
  it { should respond_to(:get_default_title) }
  it { should respond_to(:get_body) }
  it { should respond_to(:get_default_body) }
  it { should respond_to(:update_translation) }
  it { should respond_to(:insert_empty_translation) }
  it { should respond_to(:remove_translation) }
  it { should respond_to(:update_caption_translation) }

  it { should be_valid }

  describe "if it does not belong to a paragraph_collection" do
    before { @paragraph.paragraph_collection = nil }
    it { should_not be_valid }
  end

  it "when inserting" do
    should_change_translations_by(6) { @paragraph.save }
    @paragraph.get_default_title.should == @paragraph.default_title
    @paragraph.get_default_body.should == @paragraph.default_body
  end

  describe "when updating an existing paragraph" do

    before { @paragraph.save }

    describe "update translations automatically" do
      let(:new_default_title)  { "new title spanish" }
      let(:new_title)  { "new title english" }
      let(:new_default_body)  { "new body spanish" }
      let(:new_body)  { "new body english" }

      it "in default locale" do
        check_change_all_text
      end

      describe "not in default locale" do
        before {I18n.locale = :de}
        it { check_change_all_text }
      end
    end

    it "when updating the date" do
      should_change_translations_by(0) { @paragraph.update_attributes(date: Date.yesterday) }
      should be_valid
      @paragraph.date.should == Date.yesterday
    end
  end

  describe "when removing a paragraph" do
    before { @paragraph.save }
    it { should_change_translations_by(-6) { @paragraph.destroy } }
  end

  describe "when updating an existing paragraph" do
    before {
      I18n.locale = :de
      @paragraph.save
      @paragraph.update_attributes({"default_title"=>"", "title"=>"newt", "default_body"=>"", "body"=>"new body", "date(3i)"=>"1", "date(2i)"=>"1", "date(1i)"=>"2013", "images_attributes"=>{"0"=>{"default_caption"=>"", "caption"=>""}}, "id"=>"7"})
    }
    it {
      Paragraph.last.get_title.should == "newt" }
  end
end
