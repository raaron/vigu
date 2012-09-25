# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  paragraph_id       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class Image < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :paragraph
  has_attached_file :photo, :styles => { :original => '250*250>', :small => "50*50" }
  attr_accessible :caption, :default_caption, :photo
  attr_accessor :caption, :default_caption
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes

  after_create :insert_empty_translation
  after_destroy :remove_translation

  def get_caption
    is_default_locale ? '' : t(get_caption_tag)
  end

  def get_default_caption
    t_for_locale(I18n.default_locale, get_caption_tag)
  end

  def insert_empty_translation
    insert_empty_translations_for_tag(get_caption_tag)
  end

  def remove_translation
    remove_translations_for_tag(get_caption_tag)
  end

  def update_translation(default_caption, caption)
    default_caption = default_caption
    caption = caption
    update_translations(I18n.default_locale, {get_caption_tag => default_caption})
    if !is_default_locale
      update_translations(I18n.locale, {get_caption_tag => caption})
    end
  end

  def to_s
    "Image:\n\t\t\t\t" + ["ID: #{id}", "Caption: #{I18n.translate(get_caption_tag)}"].join("\n\t\t\t\t")
  end

  def get_caption_tag
    paragraph.get_tag('image') + id.to_s
  end

end
