class Group < ActiveRecord::Base
  belongs_to :user
  has_many :posts,dependent: :destroy
  # validates :title, :description, presence: true
  validates :title, :description, format: { with: /\A[a-zA-Z]+\z/,
    message: "only allows letters" }
  has_many :group_relationships
  has_many :members, through: :group_relationships, source: :user
  scope :recentt, -> { order("created_at DESC")}
end
