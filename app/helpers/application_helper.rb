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

  def line_input(label_text, symbol, text='', form=nil)
    render_partial('line_input', {:label_text => label_text, :text => text,
                                  :symbol => symbol, :form => form})
  end

  def line_input_title(symbol=:title, title='', form=nil)
    line_input(t(:title), symbol, title, form)
  end

  def line_input_caption(symbol=:caption, caption='', form=nil)
    line_input(t(:caption), symbol, caption, form)
  end

  def text_input(label_text, symbol, text='', form=nil)
    render_partial('text_input', {:label_text => label_text, :text => text,
                                  :symbol => symbol, :form => form})
  end

  def text_input_body(symbol=:body, body='', form=nil)
    text_input(t(:body), symbol, body, form)
  end

  def paragraph_form(form=nil)
    render_partial('paragraph_form', {:form => form})
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

  def paragraphs_form(new_paragraph_path, update_path)
    render_partial('paragraphs_form', {:new_paragraph_path => new_paragraph_path,
                                       :update_path => update_path})
  end

  def list()
    render_partial(:list)
  end

  def editable_list(edit_path)
    render_partial(:editable_list, {:edit_path => edit_path})
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

  def l(txt, nr=0)
    logger.debug "----- #{nr}: #{txt}"
  end

  def is_default_locale
    I18n.locale == I18n.default_locale
  end

end