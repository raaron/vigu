class ParagraphCollection < ActiveRecord::Base
  attr_accessible :page, :section, :paragraphs_attributes
  belongs_to :page
  has_many :paragraphs, :dependent => :destroy
  accepts_nested_attributes_for :paragraphs, :allow_destroy => true
  validates :page,  presence: true
  validates :section,  presence: true
end
