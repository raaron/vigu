# == Schema Information
#
# Table name: paragraphs
#
#  id         :integer          not null, primary key
#  section    :string(255)
#  page_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Paragraph < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :paragraph_collection
  has_many :images, :dependent => :destroy
  attr_accessible :title, :body, :default_title, :default_body, :paragraph_collection, :images_attributes, :images, :date
  attr_accessor :title, :body, :default_title, :default_body
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => proc { |attributes| attributes['photo'].blank? }
  after_destroy :remove_translation
  validates :paragraph_collection,  presence: true

  after_initialize :init
  after_create :insert_empty_translation
  after_save :update_translation
  after_destroy :remove_translation

  def init
    self.date ||= Date.today
  end

  def get_title
    t(get_title_tag)
  end

  def get_default_title
    t_for_locale(I18n.default_locale, get_title_tag)
  end

  def get_body
    t(get_body_tag)
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
    if is_default_locale
      update_translations(I18n.default_locale, {get_title_tag => default_title})
      update_translations(I18n.default_locale, {get_body_tag => default_body})
    else
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
    ["ID: #{id}", "Title: #{I18n.translate(get_title_tag)}", "Date: #{date.to_s}", "Body: #{I18n.translate(get_body_tag)}"].join("\n\t\t\t") + "\n\t\t\t" +
    images.map{|i| i.to_s}.join("\n\t\t\t\t")
  end

  def update_caption_translation(pics_attributes)
    images.each do |image|
      image.update_translations_from_params(pics_attributes)
    end
  end

  def get_tag(part)
    [paragraph_collection.page.name, paragraph_collection.section, id, part].join('_')
  end

  def has_date?
    paragraph_collection.has_date?
  end

  def has_caption?
    paragraph_collection.has_caption?
  end

  def picture_mode
    paragraph_collection.picture_mode
  end
end
