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

  ORIGINAL_WIDTH = 500
  SMALL_WIDTH = 50

  belongs_to :paragraph
  has_attached_file :photo, :styles => { :original => '#{ORIGINAL_WIDTH}*#{ORIGINAL_WIDTH}>', :small => "#{SMALL_WIDTH}*#{SMALL_WIDTH}" }
  attr_accessible :caption, :default_caption, :photo, :paragraph, :width, :height
  attr_accessor :caption, :default_caption
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes

  before_save :set_dimensions
  after_create :insert_empty_translation
  after_destroy :remove_translation

  def set_dimensions
    tempfile = self.photo.queued_for_write[:original]

    unless tempfile.nil?
      dimensions = Paperclip::Geometry.from_file(tempfile)
      self.width = dimensions.width
      self.height = dimensions.height
    end
  end

  def get_small_width
    if width > SMALL_WIDTH
      return SMALL_WIDTH
    else
      return width
    end
  end

  def get_caption
    t(get_caption_tag)
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

  def update_translation(default_cap, cap)
    if is_default_locale
      update_translations(I18n.default_locale, {get_caption_tag => default_cap})
    else
      update_translations(I18n.locale, {get_caption_tag => cap})
    end
  end

  def update_translations_from_params(images_attributes)
    images_attributes.values.each do |i|
      if i.has_key?(:id) && id == i[:id].to_i
        update_translation(i[:default_caption], i[:caption])
        break
      elsif i.has_key?(:photo) && photo.original_filename == i[:photo].original_filename
        update_translation(i[:default_caption], i[:caption])
        break
      end
    end
  end

  def to_s
    "Image:\n\t\t\t\t" + ["ID: #{id}", "Caption: #{I18n.translate(get_caption_tag)}"].join("\n\t\t\t\t")
  end

  def get_caption_tag
    paragraph.get_tag('image') + id.to_s
  end

end
