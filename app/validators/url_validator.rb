class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "must be a valid URL") unless url_valid?(value)
  end

  def url_valid?(url)
    uri = URI.parse(url) rescue false
    uri && host_valid?(uri)
  end

  private

  def host_valid?(uri)
    !uri.host.nil? && uri.host.match(/^(http|https):\/\/|[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/)
  end
end
