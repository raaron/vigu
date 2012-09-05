module ApplicationHelper

  # Returns the full title on a per-page basis.
  def get_title(page_title)
    base_title = "Vision Guatemala"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end


  def parent_layout(layout)
    @view_flow.set(:layout,output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end
end