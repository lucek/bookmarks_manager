class TagsController < ApplicationController
  before_action :authenticate_user

  def index
    @tags = current_user.tags
  end

  def destroy
    @tag = current_user.tags.find(params[:id])

    if @tag.destroy
      flash[:success] = "Tag has been deleted!"
    else
      flash[:error] = "Tag can't be deleted"
    end

    redirect_to tags_path
  end
end
