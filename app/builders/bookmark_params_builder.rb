module BookmarkParamsBuilder
  def self.build_bookmark_params(user, params)
    url      = params[:url]
    uri      = URI.parse(url)
    path     = uri.path
    host     = url.gsub(uri.path, "").downcase
    site_id  = Site.find_by_url(host).try(:id)
    errors   = []

    if !site_id
      site = user.sites.new(url: host)

      if site.save
        site_id = site.id
      else
        errors << site.errors.messages
      end
    end

    {
      bookmark: {
        title:      params[:title],
        url:        path,
        shortening: params[:shortening],
        site_id:    site_id,
        all_tags:   params[:all_tags]
      },
      errors: errors
    }
  end
end
