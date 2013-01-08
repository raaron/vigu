class Admin::PageController < Admin::ApplicationController

  before_filter :admin_user

end
