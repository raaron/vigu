class Paragraph < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :page
  has_many :images, :dependent => :destroy
  attr_accessible :title, :body, :section, :page, :images_attributes, :images
  attr_accessor :body, :title
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => proc { |attributes| attributes['photo'].blank? }
  after_destroy :remove_translation
  validates :section,  presence: true
  validates :body,  presence: true

  def get_title_tag
    get_tag('title')
  end

  def get_body_tag
    get_tag('body')
  end

  def update_translation
    update_translations({get_title_tag => title})
    update_translations({get_body_tag => body})
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
        image.caption = i[:caption]
        image.update_translation
      end
    end
  end
end
