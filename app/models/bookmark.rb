class Bookmark < ApplicationRecord
  validates_presence_of   :title, :url, :site_id
  validates_uniqueness_of :url

  belongs_to :site
end
