source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'bcrypt-ruby', '3.0.1'
gem 'acts_as_list'

group :development, :test do
  gem 'launchy'
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails', '2.11.0'
  gem 'guard-rspec', '0.5.5'
  gem 'haml-rails', '>= 0.3.4'
end

gem 'annotate', '2.5.0', group: :development

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem 'sass-rails',   '3.2.5'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
end

gem 'haml'
gem 'jquery-rails', '2.0.2'
# gem 'redis'
gem "paperclip", "~> 3.0"
gem 'i18n-active_record',
      :git => 'git://github.com/svenfuchs/i18n-active_record.git',
      :require => 'i18n/active_record'
gem 'enumerated_attribute', :git => 'git://github.com/jeffp/enumerated_attribute.git'

group :test do
  gem 'capybara', '1.1.2'
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
  gem 'rb-inotify', '~> 0.8.8'
  gem 'factory_girl_rails', '1.4.0'
end

group :production do
  gem 'pg', '0.12.2'
end
