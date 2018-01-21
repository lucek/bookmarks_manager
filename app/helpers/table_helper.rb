module TableHelper
  def build_table(headers, collection)
    render "shared/table", headers: headers, collection: collection
  end

  def get_row_to_render(item)
    case item.class.name.underscore.to_sym
    when :bookmark
      bookmark_row(item)
    when :site
      site_row(item)
    when :tag
      tag_row(item)
    end
  end

  def bookmark_row(bookmark)
    render "bookmarks/bookmark_row", bookmark: bookmark
  end

  def tag_row(tag)
    render "tags/tag_row", tag: tag
  end

  def site_row(site)
    render "sites/site_row", site: site
  end
end
