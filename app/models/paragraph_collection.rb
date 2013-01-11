class ParagraphCollection < ActiveRecord::Base
  attr_accessible :page, :section, :paragraphs_attributes, :has_date,
                  :has_caption, :picture_mode
  belongs_to :page
  has_many :paragraphs, :dependent => :destroy
  accepts_nested_attributes_for :paragraphs, :allow_destroy => true
  enum_attr :picture_mode, %w(zero at_most_one exactly_one any)
  validates :page,  presence: true
  validates :section,  presence: true
end
