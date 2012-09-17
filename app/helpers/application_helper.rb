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

  def translate_newlines(text)
    return text.gsub("\n", '<br/>').html_safe
  end

  def render_partial(name, locals)
    render :partial => 'layouts/' + name, :locals => locals
  end

  def line_input(label_text, text='', symbol)
    render_partial('line_input', {:label_text => label_text, :text => text,
                                  :symbol => symbol})
  end

  def line_input_title(title='', symbol)
    line_input(t(:title), title, symbol)
  end

  def text_input(label_text, text='', symbol)
    render_partial('text_input', {:label_text => label_text, :text => text,
                                  :symbol => symbol})
  end

  def text_input_desctiption(descr='', symbol)
    text_input(t(:description), descr, symbol)
  end

end