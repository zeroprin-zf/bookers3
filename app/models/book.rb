class Book < ApplicationRecord

  has_one_attached :image
  has_one_attached :profile_image

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :week_favorites, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }
  has_many :read_counts, dependent: :destroy

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
   scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
   scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
   scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day)         }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end


  def get_image #profileimageに代わるかも
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')#ここでデフォルトの画像を変えられる
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image
  end

  def get_profile_image(width, height)#サイズ小さくしたい
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end
