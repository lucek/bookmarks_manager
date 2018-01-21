class BookmarksController < ApplicationController
  before_action :authenticate_user

  def index
    bookmarks = current_user.bookmarks

    if search_term = params[:search]
      bookmarks = bookmarks.select do |bookmark|
        bookmark.title.include?(search_term) ||
        bookmark.url.include?(search_term) ||
        bookmark.shortening && bookmark.shortening.include?(search_term) ||
        bookmark.site.url.include?(search_term) ||
        bookmark.tags.map(&:name).include?(search_term)
      end
    end

    if tag_id = params[:tag_id]
      bookmarks = bookmarks.select do |bookmark|
        bookmark.tags.map(&:id).include?(tag_id.to_i)
      end
    end

    if site_id = params[:site_id]
      bookmarks = bookmarks.select do |bookmark|
        bookmark.site_id == site_id.to_i
      end
    end

    @bookmarks = bookmarks
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
        flash[:error] = @bookmark.errors.full_messages.to_sentence
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
      flash[:error] = "Bookmark can't be deleted"
    end

    redirect_to dashboard_path
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:title, :url, :shortening, :all_tags)
  end
end
