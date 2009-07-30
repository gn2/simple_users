class Admin::BaseController < BaseController
  
  before_filter :require_user, :require_admin
  layout 'admin'
  
end
