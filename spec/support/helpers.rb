def t(tag)
  I18n.translate(tag)
end

def login(user)
  visit login_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Login"
end