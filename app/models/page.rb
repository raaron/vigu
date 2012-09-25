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
  has_many :paragraphs, :dependent => :destroy
  attr_accessible :name, :paragraphs_attributes
  accepts_nested_attributes_for :paragraphs, :allow_destroy => true

  def to_s
    "Page:\n\t\tID: #{id}\n\t\tName: #{name}\n\t\t" + paragraphs.map{|p| p.to_s}.join("\n\t\t")
  end
end
