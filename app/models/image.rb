class Image < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :paragraph
  has_attached_file :photo, :styles => { :original => '250*250>', :small => "50*50" }
  attr_accessible :caption, :photo
  attr_accessor :caption
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes

  after_create :insert_empty_translation
  after_destroy :remove_translation

  def insert_empty_translation
    insert_empty_translations_for_tag(get_caption_tag)
  end

  def remove_translation
    remove_translations_for_tag(get_caption_tag)
  end

  def update_translation(cap)
    caption = cap
    update_translations({get_caption_tag => caption})
  end

  def to_s
    "Image:\n\t\t\t\t" + ["ID: #{id}", "Caption: #{I18n.translate(get_caption_tag)}"].join("\n\t\t\t\t")
  end

  def get_caption_tag
    paragraph.get_tag('image') + id.to_s
  end

end
