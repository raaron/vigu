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

  def update_translations(translations)
    I18n.backend.store_translations(I18n.locale, translations)
  end

  def insert_empty_translations_for_tag(tag)
    [:en, :de, :es].each do |lang|
      I18n.backend.store_translations(lang, {tag => ''})
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

  def line_input(label_text, symbol, text='', form=nil)
    render_partial('line_input', {:label_text => label_text, :text => text,
                                  :symbol => symbol, :form => form})
  end

  def line_input_title(title='', form=nil)
    line_input(t(:title), :title, title, form)
  end

  def line_input_caption(caption='', form=nil)
    line_input(t(:caption), :caption, caption, form)
  end

  def text_input(label_text, symbol, text='', form=nil)
    render_partial('text_input', {:label_text => label_text, :text => text,
                                  :symbol => symbol, :form => form})
  end

  def text_input_body(body='', form=nil)
    text_input(t(:body), :body, body, form)
  end

  def paragraph_form(paragraph, form=nil)
    render_partial('paragraph_form', {:paragraph => paragraph, :form => form})
  end

  def pic_input(form=nil)
    render_partial('pic_input', {:form => form})
  end

  def pic_input_with_caption(form=nil)
    pic_input(form) +
    line_input_caption('', form)
  end

  def pic_display(image, size=:small, form=nil)
    image_tag image.photo.url(size)
  end

  def pic_display_with_caption_input(image, size, form=nil)
    pic_display(image, size, form) +
    line_input_caption(image.caption, form)
    # line_input_caption(t(image.get_caption_tag), form)
  end

  def pic_form(image, form=nil)
    render_partial('pic_form', {:image => image, :form => form})
  end

  def pics_form(images, form=nil)
    render_partial('pics_form', {:images => images, :form => form})
  end

  def labeled_check_box(label_text, symbol, form=nil)
    render_partial('labeled_check_box', {:label_text => label_text,
                                         :symbol => :_destroy,
                                         :form => form})
  end

  def check_box_destroy(form=nil)
    render_partial('labeled_check_box', {:label_text => t(:remove).capitalize,
                                         :symbol => :_destroy,
                                         :form => form})
  end

  def paragraph_form(paragraph, form=nil)
    render_partial('paragraph_form', {:paragraph => paragraph,
                                      :form => form})
  end

  def paragraphs_form(new_paragraph_path, update_path, page, form=nil)
    render_partial('paragraphs_form', {:page => page,
                                       :new_paragraph_path => new_paragraph_path,
                                       :update_path => update_path,
                                       :form => form})
  end


end