##########################
# For using Redis as backend, use the following:
##########################

# TRANSLATION_STORE = Redis.new
# I18n.backend = I18n::Backend::Chain.new(I18n::Backend::KeyValue.new(TRANSLATION_STORE), I18n.backend)




##########################
# For using Active Record as backend, use the following:
##########################

require 'i18n/backend/active_record'
I18n.backend = I18n::Backend::Chain.new(I18n::Backend::ActiveRecord.new, I18n.backend)
I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Cache)