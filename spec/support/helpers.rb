def t(tag)
  I18n.translate(tag)
end



def get_url(url)
  if url.last == '/'
    url = url[0..-2]
  end
  "/de#{url}"
end