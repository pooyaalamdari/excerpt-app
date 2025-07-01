class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  has_many :quotes, dependent: :destroy
  has_many :likes, dependent: :destroy
  # اضافه کردن Active Storage برای عکس پروفایل
  has_one_attached :avatar # این خط را اضافه کنید
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 20 }, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "فقط حروف انگلیسی، اعداد و خط زیرین مجاز است" }
  attribute :remove_avatar, :boolean, default: false # تعریف یک ویژگی مجازی
  after_save :purge_avatar, if: :remove_avatar # بعد از ذخیره، اگر remove_avatar true بود، عکس را حذف کن
  private
  def purge_avatar
    avatar.purge_later # حذف عکس به صورت asynchronous (در پس‌زمینه)
  end
end