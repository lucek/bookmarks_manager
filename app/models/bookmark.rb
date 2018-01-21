class Bookmark < ApplicationRecord
  validates_presence_of   :title, :url, :site_id
  validates_uniqueness_of :url

  belongs_to :site
  delegate :user, to: :site
  has_many :taggings
  has_many :tags, through: :taggings

  def full_url
    site.url + url
  end

  def all_tags=(names)
    self.tags = names.split(",").map do |name|
      self.user.tags.where(name: name.strip).first_or_create!
    end
  end

  def all_tags
    self.tags.map(&:name).join(", ")
  end
end
