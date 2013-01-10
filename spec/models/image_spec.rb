require 'spec_helper'
include ApplicationHelper
include ActionDispatch::TestProcess

describe Image do
  let(:home_page)  { Page.find_by_name("home") }
  let(:paragraph)  { home_page.get_paragraphs(:main).first }

  let(:default_caption)  { "caption spanish" }
  let(:caption)  { "caption english" }

  let(:new_default_caption)  { "new caption spanish" }
  let(:new_caption)  { "new caption english" }

  def should_change_translations_by(count)
    expect {yield}.to(change(Translation, :count).by(count))
  end

  def get_image_hash_without_id(filename)
    image = HashWithIndifferentAccess.new
    image[:default_caption] = default_caption
    image[:caption] = caption
    image[:photo] = fixture_file_upload(filename, 'image/png')
    return image
  end

  def get_image_hash_with_id(filename)
    image = get_image_hash_without_id(filename)
    image[:id] = @image.id
    return image
  end

  def get_new_images_hash
    new_image_params = HashWithIndifferentAccess.new
    new_image_params["0"] = get_image_hash_without_id('/foo.png')
    new_image_params["1"] = get_image_hash_without_id('/bar.png')
    return new_image_params
  end

  def get_update_images_hash
    update_image_params = HashWithIndifferentAccess.new
    update_image_params["0"] = get_image_hash_with_id('/foo.png')
    update_image_params["1"] = get_image_hash_with_id('/bar.png')
    return update_image_params
  end

  def check_insert_image
    should_change_translations_by(3) { @image.save }
    should_change_translations_by(0) { @image.update_translations_from_params(get_new_images_hash) }

    if is_default_locale
      @image.get_default_caption.should == default_caption
      @image.get_caption.should == default_caption
    else
      @image.get_caption.should == caption
    end
  end

  def check_update_image
    check_insert_image
    params = get_update_images_hash
    params["0"][:default_caption] = new_default_caption
    params["0"][:caption] = new_caption
    @image.update_translations_from_params(params)
    if is_default_locale
      @image.get_default_caption.should == new_default_caption
      @image.get_caption.should == new_default_caption
    else
      @image.get_caption.should == new_caption
    end
  end


  before do
    I18n.locale = :es
    @image = Image.new(paragraph: paragraph, :photo => File.new(Rails.root.join('spec', 'fixtures', 'foo.png'), 'r'))
  end

  subject { @image }

  it { should respond_to(:caption) }
  it { should respond_to(:default_caption) }
  it { should respond_to(:photo) }
  it { should respond_to(:paragraph) }
  it { should respond_to(:get_caption) }
  it { should respond_to(:get_default_caption) }
  it { should respond_to(:insert_empty_translation) }
  it { should respond_to(:remove_translation) }
  it { should respond_to(:update_translation) }
  it { should respond_to(:get_caption_tag) }
  it { should respond_to(:update_translations_from_params) }
  it { should respond_to(:width) }
  it { should respond_to(:height)}

  it { should be_valid }

  describe "when photo is not present" do
    before { @image.photo = nil }
    it { should_not be_valid }
  end

  describe "when creating a new image" do

    it "in default locale" do
      check_insert_image
    end

    describe "not in default locale" do
      before {I18n.locale = :de}
      it { check_insert_image }
    end
  end


  describe "when updating an existing image" do

    it "in default locale" do
      check_update_image
    end

    describe "not in default locale" do
      before {I18n.locale = :de}
      it { check_update_image }
    end
  end

  describe "when removing an image" do
    before { @image.save }
    it { should_change_translations_by(-3) { @image.destroy } }
  end

  describe "size and height stored" do
    before { @image.save }
    it {
      @image.width.should > 0
      @image.height.should > 0
      @image.get_small_width.should > 0
    }
  end
end
