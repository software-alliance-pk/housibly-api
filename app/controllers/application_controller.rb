class ApplicationController < ActionController::Base
  before_action :authenticate_admin!
  before_action :set_paper_trail_whodunnit

end