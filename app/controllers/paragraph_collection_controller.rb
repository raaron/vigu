class ParagraphCollectionController < ApplicationController

  def new(paragraph)
    paragraph.position = paragraphs.maximum(:position)
    paragraphs = [] unless paragraphs
    paragraphs << paragraph
    paragraph.insert_empty_translation
  end

end
