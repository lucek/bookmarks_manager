class DashboardController < ApplicationController
  before_action :authenticate_user

  def index
    @sites = current_user.sites
  end
end
