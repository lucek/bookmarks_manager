class Site < ApplicationRecord
  validates_presence_of   :url, :user_id
  validates_uniqueness_of :url

  belongs_to :user
  has_many :bookmarks
end
