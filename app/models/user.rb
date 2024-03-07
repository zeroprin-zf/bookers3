class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :read_counts, dependent: :destroy

  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  has_one_attached :profile_image

  def get_profile_image(width, height)#サイズ小さくしたい
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

 GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      #find_or_create_by データの検索と作成を自動的に判断して処理を行うrailsのメソッド
      #find_or_create_by(条件)の条件としたデータが存在するかどうかを判断したうえで
      #・存在する場合には、そのデータを返す
      #・存在しない場合には、新規作成する
      #!を付与することで処理がうまくいかなかった場合にエラーが発生するようになり不具合検知につながる
      #SecureRandom.urlsafe_base64 ランダムな文字列を生成するRubyのメソッド
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
  # is_deletedがtrueならfalseを返すようにしている
  def active_for_authentication?
    super && (is_active == true)
  end
end
