# app/models/quote.rb

class Quote < ApplicationRecord
  belongs_to :user
  acts_as_taggable_on :tags, :authors, :book_titles # انواع تگ‌هایی که می‌خوایم داشته باشیم

  # اعتبارسنجی‌ها
  validates :content, presence: true
  validates :author, presence: true
  validates :book_title, presence: true

  has_many :likes, dependent: :destroy

  # متدهای Ransack برای تعیین فیلدهای قابل جستجو
  def self.ransackable_attributes(auth_object = nil)
    ["author", "book_title", "content", "created_at", "id", "likes_count", "updated_at", "user_id"]
  end

  # متدهای Ransack برای تعیین ارتباطات قابل جستجو (برای تگ‌ها)
  def self.ransackable_associations(auth_object = nil)
    ["tags"]
  end

  # اسکوپ سفارشی برای Ransack: جستجو در کلمات کلیدی (نویسنده، کتاب، تگ‌ها، محتوا)
  scope :keywords_cont, ->(keywords) do
    if keywords.present?
      # اطمینان از سازگاری روابط با حذف موقت readonly
      # tagged_with ممکن است روابط readonly برگرداند.
      author_quotes = tagged_with(keywords, on: :authors, any: true).unscope(:readonly)
      book_quotes = tagged_with(keywords, on: :book_titles, any: true).unscope(:readonly)
      tag_quotes = tagged_with(keywords, on: :tags, any: true).unscope(:readonly)
      content_quotes = where("content ILIKE ?", "%#{keywords}%").unscope(:readonly)

      # ترکیب روابط با OR
      author_quotes.or(book_quotes).or(tag_quotes).or(content_quotes)
    else
      all # اگر کلمه کلیدی نبود، همه را برگردان
    end
  end

  # اضافه کردن اسکوپ سفارشی به ransackable_scopes تا Ransack آن را بشناسد
  def self.ransackable_scopes(auth_object = nil)
    [:keywords_cont]
  end
end
