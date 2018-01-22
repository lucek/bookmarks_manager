class Site < ApplicationRecord
  validates_presence_of   :url, :user_id
  validates_uniqueness_of :url
  validates               :url, url: true

  before_validation :add_url_protocol

  belongs_to :user
  has_many :bookmarks, dependent: :destroy


  private

  def add_url_protocol
    if !self.url.nil?
      unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
        self.url = "http://#{self.url}"
      end
    end
  end
end
