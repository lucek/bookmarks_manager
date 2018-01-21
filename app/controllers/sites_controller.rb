class SitesController < ApplicationController
  before_action :authenticate_user

  def index
    @sites = current_user.sites
  end

  def destroy
    @site = current_user.sites.find(params[:id])

    if @site.destroy
      flash[:success] = "Site has been deleted!"
    else
      flash[:error] = "Site can't be deleted"
    end

    redirect_to sites_path
  end
end
