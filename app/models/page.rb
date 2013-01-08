# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Page < ActiveRecord::Base
  has_many :paragraph_collections, :dependent => :destroy
  attr_accessible :name, :paragraph_collections_attributes
  accepts_nested_attributes_for :paragraph_collections, :allow_destroy => true

  def get_paragraphs(section)
    paragraph_collections.find_by_section(section).paragraphs
  end

  def to_s
    "Page:\n\t\tID: #{id}\n\t\tName: #{name}\n\t\t" + paragraph_collection.first.paragraphs.map{|p| p.to_s}.join("\n\t\t")
  end
end
