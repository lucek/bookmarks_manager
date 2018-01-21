module BookmarkParamsBuilder
  def self.build_bookmark_params(user, params)
    url      = params[:url]
    host     = url.split('/')[0,3].join('/')
    path     = url.gsub(host, "")
    path     = !path.empty? ? path : "/"
    site_id  = Site.find_by_url(host).try(:id)
    errors   = []

    if !site_id
      site = user.sites.new(url: host)

      if site.save
        site_id = site.id
      else
        errors << site.errors.full_messages.to_sentence
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
