class Tag < ApplicationRecord
  validates_presence_of :name, :user_id
  validates_uniqueness_of :name

  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :bookmarks, through: :taggings
end
