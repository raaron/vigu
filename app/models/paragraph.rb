class Paragraph < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :page
  has_many :images, :dependent => :destroy
  attr_accessible :title, :body, :default_title, :default_body, :section, :page, :images_attributes, :images
  attr_accessor :title, :body, :default_title, :default_body
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => proc { |attributes| attributes['photo'].blank? }
  after_destroy :remove_translation
  validates :section,  presence: true

  def get_title
    is_default_locale ? '' : t(get_title_tag)
  end

  def get_default_title
    t_for_locale(I18n.default_locale, get_title_tag)
  end

  def get_body
    is_default_locale ? '' : t(get_body_tag)
  end

  def get_default_body
    t_for_locale(I18n.default_locale, get_body_tag)
  end

  def get_title_tag
    get_tag('title')
  end

  def get_body_tag
    get_tag('body')
  end

  def update_translation
    update_translations(I18n.default_locale, {get_title_tag => default_title})
    update_translations(I18n.default_locale, {get_body_tag => default_body})
    if !is_default_locale
      update_translations(I18n.locale, {get_title_tag => title})
      update_translations(I18n.locale, {get_body_tag => body})
    end
  end

  def insert_empty_translation
    insert_empty_translations_for_tag(get_title_tag)
    insert_empty_translations_for_tag(get_body_tag)
  end

  def remove_translation
    remove_translations_for_tag(get_title_tag)
    remove_translations_for_tag(get_body_tag)
  end

  def to_s
    "Paragraph:\n\t\t\t" +
    ["ID: #{id}", "Title: #{I18n.translate(get_title_tag)}", "Body: #{I18n.translate(get_body_tag)}"].join("\n\t\t\t") + "\n\t\t\t" +
    images.map{|i| i.to_s}.join("\n\t\t\t\t")
  end

  def get_tag(part)
    [page.name, section, id, part].join('_')
  end

  def update_caption_translation(pics_attributes)
    pics_attributes.values.each do |i|
      if i.has_key?(:id)
        image = Image.find_by_id(i[:id])
        if image
          image.update_translation(i[:default_caption], i[:caption])
        end
      elsif i.has_key?(:photo)
        image = Image.find_by_photo_file_name(i[:photo].original_filename)
        if image
          image.update_translation(i[:default_caption], i[:caption])
        end
      end
    end
  end
end