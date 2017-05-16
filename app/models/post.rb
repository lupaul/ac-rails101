class Post < ActiveRecord::Base
  validates :content, presence: true
  belongs_to :user
  belongs_to :group, counter_cache: :posts_count
  scope :recent, -> { order("created_at DESC")}
end
