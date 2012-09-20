class Image < ActiveRecord::Base

  belongs_to :paragraph
  has_attached_file :photo, :styles => { :original => '250x250>', :small => "50*50" }
  attr_accessible :caption, :photo
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes

  def to_s
    "Image:\n\t\t\t\t" + ["ID: #{id}", "Caption: #{caption}"].join("\n\t\t\t\t")
  end
end
