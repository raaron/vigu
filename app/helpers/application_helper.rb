module ApplicationHelper

  def is_in_admin_mode?
    is_admin? and Vigu::Application.config.is_in_admin_mode
  end

  def set_is_in_admin_mode(value)
    Vigu::Application.config.is_in_admin_mode = value
  end

  # * *Returns* : the full title on a per-page basis.
  def get_title(page_title)
    base_title = "Vision Guatemala"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def admin_title(name)
    "#{name.capitalize} Admin"
  end

  def update_translations(locale, translations)
    I18n.backend.store_translations(locale, translations)
  end

  def insert_empty_translations_for_tag(tag)
    [:en, :de, :es].each do |lang|
      I18n.backend.store_translations(lang, {tag => ''})
    end
  end

  def remove_translations_for_tag(tag)
    [:en, :de, :es].each do |lang|
      Translation.where(:key => tag).destroy_all
    end
  end

  def parent_layout(layout)
    @view_flow.set(:layout,output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def translate_newlines(text)
    return text.gsub("\n", '<br/>').html_safe
  end

  def t_add(symbol_noun)
    translate_combined(symbol_noun, :add)
  end

  def t_edit(symbol_noun)
    translate_combined(symbol_noun, :edit)
  end

  def t_insert(symbol_noun)
    translate_combined(symbol_noun, :insert)
  end

  def translate_combined(symbol_noun, symbol_verb)
    if I18n.locale == :de
      "#{t(symbol_noun)} #{t(symbol_verb)}"
    else
      "#{t(symbol_verb)} #{t(symbol_noun)}"
    end
  end

  def render_partial(name, locals={})
    render :partial => 'layouts/' + name.to_s, :locals => locals
  end

  def line_input(label_text, symbol, text='', form=nil, disabled=false)
    render_partial('line_input', {:label_text => label_text, :text => text,
                                  :symbol => symbol, :form => form,
                                  :disabled => disabled})
  end

  def line_input_title(symbol=:title, title='', form=nil, disabled=false)
    line_input(t(:title), symbol, title, form, disabled)
  end

  def line_input_caption(symbol=:caption, caption='', form=nil, disabled=false)
    line_input(t(:caption), symbol, caption, form, disabled)
  end

  def password_input(label_text, symbol, form=nil)
    render_partial('password_input', {:label_text => label_text,
                                      :symbol => symbol, :form => form})
  end

  def text_input(label_text, symbol, text='', form=nil, disabled=false)
    render_partial('text_input', {:label_text => label_text, :text => text,
                                  :symbol => symbol, :form => form,
                                  :disabled => disabled})
  end

  def text_input_body(symbol=:body, body='', form=nil, disabled=false)
    text_input(t(:body), symbol, body, form, disabled)
  end

  def paragraph_form(form=nil)
    render_partial('paragraph_form', {:form => form})
  end

  def labeled_check_box(label_text, symbol, form=nil)
    render_partial('labeled_check_box', {:label_text => label_text,
                                         :symbol => symbol,
                                         :form => form})
  end

  def check_box_destroy(form=nil)
    render_partial('labeled_check_box', {:label_text => t(:remove).capitalize,
                                         :symbol => :_destroy,
                                         :form => form})
  end

  def paragraphs_form(new_paragraph_path, update_path)
    render_partial('paragraphs_form', {:new_paragraph_path => new_paragraph_path,
                                       :update_path => update_path})
  end

  def list()
    render_partial(:list)
  end

  def t(tag)
    I18n.translate(tag)
  end

  def t_for_locale(locale, tag)
    begin
      I18n.backend.translate(locale, tag)
    rescue
      ""
    end
  end

  def log(txt, nr=0)
    logger.debug "----- #{nr}: #{txt}"
  end

  def is_default_locale
    I18n.locale == I18n.default_locale
  end

  # * *Returns* : Test text with the given +length+
  def lorem(length)
    txt = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum."
    while txt.length < length
      txt += txt
    end
    txt[0..length]
  end

  # * *Returns* : a random choice out of [left, right]
  def get_random_picture_floating
    ["right", "left"].sample
  end

  # Generates haml output for this +image+
  def get_image_block(image, css_class)
    haml_tag :div, :class => css_class, :style => "width:#{image.get_small_width}px" do
      haml_concat image_tag(image.photo.url(:small), :class => 'paragraph_image')
      haml_concat t(image.get_caption_tag)
    end
  end

  # Split the +text+ after the end of the sentence at +min_length+.
  # +signs+ is the list of sentence separators.
  # * *Returns* : a list of the resulting text blocks with length 1 (splitting)
  # impossible) or 2 (splitting successful).
  def split_after_sentence(text, signs=[". ", "? ", "! "], min_length)
    text_after_min_length = text[min_length + 1 .. -1]
    if signs.any? { |sign| text_after_min_length.include? sign }
      indexes = []
      signs.each do |sign|
        indexes << text_after_min_length.index(sign) if text_after_min_length.include? sign
      end
      split_index = min_length + indexes.min + 1
      return [text[0 .. split_index], text[split_index + 1 .. -1]]
    else
      return [text]
    end
  end

  # Split the given +text+ in +count+ pieces, all having length greater than
  # +min_length+. If the resulting pieces would be shorter than +min_length+,
  # the result consists of less than +count+ blocks.
  # The text is splitted after sentences only.
  # * *Returns* : the list of text blocks
  def split_text(text, count, min_length)
    if count <= 1
      return [text]
    else
      result = []
      step = [text.length / count, min_length].max
      start_index = 0
      while start_index + step < text.length do
        sentence_split = split_after_sentence(text[start_index .. -1], step)
        end_index = start_index + sentence_split.first.length

        result << text[start_index .. end_index]
        start_index = end_index + 1
      end
      if start_index < text.length
        result << text[start_index .. text.length]
      end
      return result
    end
  end


  # split a text by links of the form:
  # xxxx link (displayed_text, url) xxxxxxxxx
  # (all spaces may be zero or any number of spaces)
  # If haml_output is True: directly generate haml for all text and the links.
  # For testing, also return the results in a list.
  def show_text_with_links(text, haml_output=true, show_links_as_text=false)
    extract_regexp = /\s*link\s*\(\s*(.*?)\s*,\s*(.*?)\s*\)\s*/
    result = []
    while not text.empty?
      next_link = text.match(extract_regexp)
      if next_link.nil?
        result << text
        haml_concat text if haml_output
        text = ""
      else
        start = next_link.offset(0).first
        if start > 0
          t = text[0 .. start]
          result << t
          haml_concat t if haml_output
        end
        result << [next_link[1], next_link[2]]
        if haml_output
          if show_links_as_text
            haml_concat next_link[1]
          else
            haml_concat link_to(next_link[1], complete_url(next_link[2])) if haml_output
          end
        end
        text = text[next_link.offset(0).last .. -1]
      end
    end
    return result
  end

  # Prepend an url with the "http://" prefix if it is not already there.
  def complete_url(url)
    unless url[/^https?:\/\//]
      url = 'http://' + url
    end
    return url
  end

  # Distribute the images all over the text with a minimal distance in between.
  # If there is only one picture, it is positioned before the text.
  # If there are 2 pictures, they are positioned before and after the text
  # If there are more than 2 pictures, they are also positioned in between.
  # If not all pictures may be positioned within the text because of the minimal
  # distance, the rest is positioned after the text.
  def place_pictures_randomly(body, images)
    img_css_class = "picture #{get_random_picture_floating}"
    body = body
    splitted_body = split_text(body, images.length - 1, 500)
    if images.length > 1
      get_image_block(images.first, img_css_class)
      img_index = 1
      text_index = 0
      while text_index < splitted_body.length and img_index < images.length do
        show_text_with_links(splitted_body[text_index])
        get_image_block(images[img_index], img_css_class)

        img_index += 1
        text_index += 1
      end

      while img_index < images.length
        get_image_block(images[img_index], img_css_class)
        img_index += 1
      end
    else
      get_image_block(images.first, img_css_class) if images.length == 1
      show_text_with_links(body)
    end
  end
end