class Paragraph < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :page
  has_many :images, :dependent => :destroy
  attr_accessible :title, :body, :section, :page, :images_attributes, :images
  attr_accessor :body, :title
  accepts_nested_attributes_for :images, :reject_if => proc { |attributes| attributes['photo'].blank? }, :allow_destroy => true

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

  def insert_empty_translations
    insert_empty_translations_for_tag(get_title_tag)
    insert_empty_translations_for_tag(get_body_tag)
  end

  def to_s
    "Paragraph:\n\t\t\t" + ["ID: #{id}", "Title: #{title}", "Body: #{body}"].join("\n\t\t\t") + images.map{|i| i.to_s}.join("\n\t\t\t\t")
  end

  private
  def get_tag(part)
    [page.name, section, part, id].join('_')
  end
end
