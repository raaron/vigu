def t(tag)
  I18n.translate(tag)
end

def l(item)
  I18n.localize(item)
end

def login_user(user)
  visit login_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Login"
end

def select_date(date, options = {})
  raise ArgumentError, 'from is a required option' if options[:from].blank?
  field = options[:from].to_s

  select date.year.to_s,                    :from => "#{field}_1i"
  select t("date.month_names")[date.month], :from => "#{field}_2i"
  select date.day.to_s,                     :from => "#{field}_3i"
end

def check_selected_date(date, options = {})
  raise ArgumentError, 'from is a required option' if options[:from].blank?
  field = options[:from].to_s

  find_field("#{field}_1i").find('option[selected]').text.should == date.year.to_s
  find_field("#{field}_2i").find('option[selected]').text.should == t("date.month_names")[date.month]
  find_field("#{field}_3i").find('option[selected]').text.should == date.day.to_s
end

def set_locale_for_tests(locale)
  I18n.locale = locale
  app.default_url_options = { :locale => locale }
end

def set_default_locale_for_tests
  set_locale_for_tests(I18n.default_locale)
end

def set_non_default_locale_for_tests
  set_locale_for_tests(:de)
end