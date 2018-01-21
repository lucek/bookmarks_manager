class BookmarksController < ApplicationController
  before_action :authenticate_user

  def index
    search_term = params[:search]

    @bookmarks = if !search_term
      current_user.bookmarks
    else
      current_user.bookmarks.select do |bookmark|
        bookmark.title.include?(search_term) ||
        bookmark.url.include?(search_term) ||
        bookmark.shortening.include?(search_term) ||
        bookmark.site.url.include?(search_term) ||
        bookmark.tags.map(&:name).include?(search_term)
      end
    end
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
    params.require(:bookmark).permit(:title, :url, :shortening, :all_tags)
  end
end
