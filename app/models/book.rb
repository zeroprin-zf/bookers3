class Book < ApplicationRecord

  has_one_attached :image
  has_one_attached :profile_image

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

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
