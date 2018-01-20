class BookmarksController < ApplicationController
  before_action :authenticate_user

  def index
    @sites = current_user.sites
  end

  def new
    @bookmark = Bookmark.new
  end

  def create
    @bookmark    = Bookmark.new
    built_params = BookmarkParamsBuilder.build_bookmark_params(current_user, params[:bookmark])

    if built_params[:errors].empty?
      @bookmark.attributes = built_params[:bookmark]

      if @bookmark.save
        flash[:success] = "Bookmark #{@bookmark.full_url} has been created!"
        redirect_to dashboard_path
      else
        # flash[:error] = @bookmark.errors
        redirect_to new_bookmark_path
      end
    else
      flash[:error] = built_params[:errors].join(", ")
      redirect_to new_bookmark_path
    end
  end

  def edit
    @bookmark = current_user.bookmarks.find(params[:id])
  end

  def update
    @bookmark  = current_user.bookmarks.find(params[:id])
    new_params = BookmarkParamsBuilder.build_bookmark_params(current_user, params[:bookmark])

    if new_params[:errors].empty?
      if @bookmark.update_attributes(new_params[:bookmark])
        flash[:success] = "Bookmark has been updated!"
        redirect_to dashboard_path
      else
        # flash[:error] = @bookmark.errors.inspect
        redirect_to edit_bookmark_path(@bookmark)
      end
    else
      flash[:error] = new_params[:errors].join(", ")
      redirect_to edit_bookmark_path(@bookmark)
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find(params[:id])

    if @bookmark.destroy
      flash[:success] = "Bookmark has been deleted!"
    else
      flash[:error] = "Bookmark can't be destroyed"
    end

    render :index
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:title, :url, :shortening)
  end
end
